
#
#  build.sh
#  version 2.4.2
#
#  Created by Sergey Balalaev on 20.08.15.
#  Copyright (c) 2015-2023 ByteriX. All rights reserved.
#

PROJECT_NAME=""
CONFIGURATION_NAME="Release"
SCHEME_NAME=""
SETUP_VERSION=auto
IS_PODS_INIT=false
IS_TAG_VERSION=false
HAS_BITCODE=false
HAS_TESTING=false
HAS_IPA_BUILD=true
IS_APP_STORE=false
OUTPUT_NAME=""
TEAM_ID=""
TEST_DESTINATION="platform=iOS Simulator,name=iPhone 13,OS=15.0"
TEST_PLAN=""
SRC_DIR="${PWD}"

EXPORT_PLIST=""
PROVISIONING_PROFILE="" #reserver

USERNAME=""
PASSWORD=""
API_KEY=""
API_ISSUER=""
AUTH_KEY=""

GOOGLE_SERVICE_PLIST=""

# get parameters of script

POSITIONAL=()

#if [ "$#" -le 3 ] && [ "$1" != "-h" ]; then
#    echo -e '\nSomething is missing... Type "./build -h" without the quotes to find out more...\n'
#    exit 0
#fi

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -p|--project)
    PROJECT_NAME="$2"
    shift # past argument
    shift # past value
    ;;
    -c|--configuration)
    CONFIGURATION_NAME="$2"
    shift # past argument
    shift # past value
    ;;
    -s|--scheme)
    SCHEME_NAME="$2"
    shift # past argument
    shift # past value
    ;;
    -u|--user)
    USERNAME="$2"
    PASSWORD="$3"
    if [ "$PASSWORD" == "" ]; then
        echo "ERROR: $1 need 2 parameters"
        exit
    fi
    IS_APP_STORE=true
    shift # past argument
    shift # past value 1
    shift # past value 2
    ;;
    -key|--key)
    API_KEY="$2"
    API_ISSUER="$3"
    AUTH_KEY="$4"
    if [ "$AUTH_KEY" == "" ]; then
        echo "ERROR: $1 need 3 parameters"
        exit
    fi
    IS_APP_STORE=true
    shift # past argument
    shift # past value 1
    shift # past value 2
    shift # past value 3
    ;;
    -v|--version)
    SETUP_VERSION="$2"
    shift # past argument
    shift # past value
    ;;
    -o|--output)
    OUTPUT_NAME=$2
    shift # past argument
    shift # past value
    ;;
    -t|--team)
    TEAM_ID=$2
    shift # past argument
    shift # past value
    ;;
    -ep|--exportPlist)
    EXPORT_PLIST="$2"
    shift # past argument
    shift # past value
    ;;
    -gsp|--googlePlist)
    GOOGLE_SERVICE_PLIST=$2
    shift # past argument
    shift # past value
    ;;
    -ip|--initPods)
    IS_PODS_INIT=true
    shift # past argument
    ;;
    -at|--addTag)
    IS_TAG_VERSION=true
    shift # past argument
    ;;
    -bc|--bitcode)
    HAS_BITCODE=true
    shift # past argument
    ;;
    -test|--test)
    TEST_VALUE=""
    if [[ ! "$2" =~ ^- ]]; then
        TEST_DESTINATION="$2"
        TEST_VALUE="$2"
    fi
    HAS_TESTING=true
    HAS_IPA_BUILD=false
    shift # past argument
    if [ "$TEST_VALUE" != "" ]; then
        shift # past value
    fi
    ;;
    -tp|--testPlan)
    TEST_PLAN="$2"
    shift # past argument
    shift # past value
    ;;
    -h|--help)
    echo ""
    echo "Help for call build script with parameters:"
    echo "  -p, --project        : name of project or workspase. Requered param."
    echo "  -c, --configuration  : name of configuration. Default is Release."
    echo "  -s, --scheme         : name of target scheme. Default is the same as project name."
    echo "  -u, --user           : 2 params: login password. It specialized user, who created in Connection of developer programm. If defined then App will be uploaded to Store."
    echo "  -key, --key          : 3 params: apiKey, apiIssuer and path to key with p8. It specialized user, who created in Connection of developer programm. If defined then App will be uploaded to Store."
    echo "  -v, --version        : number of bundle version of the App. If has 'auto' value then will be detected from tags. Default auto."
    echo "  -o, --output         : name of out ipa file. Default is SchemeName.ipa."
    echo "  -t, --team           : team identifier of your developer program for a upload IPA to Connection AppSore. If defined -ep doesn't meater and export plist will created automaticle."
    echo "  -ep, --exportPlist   : export plist file. When team is empty has default value of AdHoc.plist or AppStore.plist when defined -t/--team."
    echo "  -gsp, --googlePlist  : path to GoogleService.plist with information for sending to Firebase/Crashlytics"
    echo "  -ip, --initPods      : If selected then will update Pods as is as from 'Pods.lock' in a start. Default is not selected."
    echo "  -at, --addTag        : If selected then will add Tag after build. Default is not selected."
    echo "  -bc, --bitcode       : If selected then will export with bitcode (when defined team). Default is not selected."
    echo "  -test, --test        : If selected then will build and run tests for special destination who you can choise. Default is not selected. Example of destination: 'platform=iOS Simulator,name=iPhone 12,OS=14.0'"
    echo "  -tp, --testPlan      : If selected then with -test will use selected test plane after that"
    echo ""
    echo "Emample: sh build.sh -p ProjectName -ip -t --version auto\n\n"
    exit 0
    ;;
    *)
    shift
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

