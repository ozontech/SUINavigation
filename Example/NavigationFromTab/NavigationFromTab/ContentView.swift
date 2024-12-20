//
//  ContentView.swift
//  NavigationFromTab
//
//  Created by Sergey Balalaev on 20.12.2024.
//

import SwiftUI
import SUINavigation

enum TabNavigation {
    case first
    case second
}

struct ContentView: View {
    var body: some View {
        NavigationViewStorage {
            TabView {
                FirstView()
                    .tabItem {
                        Text("first")
                    }
                SecondView()
                    .tabItem {
                        Text("second")
                    }
            }
            .navigationStorageDestination { (item: TabNavigation) in
                switch item {
                case .first:
                    FirstView()
                case .second:
                    SecondView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
