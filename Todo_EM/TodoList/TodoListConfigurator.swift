//
//  TodoListConfigurator.swift
//  Todo_EM
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 25.01.2025.
//

import Foundation

protocol TodoListConfiguratorProtocol {
    
}

class TodoListConfigurator {
    static func configure(view: TodoListView) {
        let presenter = TodoListPresenter()
        let interactor = TodoListInteractor()
        let router = TodoListRouter()

        // Связываем презентер с интерактором
        interactor.presenter = presenter

        // Связываем презентер с представлением
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        // Инициализируем представление с презентером
        view.presenter = presenter
    }
}