# Common Settings


# Initalize

APP_BUILD_PATH="${SRC_DIR}/.build"
BUILD_DIR="${APP_BUILD_PATH}/xcode"
APP_CURRENT_BUILD_PATH="${APP_BUILD_PATH}/Current"
APP_CONFIG_PATH="./build.config"
BUILD_VERSION_TAG_GROUP_NAME="build"
PROJECT_PLIST="${PROJECT_NAME}/Resources/Plists/Info.plist"

# Setup skiped parameters init

if [ "$PROJECT_NAME" == "" ]; then
    echo "ERROR: Expected project name from build parameters. Please read the help (call with -h or -help)."
    exit 1
fi
if [ "$SCHEME_NAME" == "" ]; then
    SCHEME_NAME=$PROJECT_NAME
fi
if [ "$OUTPUT_NAME" == "" ]; then
    OUTPUT_NAME="${SCHEME_NAME}"
fi
if [ "$EXPORT_PLIST" == "" ]; then
    if [ "$USERNAME" == "" ]; then
        EXPORT_PLIST="./AdHoc.plist"
    else
        EXPORT_PLIST="./AppStore.plist"
    fi
fi

if [ -f "${PROJECT_NAME}.xcworkspace/contents.xcworkspacedata" ]; then
    XCODE_PROJECT="-workspace ${PROJECT_NAME}.xcworkspace"
    echo "Using for workspace: ${XCODE_PROJECT}\n"
else
    XCODE_PROJECT="-project ${PROJECT_NAME}.xcodeproj"
    echo "Start for project: ${XCODE_PROJECT}\n"
fi

# Setup version

if [ "$SETUP_VERSION" == "auto" ]; then
    echo "Pulling all tags from remote"
    git fetch --tags --force
        
    # get templated version number as max from git tags:
    VERSION_TAG=$(git tag --list "${BUILD_VERSION_TAG_GROUP_NAME}/*" | awk "/$BUILD_VERSION_TAG_GROUP_NAME\/[0-9.]+$"'/{print $0}' | sed -n "s/$BUILD_VERSION_TAG_GROUP_NAME\/\(\S*\)/\1/p" | awk '{if(min==""){min=$1}; if(max==""){max=$1}; if($1>max) {max=$1}; if($1<min) {min=$1}; total+=$1; count+=1} END {print max}')
    echo "Last tag version is $VERSION_TAG\n"

    if [[ $VERSION_TAG =~ ^[0-9]+$ ]]
    then
        VERSION_TAG=$((VERSION_TAG+1))
    else
        VERSION_TAG=1
    fi
    echo "Auto detect version has value: $VERSION_TAG\n"
    echo "CURRENT_PROJECT_VERSION=$VERSION_TAG" > "$APP_CONFIG_PATH"
else
    echo "CURRENT_PROJECT_VERSION=$SETUP_VERSION" > "$APP_CONFIG_PATH"
fi

. "$APP_CONFIG_PATH"

# Create execution

checkExit(){
    if [ $? != 0 ]; then
        echo "Building failed\n"
        exit 1
    fi
}

# Functions

clearCurrentBuild(){
    rm -rf "${BUILD_DIR}"
    rm -r -f -d "${APP_CURRENT_BUILD_PATH}"
}

