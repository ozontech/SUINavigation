//
//  ContentView.swift
//  NavigationFromTab
//
//  Created by Sergey Balalaev on 20.12.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            TabView {
                FirstView()
                    .tabItem {
                        Text("first")
                    }
                LastView()
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
