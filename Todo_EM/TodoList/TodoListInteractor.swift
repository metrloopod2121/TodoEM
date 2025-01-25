//
//  TodoListInteractor.swift
//  Todo_EM
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 25.01.2025.
//

import Foundation
import CoreData

protocol TodoListInteractorProtocol {
    func fetchTask()
    func viewTaskDetails(selectedTaskID: UUID)
    func addTask()
    func searchTask(by keyword: String)
}

class TodoListInteractor: TodoListInteractorProtocol {
    
    private let context = PersistenceController.shared.context
    var presenter: TodoListPresenterProtocol?
    
    func fetchTask() {
        DispatchQueue.global(qos: .background).async {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            
            do {
                let tasks = try self.context.fetch(fetchRequest)
                DispatchQueue.main.async {
                    print(tasks) // передаём данные в presenter
                }
            } catch {
                DispatchQueue.main.async {
                    print("Не удалось загрузить задачи: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func viewTaskDetails(selectedTaskID: UUID) {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", selectedTaskID as CVarArg)
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let tasks = try PersistenceController.shared.context.fetch(fetchRequest)
                
                if let task = tasks.first {
                    DispatchQueue.main.async {
                        self.presenter?.didFetchTaskDetails(task)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.presenter?.didFailToFetchTaskDetails(error: NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Task not found"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchTaskDetails(error: error)
                }
            }
        }
    }
    
    func addTask(label: String, caption: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let newTask = Task(context: self.context)
            newTask.id = UUID()
            newTask.label = label
            newTask.caption = caption
            newTask.createDate = Date()
            newTask.isDone = false
        }
        do {
            try context.save()
            DispatchQueue.main.async {
                self.presenter?.didAddTask()
            }
        } catch {
            DispatchQueue.main.async {
                self.presenter?.didFailToAddTask(error: error)
            }
        }
    }
    
    func searchTask(by keyword: String) {
        let context = PersistenceController.shared.context
        
        DispatchQueue.global(qos: .userInitiated).async {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            let predicate = NSPredicate(format: "title CONTAINS[c] %@ OR details CONTAINS[c] %@", keyword, keyword)
            fetchRequest.predicate = predicate
            
            do {
                let tasks = try context.fetch(fetchRequest)
                
                DispatchQueue.main.async {
                    self.presenter?.didFetchTasks(tasks)
                }
            } catch {
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchTasks(error: error)  
                }
            }
        }
    }
    
    
}
