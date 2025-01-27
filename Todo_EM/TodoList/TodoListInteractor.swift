//
//  TodoListInteractor.swift
//  Todo_EM
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 25.01.2025.
//

import Foundation
import CoreData


class TodoListInteractor: TodoListInteractorProtocol {
    
    func fetchTasks(completion: @escaping (Result<[TaskModel], Error>) -> Void) {
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
}
