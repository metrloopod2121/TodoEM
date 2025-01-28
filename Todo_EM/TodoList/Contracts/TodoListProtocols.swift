//
//  TodoListProtocols.swift
//  Todo_EM
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 26.01.2025.
//

import Foundation
import SwiftUI


protocol TodoListViewStateProtocol: AnyObject {
    func setUp(with presenter: TodoListPresenterProtocol)
    func fetchTasks()
    func addTask(task: TaskModel)
    func updateTasks(_ tasks: [TaskModel])
    func updateError(_ error: String)
    func deleteTask(by id: UUID)
    func updateTask(task: TaskModel)
}


protocol TodoListPresenterProtocol: AnyObject {
    func loadTasks()
    func updateTask(task: TaskModel)
    func addTask(task: TaskModel)
    func deleteTask(by id: UUID)
}

protocol TodoListInteractorProtocol: AnyObject {
    func updateTask(task: TaskModel, completion: @escaping (Result<Void, Error>) -> Void)
    func saveToCoreData(_ tasks: [TaskModel])
    func saveTask(task: TaskModel)
    func deleteTask(by id: UUID, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchTask(completion: @escaping (Result<[TaskModel], Error>) -> Void)
    func fetchTaskFromCoreData(completion: @escaping (Result<[TaskModel], Error>) -> Void)
    func fetchTasksFromAPI(completion: @escaping (Result<[TaskModel], Error>) -> Void)
}

protocol TodoListConfiguratorProtocol {
    func configure() -> TodoListView 
}
