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
    @State private var selectedTask: TaskModel?
    @State private var searchText = ""
    @State private var isShareSheetPresented = false
    @State private var shareItems: [Any] = []
    
    var filteredTasks: [TaskModel] {
        if searchText.isEmpty {
            return viewState.tasks
        } else {
            return viewState.tasks.filter { task in
                task.label.lowercased().contains(searchText.lowercased()) || task.caption.lowercased().contains(searchText.lowercased())
            }
        }
    }

    func highlightedText(_ text: String, searchText: String) -> Text {
        let lowercasedSearch = searchText.lowercased()
        guard !lowercasedSearch.isEmpty else { return Text(text) }
        
        let components = text.lowercased().components(separatedBy: lowercasedSearch)
        var result = Text(components.first ?? "")
        
        for i in 1..<components.count {
            result = result + Text(searchText).foregroundColor(.yellow) + Text(components[i])
        }
        
        return result
    }

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
                highlightedText(task.label, searchText: searchText)
                    .font(.headline)
                    .padding(.bottom, 2)
                    .foregroundStyle(task.isDone ? .gray : .white)
                    .strikethrough(task.isDone)
                
                highlightedText(task.caption, searchText: searchText)
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
        .contextMenu {
            
            NavigationLink(destination: TaskDetailsView(task: task, viewState: viewState)) {
                Label("Редактировать", systemImage: "square.and.pencil")
            }
                
            Button(action: {
                shareItems = [task.label, task.caption]
                isShareSheetPresented = true
            }) {
                Label("Поделиться", systemImage: "square.and.arrow.up")
            }
            
            Button(role: .destructive, action: {
                viewState.deleteTask(by: task.id)
            }) {
                Label("Удалить", systemImage: "trash")
            }
        }
        .sheet(isPresented: $isShareSheetPresented) {
             ShareSheet(items: shareItems)
         }
    }
    
    var addBarView: some View {
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
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 60)
        .background(Color(red: 39/255, green: 39/255, blue: 41/255))
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                if viewState.isLoading {
                    Spacer()
                    ProgressView("Загрузка задач...")
                    Spacer()
                } else if let errorMessage = viewState.errorMessage {
                    Spacer()
                    Text(errorMessage)
                        .foregroundColor(.red)
                    Spacer()
                } else {
                    List(filteredTasks) { task in
                        NavigationLink(destination: TaskDetailsView(task: task, viewState: viewState)) {
                            taskView(for: task)
                                .padding(.vertical, 10)
                                .onTapGesture {
                                    selectedTask = task
                                }
                        }
                        .listRowInsets(EdgeInsets())
                        .padding(.vertical, 10)
                        .listRowBackground(Color.clear)
                        .buttonStyle(PlainButtonStyle())
                    }
                    .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                }
                
                addBarView
            }
            .navigationTitle("Задачи")
            .onAppear {
                viewState.fetchTasks()
            }
        }
    }
}
