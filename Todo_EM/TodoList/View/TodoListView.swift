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
    
    //    @State private var isLoading = false
    //    @State private var errorMessage: String?
    @State private var selectedTask: TaskModel?
    
    func taskView(for task: TaskModel) -> some View {
        HStack(alignment: .top) {
            Image(task.isDone ? "check_mark_fill" : "check_mark")
                .onTapGesture {
                    viewState.updateTask(task:
                        TaskModel(
                            id: task.id,
                            label: task.label,
                            caption: task.caption,
                            isDone: !task.isDone,
                            createDate: task.createDate
                        )
                    )
                }
            
            VStack(alignment: .leading) {
                Text(task.label)
                    .font(.headline)
                    .padding(.bottom, 2)
                    .foregroundStyle(task.isDone ? .gray : .white)
                    .strikethrough(task.isDone)
                Text(task.caption)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .foregroundStyle(task.isDone ? .gray : .white)
                    .padding(.bottom, 5)
                Text(task.createDate.formattedDate())
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
        }
    }
    
    var addBar: some View {
        ZStack(alignment: .trailing) {
            HStack {
                Spacer()
                Text("\(viewState.tasks.count) задач")
                Spacer()
            }
            
            NavigationLink(destination: TaskDetailsView(task: nil, viewState: viewState)) {
                Image(systemName: "square.and.pencil")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.yellow)
                    .padding(.trailing, 20)
            }
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: 60)
        .background(Color(red: 39/255, green: 39/255, blue: 41/255))
    }
    
    
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                if viewState.isLoading {
                    ProgressView("Загрузка задач...")
                } else if let errorMessage = viewState.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    List(viewState.tasks) { task in
                        
                        NavigationLink(destination: TaskDetailsView(task: task, viewState: viewState)) {
                            
                            taskView(for: task)
                                .listRowInsets(EdgeInsets())
                                .padding(.vertical, 10)
                                .listRowBackground(Color.clear)
                                .onTapGesture {
                                    selectedTask = task
                                }
                            // deprecated /////////////////////////
                                .swipeActions(edge: .trailing) {
                                    Button("RM") {
                                        viewState.deleteTask(by: task.id)
                                    }
                                    .tint(.red)
                                }
                            /////////////////////////////////////////
                        }
                    }

                    addBar
                }
            }
            .navigationTitle("Задачи")
            .onAppear {
                viewState.fetchTasks()
            }
        }
    }
}

