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
    
    func fetchTasks() {
        interactor.fetchTasks { [weak self] result in
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
}
