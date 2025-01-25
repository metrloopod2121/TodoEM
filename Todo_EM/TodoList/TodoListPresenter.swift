//
//  TodoListPresenter.swift
//  Todo_EM
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 25.01.2025.
//

import Foundation


protocol TodoListPresenterProtocol: AnyObject {
    func didFetchTaskDetails(_ task: Task)
    func didFetchTasks(_ tasks: [Task])
    func didFailToFetchTasks(error: Error)
    func didFailToFetchTaskDetails(error: Error)
    func didAddTask(_ task: Task)
    func didFailToAddTask(error: Error)
    func didUpdateTask(_ task: Task)
    func didDeleteTask(_ task: Task)
}

class TodoListPresenter: TodoListPresenterProtocol {
    
    weak var view: TodoListViewProtocol?
    var interactor: TodoListInteractorProtocol?
    var router: TodoListRouterProtocol?
    
    func didFetchTaskDetails(_ task: Task) {
        view?.updateTaskDetails(task)
    }
    
    func didFailToFetchTaskDetails(error: Error) {
        view?.showError(error)
    }
    
    func didFetchTasks(_ tasks: [Task]) {
        view?.updateTaskList(tasks)
    }
    
    func didFailToFetchTasks(error: Error) {
        view?.showError(error)
    }
    
    func didAddTask(_ task: Task) {
        view?.updateTaskList([task])
    }
    
    func didFailToAddTask(error: Error) {
        view?.showError(error)
    }
    
    func didUpdateTask(_ task: Task) {
        view?.updateTaskList([task])
    }
    
    func didDeleteTask(_ task: Task) {
        view?.updateTaskList([])
    }
    
    
    
}
