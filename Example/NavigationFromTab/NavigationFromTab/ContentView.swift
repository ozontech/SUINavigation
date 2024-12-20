//
//  ContentView.swift
//  NavigationFromTab
//
//  Created by Sergey Balalaev on 20.12.2024.
//

import SwiftUI
import SUINavigation

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
        }
    }
}

#Preview {
    ContentView()
}
