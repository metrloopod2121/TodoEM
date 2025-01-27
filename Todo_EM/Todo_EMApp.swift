//
//  Todo_EMApp.swift
//  Todo_EM
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 24.01.2025.
//

import SwiftUI

@main
struct Todo_EMApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TodoListConfigurator().configure()
        }
    }
}
