//
//  TodoListConfigurator.swift
//  Todo_EM
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 25.01.2025.
//

import Foundation
import SwiftUI

class TodoListConfigurator: TodoListConfiguratorProtocol {
    func configure() -> TodoListView {
        let interactor = TodoListInteractor()
        let viewState = TodoListViewState()
        let presenter = TodoListPresenter(viewState: viewState, interactor: interactor)
        viewState.setUp(with: presenter)
        let view = TodoListView(viewState: viewState) // Передаем viewState через инициализатор
        return view
    }
}
