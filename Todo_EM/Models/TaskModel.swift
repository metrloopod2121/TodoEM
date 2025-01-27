//
//  TaskAPIResponse.swift
//  Todo_EM
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 25.01.2025.
//

import Foundation

struct TaskModel: Decodable, Identifiable {
    var id: UUID = UUID()
    var label: String
    var caption: String
    var isDone: Bool
    var createDate: Date = Date()

    enum CodingKeys: String, CodingKey {
        case label = "todo"
        case isDone = "completed"
        case caption = "id"
    }
    
    init(id: UUID = UUID(), label: String, caption: String = "Caption for task...", isDone: Bool, createDate: Date = Date()) {
        self.id = id
        self.label = label
        self.caption = caption
        self.isDone = isDone
        self.createDate = createDate
    }
}

struct TasksAPIResponse: Decodable {
    let todos: [TaskModel]
}
