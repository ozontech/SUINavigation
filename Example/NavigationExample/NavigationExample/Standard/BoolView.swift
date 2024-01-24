//
//  BoolView.swift
//  NavigationExample
//
//  Created by Sergey Balalaev on 03.10.2023.
//

import SwiftUI
import SUINavigation

struct FirstModalData: Identifiable {
    var string: String

    public var id: String {
        string
    }
}

struct BoolView: View {

    @State
    private var stringForFirst: String? = nil

    @State
    private var firstModalData: FirstModalData? = nil

    @State
    private var isMainShowing: Bool = false

    @State
    var isTabShowing: Bool = false

    @OptionalEnvironmentObject
    private var navigationStorage: NavigationStorage?

    @Environment(\.isChange)
    private var isChange

    @Environment(\.presentationMode)
    private var presentationMode

    @State
    private var popToViewName: String = ""

    @State
    private var skipViewName: String = ""

    @State
    private var actionUrl: String = ""

    var body: some View {
        VStack {
            Text("This is Bool")
            HStack {
                Button("popTo:") {
                    if popToViewName == "" {
                        navigationStorage?.popToRoot()
                    } else {
                        navigationStorage?.popTo(navigationId(for: popToViewName))
                    }
                }
                TextField("PopToViewName", text: $popToViewName)
            }
            HStack {
                Button("skip:") {
                    navigationStorage?.skip(navigationId(for: skipViewName))
                }
                TextField("SkipViewName", text: $skipViewName)
                Button("clear skip") {
                    skipViewName = ""
                }
            }
            HStack {
                VStack{
                    Button("append") {
                        navigationStorage?.append(from: actionUrl)
                    }
                    Button("replace") {
                        navigationStorage?.replace(with: actionUrl)
                    }
                }
                TextField("URL", text: $actionUrl)
                Button("clear url") {
                    actionUrl = ""
                }
            }

            Button("to Root") {
                navigationStorage?.popToRoot()
            }
            HStack {
                Button("to First") {
                    stringForFirst = "Bool"
                }
                Button("to Modal First") {
                    firstModalData = FirstModalData(string: "Modal")
                }
                Button("to Main") {
                    isMainShowing = true
                }
                Button("to Tab") {
                    isTabShowing = true
                }
            }
            Button("to change") {
                isChange.wrappedValue.toggle()
            }
            Button("dismiss") {
                presentationMode.wrappedValue.dismiss()
            }

            if let navigationStorage = navigationStorage {
                Text("Path: \(navigationStorage.currentUrl)")
            }
            if isChange.wrappedValue {
                Text("This screen is changed")
            } else {
                Text("Waitting changes")
            }
        }
        .padding()
        .navigation(item: $stringForFirst) { stringValue in
            FirstView(string: stringValue)
        }
        .navigationAction(isActive: $isMainShowing) {
            MainView()
        }
        .navigateUrlParams("FirstView"){ path in
            if let stringForFirst = path.popStringParam("firstString") {
                self.stringForFirst = stringForFirst
            }
        }
        .navigation(isActive: $isTabShowing) {
            MainTabView()
        }
        .fullScreenCover(item: $firstModalData) { value in
            NavigationViewStorage{
                FirstView(string: value.string)
            }
        }
        .navigateUrlParams("ModalFirstView") { params in
            if let modalFirst = params.popStringParam("modalFirst") {
                firstModalData = FirstModalData(string: modalFirst)
            }
        }
    }

    func navigationId(for name: String) -> NavigationID {
        switch name {
        case "":
            return String.root
        case "First":
            return FirstView.navigationID
        case "Second":
            return SecondView.navigationID
        case "Bool":
            return BoolView.navigationID
        case "Main":
            return MainView.navigationID
        default:
            assert(false, "unknown")
        }
    }
}

#Preview {
    BoolView()
}
