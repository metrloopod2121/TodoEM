//
//  TodoListPresenter.swift
//  Todo_EM
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 25.01.2025.
//

import Foundation

class TodoListPresenter: TodoListPresenterProtocol {

    weak var viewState: TodoListViewStateProtocol?
    var interactor: TodoListInteractorProtocol
    
    init(viewState: TodoListViewStateProtocol, interactor: TodoListInteractorProtocol) {
        self.viewState = viewState
        self.interactor = interactor
    }
    
    func loadTasks() {
        interactor.fetchTask { [weak self] result in
            switch result {
            case .success(let tasks):
                DispatchQueue.main.async {
                    self?.viewState?.updateTasks(tasks)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.viewState?.updateError(error.localizedDescription)
                }
            }
        }
    }
    
    func updateTask(task: TaskModel) {
        interactor.updateTask(task: task) { result in
            switch result {
            case .success:
                self.loadTasks()
            case .failure(let error):
                print("Error edited (Interactor side) \(error)")
            }
        }
    }
    
    func addTask(task: TaskModel) {
        interactor.saveTask(task: task)
        self.loadTasks()
    }
    
    func deleteTask(by id: UUID) {
        interactor.deleteTask(by: id) { result in
            switch result {
            case .success:
                self.loadTasks()
            case .failure(let error):
                print("Error (Interactor side) \(error)")
            }
            
        }
    }
    
    func saveTasks() {
        print()
    }
}
