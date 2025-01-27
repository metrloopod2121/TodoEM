//
//  TodoListViewState.swift
//  Todo_EM
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 25.01.2025.
//

import Foundation

final class TodoListViewState: ObservableObject, TodoListViewStateProtocol {
    @Published var tasks: [TaskModel] = []
    @Published var errorMessage: String?
    
    private var presenter: TodoListPresenterProtocol?
    
    func setUp(with presenter: TodoListPresenterProtocol) {
        self.presenter = presenter
    }
    
    func fetchTasks() {
        presenter?.fetchTasks()
    }
    
    func updateTasks(_ tasks: [TaskModel]) {
        self.tasks = tasks
    }
    
    func updateError(_ error: String) {
        self.errorMessage = error
    }
}
