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
        case id = "userId"
        case label = "todo"
        case isDone = "completed"
        case caption = "id"
    }
    
    init(id: UUID = UUID(), label: String, caption: String = "Caption for task...", isDone: Bool = false, createDate: Date = Date()) {
        self.id = id
        self.label = label
        self.caption = caption
        self.isDone = isDone
        self.createDate = createDate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let userId = try container.decode(Int.self, forKey: .id)
        self.id = UUID(uuidString: "\(userId)") ?? UUID()
        self.label = try container.decode(String.self, forKey: .label)
        
        self.caption = "Caption"
        self.isDone = try container.decode(Bool.self, forKey: .isDone)
        self.createDate = Date()
    }
    
}

struct TasksAPIResponse: Decodable {
    let todos: [TaskModel]
//    let total: Int
//    let skip: Int
//    let limit: Int
}
