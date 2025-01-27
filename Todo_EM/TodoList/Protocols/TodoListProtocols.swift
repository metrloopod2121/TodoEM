//
//  TodoListProtocols.swift
//  Todo_EM
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 26.01.2025.
//

import Foundation
import SwiftUI

protocol TodoListViewProtocol: AnyObject {
    func displayTasks(_ tasks: [TaskModel])
    func displayError(_ error: String)
}

protocol TodoListViewStateProtocol: AnyObject {
    var tasks: [TaskModel] { get set }
    var errorMessage: String? { get set }
    func setUp(with presenter: TodoListPresenterProtocol)
    func fetchTasks()
    func updateTasks(_ tasks: [TaskModel])
    func updateError(_ error: String) 
}

protocol TodoListPresenterProtocol: AnyObject {
    func fetchTasks()
}

protocol TodoListInteractorProtocol: AnyObject {
    func fetchTasks(completion: @escaping (Result<[TaskModel], Error>) -> Void)
}

protocol TodoListConfiguratorProtocol {
    func configure() -> TodoListView 
}
