//
//  MainTabView.swift
//  NavigationExample
//
//  Created by Sergey Balalaev on 16.11.2023.
//

import SwiftUI
import SUINavigation

enum MainTab: String, Hashable, NavigationParameterValue {
    case main = "Main Tab"
    case first = "First Tab"
    case second = "Second Tab"
    case bool = "Bool Tab"

    init?(_ description: String) {
        self.init(rawValue: description)
    }

    var title: String {
        rawValue
    }
}

struct MainTabView: View {

    @State
    private var isChange: Bool = false

    @State
    private var isRoot: Bool = true

    @State
    private var selectedTab: MainTab = .main

    var body: some View {
        NavigationViewStorage{
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    RootView()
                        .navigationStorage(isRoot: $isRoot)
                        .tabItem{
                            Text(MainTab.main.title)
                        }
                        .tag(MainTab.main)
                    FirstView(string: "TabBar")
                        .tabItem{
                            Text(MainTab.first.title)
                        }
                        .tag(MainTab.first)
                    SecondView(number: 120)
                        .tabItem{
                            Text(MainTab.second.title)
                        }
                        .tag(MainTab.second)
                    BoolView()
                        .tabItem{
                            Text(MainTab.bool.title)
                        }
                        .tag(MainTab.bool)
                }
                .navigateUrlParams("TabView") { params in
                    if let tab: MainTab = params.popParam("tab") {
                        selectedTab = tab
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(isRoot ? isChange ? "This screen is changed" : "Waitting changes" : "Back")
        }
        .environment(\.isChange, $isChange)
    }
}
