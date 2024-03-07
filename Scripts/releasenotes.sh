#! /bin/bash

CHANGELOG=$(cat CHANGELOG.md)
VERSION_REGEX='##[[:space:]]*\[([.0-9]*)\]'
CURRENT_VERSION=""
if [[ $CHANGELOG =~ $VERSION_REGEX ]]; then
    CURRENT_VERSION=${BASH_REMATCH[1]}
fi

echo "Release version $CURRENT_VERSION detected"

#perl scripts/releasenotes.pl
#VERSION_MESSAGE=$(perl scripts/releasenotes.pl)

VERSION_MESSAGE=

VERSION_MESSAGE=$(
perl -l - $cnt <<'EOF'

open my $fh, '<', 'CHANGELOG.md' or die "Can't open file $!";
my $CHANGELOG = do { local $/; <$fh> };

if ($CHANGELOG =~ m/## *\[([.0-9]*)\]/) {
    $CURRENT_VERSION="$1"
}

if ($CHANGELOG =~ m/## *\[$CURRENT_VERSION\].*\s+((.|\s)*?)\s+## *\[[.0-9]*\]/) { 
    print "$1"
}

EOF
)

#echo "$VERSION_MESSAGE"

exit 1


# GitHub CLI api
# https://cli.github.com/manual/gh_api
# I change '$CURRENT_VERSION' to "$CURRENT_VERSION"

gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  /repos/ozontech/SUINavigation/releases \
  -f tag_name="$CURRENT_VERSION" \
 -f target_commitish='main' \
 -f name="$CURRENT_VERSION" \
 -f body="$VERSION_MESSAGE" \
 -F draft=false \
 -F prerelease=false \
 -F generate_release_notes=false 