//
//  TodoListInteractor.swift
//  Todo_EM
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 25.01.2025.
//

import Foundation
import CoreData


class TodoListInteractor: TodoListInteractorProtocol {
    
    func updateTask(task: TaskModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        
        do {
            let tasks = try context.fetch(fetchRequest)
            
            if let taskToUpdate = tasks.first {
                taskToUpdate.label = task.label
                taskToUpdate.caption = task.caption
                taskToUpdate.isDone = task.isDone
                
                try context.save()
                print("Task is edited. New task: \(taskToUpdate.label), \(taskToUpdate.caption), \(taskToUpdate.isDone)")
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "Todo_EM", code: 404, userInfo: [NSLocalizedDescriptionKey: "Task not found"])))
            }
        } catch {
            print("Ошибка редактирования задачи: \(error)")
            completion(.failure(error))
        }
    }
    
    
    private var context = PersistenceController.shared.context
    
    
    func saveToCoreData(_ tasks: [TaskModel]) {
        
        context.perform {
            for task in tasks {
                self.saveTask(task: task)
            }
        }
    }
    
    func saveTask(task: TaskModel) {
        let taskEntity = Task(context: context)
        taskEntity.label = task.label
        taskEntity.caption = task.caption
        taskEntity.createDate = task.createDate
        taskEntity.isDone = task.isDone
        taskEntity.id = task.id
        
        do {
            try context.save()
            print("Задача успешно сохранена в Core Data")
        } catch {
            print("Ошибка при сохранении задачи в Core Data: \(error.localizedDescription)")
        }
        
    }
    
    func deleteTask(by id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
          let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
          fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
          
          do {
              let tasks = try context.fetch(fetchRequest)
              
              if let taskToDelete = tasks.first {
                  context.delete(taskToDelete)
                  
                  try context.save()
                  print("Task is deleted")
                  completion(.success(()))
              } else {
                  completion(.failure(NSError(domain: "Todo_EM", code: 404, userInfo: [NSLocalizedDescriptionKey: "Task not found"])))
              }
          } catch {
              print("Ошибка удаления задачи: \(error)")
              completion(.failure(error))
          }
      }
    
    func fetchTask(completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        if !isCoreDataEmpty(context: context) {
            fetchTaskFromCoreData(completion: completion)
        } else {
            fetchTasksFromAPI(completion: completion)
        }
    }
    
    func fetchTaskFromCoreData(completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let tasks = try context.fetch(fetchRequest)
            let taskModels = tasks.map { TaskModel(id: $0.id ?? UUID(), label: $0.label ?? "Task Label", caption: $0.caption ?? "caption for task...", isDone: $0.isDone, createDate: $0.createDate ?? Date()) }
            completion(.success(taskModels))
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetchTasksFromAPI(completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "No Data", code: -2, userInfo: nil)))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let tasksResponse = try decoder.decode(TasksAPIResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.saveToCoreData(tasksResponse.todos)
                        completion(.success(tasksResponse.todos))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }

    func isCoreDataEmpty(context: NSManagedObjectContext) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        fetchRequest.fetchLimit = 1
        
        do {
            let count = try context.count(for: fetchRequest)
            return count == 0
        } catch {
            print("Ошибка проверки на пустоту: \(error)")
            return true
        }
    }
    
}
