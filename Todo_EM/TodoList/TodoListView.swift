//
//  TodoListView.swift
//  Todo_EM
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 25.01.2025.
//

import Foundation
import SwiftUI

struct TodoListView: View {
    @ObservedObject var viewState: TodoListViewState
    
    var body: some View {
        NavigationView {
            List(viewState.tasks) { task in
                Text(task.label)
            }
            .navigationTitle("Todo List")
            .onAppear {
                viewState.fetchTasks()
            }
        }
    }
}

 
