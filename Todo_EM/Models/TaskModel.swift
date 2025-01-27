//
//  TaskAPIResponse.swift
//  Todo_EM
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 25.01.2025.
//

import Foundation

struct TaskModel: Decodable, Identifiable {
    let id: UUID = UUID()
    let label: String
    let caption: String = "Заметки"
    let isDone: Bool
    let createDate: Date = Date()

    enum CodingKeys: String, CodingKey {
        case label = "todo"
        case isDone = "completed"
    }
}

struct TasksAPIResponse: Decodable {
    let todos: [TaskModel]
}
