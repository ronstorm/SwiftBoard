//
//  SwiftBoardApp.swift
//  SwiftBoard
//
//  Created by Amit Sen on 9/9/25.
//  © 2025 Coding With Amit. All rights reserved.

import SwiftUI

@main
struct SwiftBoardApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            AppView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
