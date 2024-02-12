//
//  NavigationExampleApp.swift
//  NavigationExample
//
//  Created by Sergey Balalaev on 28.09.2023.
//

import SwiftUI

@main
struct NavigationExampleApp: App {
    var body: some Scene {
        WindowGroup {
            StartView()
        }
    }
}

struct StartView: View {

    @State
    private var viewMode: ViewMode = .defaultValue

    @State
    private var modelMode: ModelMode = .defaultValue

    var body: some View {
        ZStack {
            switch viewMode {
            case .navigation:
                MainView()
            case .tabBar:
                MainTabView()
            }
        }
        .environment(\.viewMode, $viewMode)
        .environment(\.modelMode, $modelMode)
    }

}
