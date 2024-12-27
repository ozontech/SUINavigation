//
//  ContentView.swift
//  MVVM+Router
//
//  Created by Sergey Balalaev on 07.02.2024.
//

import SwiftUI
import SUINavigation

struct RootView: View {
    // True value trigger navigation transition to FirstView
    @State
    private var isShowingFirst: Bool = false

    var body: some View {
        NavigationStorageView{
            VStack {
                Text("Root")
                Button("to First"){
                    isShowingFirst = true
                }
            }.navigation(isActive: $isShowingFirst, id: "first"){
                FirstView()
            }
        }
    }
}

