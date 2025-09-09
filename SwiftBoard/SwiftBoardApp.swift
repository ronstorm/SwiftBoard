//
//  SwiftBoardApp.swift
//  SwiftBoard
//
//  Created by Shakibul Islam on 9/9/25.
//

import SwiftUI

@main
struct SwiftBoardApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
