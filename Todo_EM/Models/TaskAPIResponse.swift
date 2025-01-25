//
//  TaskAPIResponse.swift
//  Todo_EM
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 25.01.2025.
//

import Foundation

struct TaskAPIResponse: Decodable {
    let id: Int
    let label: String
    let caption: String = "Заметки"
    let isDone: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case label = "todo"
        case isDone = "completed"
    }
}

struct TasksAPIResponseWrapper: Decodable {
    let todos: [TaskAPIResponse]
}
