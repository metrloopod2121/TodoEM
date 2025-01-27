//
//  TodoListRouter.swift
//  Todo_EM
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 25.01.2025.
//

import Foundation
import SwiftUI

protocol TodoListRouterProtocol: AnyObject {
    func navigateToTaskDetails(task: TaskModel?, viewState: TodoListViewState)
}

class TodoListRouter: TodoListRouterProtocol {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToTaskDetails(task: TaskModel?, viewState: TodoListViewState) {
        let taskDetailsView = TaskDetailsView(task: task, viewState: viewState)
        let hostingController = UIHostingController(rootView: taskDetailsView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
}