createIPA()
{
    local CONFIGURATION_NAME=$1
    local SCHEME_NAME=$2
    local EXPORT_PLIST=$3
    local PROVISIONING_PROFILE=$4

    local ACTION="clean archive"
    APP_DIR="${BUILD_DIR}/${CONFIGURATION_NAME}-iphoneos"
    APP="${APP_DIR}/${PROJECT_NAME}.app"
    ARCHIVE_PATH="${BUILD_DIR}/${SCHEME_NAME}.xcarchive"
    
    clearCurrentBuild
    mkdir -p "${APP_CURRENT_BUILD_PATH}"
    
    PROVISIONING_PROFILE_PARAMS=""
    if [ "${PROVISIONING_PROFILE}" != "" ]; then
        PROVISIONING_PROFILE_PARAMS="PROVISIONING_PROFILE=${PROVISIONING_PROFILE}"
    fi
    
    xcodebuild \
    -allowProvisioningUpdates \
    -configuration ${CONFIGURATION_NAME} $XCODE_PROJECT \
    -scheme ${SCHEME_NAME} \
    -sdk iphoneos \
    -xcconfig "${APP_CONFIG_PATH}" BUILD_DIR="${BUILD_DIR}" \
    -archivePath "${ARCHIVE_PATH}" $PROVISIONING_PROFILE_PARAMS $ACTION

    if [ TEAM_ID != "" ] ; then
        EXPORT_PLIST="${APP_CURRENT_BUILD_PATH}/Export.plist"
        echo "Creating export plist:"
        createExportPlist "${EXPORT_PLIST}"
        cat "$EXPORT_PLIST"
        checkExit
        echo "Export plist was created in ${EXPORT_PLIST}\n"
    fi
    
    checkExit
    echo "Creating .ipa for ${APP} ${APP_CURRENT_BUILD_PATH} ${SIGNING_IDENTITY} ${PROVISIONING_PROFILE}\n"
    

    xcodebuild \
    -allowProvisioningUpdates \
    -exportArchive \
    -archivePath "${ARCHIVE_PATH}" \
    -exportOptionsPlist "${EXPORT_PLIST}" \
    -exportPath "${APP_CURRENT_BUILD_PATH}"
    
    checkExit
    echo "Created .ipa for ${PROJECT_NAME}\n"

    if [ "$GOOGLE_SERVICE_PLIST" != "" ] ; then
        uploadSymbolesToFirebase
    fi
}

uploadSymbolesToFirebase(){
    echo "dSYMs files uploading to Firebase/Crashlytics"
    find "${APP_DIR}" -name "*.dSYM" | xargs -I \{\}  echo \{\} 
    find "${APP_DIR}" -name "*.dSYM" | xargs -I \{\} "${SRC_DIR}/Pods/FirebaseCrashlytics/upload-symbols" -gsp "${SRC_DIR}/${GOOGLE_SERVICE_PLIST}" -p ios \{\}
    checkExit
    echo "dSYMs uploaded to Firebase for ${PROJECT_NAME}\n"
}

tests(){
    local TEST_ADDITION=""
    local RESULT_PATH="${APP_BUILD_PATH}/tests"
    if [ "$TEST_PLAN" == "" ]; then
        echo "We have not test plan"
    else
        echo "We have test plan "$TEST_PLAN""
        TEST_ADDITION="-testPlan "$TEST_PLAN""
    fi
    rm -rf "${RESULT_PATH}"
    echo "Strarting Tests with distination: ${TEST_DESTINATION}\n\n"
    local ACTION="clean build test ${TEST_ADDITION}"
    xcodebuild \
    $ACTION \
    $XCODE_PROJECT \
    -scheme ${SCHEME_NAME} \
    -destination "${TEST_DESTINATION}" \
    -resultBundlePath "${RESULT_PATH}/${PROJECT_NAME}"

    checkExit
    echo "Tests finished for ${PROJECT_NAME}\n\n"
}

