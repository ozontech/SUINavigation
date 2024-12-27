//
//  ListDetailsApp.swift
//  ListDetails
//
//  Created by Sergey Balalaev on 04.12.2024.
//

import SwiftUI
import SUINavigation

@main
struct ListDetailsApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStorageView {
                ListView()
            }
        }
    }
}
