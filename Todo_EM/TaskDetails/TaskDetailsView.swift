//
//  TaskDetailsView.swift
//  Todo_EM
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 25.01.2025.
//

import Foundation
import SwiftUI

struct TaskDetailsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewState: TodoListViewState
    @State private var label: String = ""
    @State private var caption: String = ""
    let date: Date
    let task: TaskModel?

    init(task: TaskModel?, viewState: TodoListViewState) {
        self.date = task?.createDate ?? Date()
        self.task = task
        self.viewState = viewState
    }
    
    var header: some View {
        VStack(alignment: .leading) {
            TextField("Название задачи", text: $label)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: 30))
                .padding()
            
            HStack {
                Text(Date().formattedDate())
                    .foregroundStyle(.gray)
                    .font(.system(size: 16))
                Spacer()
            }
            .padding(.leading)
            
            TextEditor(text: $caption)
                .padding(.horizontal, 10)

            Spacer()
        }
        .onDisappear {
            if var task = task {
                task.label = label
                task.caption = caption
                print("UPDATE TASK AFTER CLOSE DETAILS")
                viewState.updateTask(task: task)
            } else {
                let newTask = TaskModel(label: label, caption: caption, isDone: false)
                viewState.addTask(task: newTask)
            }
        }
    }
    
    var body: some View {
        header
            .onAppear {
                if let task = task {
                    label = task.label
                    caption = task.caption
                }
            }
    }

}

#Preview {
    let task = TaskModel(label: "HEEEEEY", caption: "fwr ht  r hh h eh h  h tjr  hr hje trbfs sn tejrhwnw", isDone: false)
    let viewState = TodoListViewState()
    TaskDetailsView(task: task, viewState: viewState)
}