createIpaAndSave(){
    local CONFIGURATION_NAME=$1
    local SCHEME_NAME=$2
    local EXPORT_PLIST=$3
    local PROVISIONING_PROFILE=$4

    createIPA "${CONFIGURATION_NAME}" "${SCHEME_NAME}" "${EXPORT_PLIST}" "${PROVISIONING_PROFILE}"

    RESULT_DIR=${APP_BUILD_PATH}/${CONFIGURATION_NAME}
    IPA_FILES=( ${APP_CURRENT_BUILD_PATH}/*.ipa )
    IPA_FILE=${IPA_FILES[0]}
    echo "Found builded ipa file: ${IPA_FILE}"
    IPA_PATH="${RESULT_DIR}/${OUTPUT_NAME}.ipa"
    
    rm -f -d -r "${RESULT_DIR}"
    mkdir -p "${RESULT_DIR}"
    cp "${IPA_FILE}" "${IPA_PATH}"
    
    checkExit

    echo "IPA saved to ${IPA_PATH}"
}

tagCommit(){
	git tag -f -a "${BUILD_VERSION_TAG_GROUP_NAME}/${CURRENT_PROJECT_VERSION}" -m build
	git push -f --tags
    checkExit
    echo "Tag addition complete"
}

createExportPlist(){
    local EXPORT_PLIST=$1

    if $IS_APP_STORE ; then
        SIGNING_METHOD=app-store
    else
        SIGNING_METHOD=ad-hoc
    fi

    cat > $EXPORT_PLIST << EOL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>signingCertificate</key>
    <string>Apple Distribution</string>
    <key>method</key>
    <string>${SIGNING_METHOD}</string>
    <key>teamID</key>
    <string>${TEAM_ID}</string>
    <key>iCloudContainerEnvironment</key>
    <string>Production</string>
    <key>compileBitcode</key>
    <${HAS_BITCODE}/>
</dict>
</plist>
EOL
}

 #reserved
copyToDownload(){
    # create plist for download
    local VERSION_NAME=`plutil -p "${PROJECT_PLIST}" | grep "CFBundleShortVersionString.*$ApplicationVersionNumber"`
    local VERSION=$(echo $VERSION_NAME | grep -o '"[[:digit:].]*"' | sed 's/"//g')

    APP_PLIST_PATH="${RESULT_DIR}/${OUTPUT_NAME}.plist"

    sed "s/CURRENT_PROJECT_VERSION/${VERSION}/" build_result.plist > "${APP_PLIST_PATH}"

    checkExit

    local SERVER_PATH="${HOME}/Projects/vapor"
    local SERVER_DOWNLOAD_PATH="${SERVER_PATH}/Public/download"
    
    cp -f "${APP_CURRENT_BUILD_PATH}/${PROJECT_NAME}.plist" "${SERVER_DOWNLOAD_PATH}/${PROJECT_NAME}.plist"
    cp -f "${APP_CURRENT_BUILD_PATH}/${PROJECT_NAME}.ipa" "${SERVER_DOWNLOAD_PATH}/${PROJECT_NAME}.ipa"
}

podSetup(){
	if [ -f Podfile.lock ]; then
		rm -rf ~/Library/Caches/CocoaPods
		rm -rf Pods
	    pod install --repo-update
	    checkExit
	elif [ -f Podfile ]; then
		pod update
		checkExit
	fi
}

uploadToStoreUser(){
    xcrun altool --upload-app -f "${IPA_PATH}" -t "iOS" -u $USERNAME -p $PASSWORD
    checkExit
    echo "Application uploading finished with success"
}

uploadToStoreKey(){
    KEYS_DIR="${PWD}/private_keys"
    rm -rf "${KEYS_DIR}"
    mkdir -p "${KEYS_DIR}"
    cp -f "${AUTH_KEY}" "${KEYS_DIR}/AuthKey_${API_KEY}.p8"
    xcrun altool --upload-app -f "${IPA_PATH}" -t "iOS" --apiKey "${API_KEY}" --apiIssuer "${API_ISSUER}"
    checkExit
    echo "Application uploading finished with success"
}

if $IS_PODS_INIT ; then
    echo "Starting pod init:"
    podSetup
    checkExit
fi

# General part of building:

echo "Starting build script with parameters:"
echo "PROJECT_NAME         = ${PROJECT_NAME}"
echo "CONFIGURATION_NAME = ${CONFIGURATION_NAME}"
echo "SCHEME_NAME          = ${SCHEME_NAME}"
echo "OUTPUT_NAME          = ${OUTPUT_NAME}"
cat "$APP_CONFIG_PATH"

if $HAS_TESTING ; then
    tests
fi

if $HAS_IPA_BUILD ; then
    createIpaAndSave "${CONFIGURATION_NAME}" "${SCHEME_NAME}" "${EXPORT_PLIST}" "${PROVISIONING_PROFILE}"
fi

if [ "$USERNAME" != "" ] ; then
    echo ""
    echo "Starting upload to store:"
    echo "USERNAME          = ${USERNAME}"

    uploadToStoreUser
elif [ "$API_KEY" != "" ] ; then
    echo ""
    echo "Starting upload to store:"
    echo "API KEY          = ${API_KEY}"

    uploadToStoreKey
fi

if $IS_TAG_VERSION ; then
    echo "Starting addition tag:"
    tagCommit
fi

clearCurrentBuild
