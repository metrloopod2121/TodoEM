//
//  TaskModel.swift
//  Todo_EM
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 25.01.2025.
//

import Foundation

struct TaskModel {
    let id: UUID
    let label: String
    let caption: String
    let createDate: Date
    let isDone: Bool
}
