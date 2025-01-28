//
//  InteractorTests.swift
//  Todo_EMTests
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 28.01.2025.
//

import Foundation
import XCTest
import CoreData
@testable import Todo_EM

final class TodoListInteractorTests: XCTestCase {
    
    var context: NSManagedObjectContext!
    var interactor: TodoListInteractor!
    
    override func setUp() {
        super.setUp()
        
        let persistentContainer = NSPersistentContainer(name: "Task")
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        persistentContainer.persistentStoreDescriptions = [description]
        
        let expectation = self.expectation(description: "Load Persistent Stores")
        persistentContainer.loadPersistentStores { _, error in
            XCTAssertNil(error, "Ошибка загрузки Persistent Store: \(error?.localizedDescription ?? "")")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2)
        
        context = persistentContainer.viewContext
        interactor = TodoListInteractor()
        interactor.context = context
    }
    
    func testFetchTaskFromCoreData_success() {
        
        let storedTask = Task(context: context)
        storedTask.id = UUID()
        storedTask.label = "Test Task"
        storedTask.caption = "Test Caption"
        storedTask.isDone = false
        storedTask.createDate = Date()
        
        do {
            try context.save()
        } catch {
            XCTFail("Ошибка context.save(): \(error.localizedDescription)")
        }
        
        interactor.fetchTaskFromCoreData() { result in
            switch result {
            case .success(let tasks):
                XCTAssertEqual(tasks.count, 1)
                XCTAssertEqual(tasks.first?.label, "Test Task")
            case .failure(let error):
                XCTFail("Ошибка: \(error.localizedDescription)")
            }
        }
    }
    
    func testFetchTask_failure() {
        interactor.fetchTaskFromCoreData { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Expected error message")
            case .success:
                XCTFail("Expected failure but got success")
            }
        }
    }
    
    func testUpdateTask_success() {
        let task = Task(context: context)
        task.label = "Task"
        task.caption = "Caption"
        task.isDone = false
        
        do {
            try context.save()
        } catch {
            XCTFail("Error saving context: \(error)")
        }
        
        let newLabel = "NewLabel"
        let newCaption = "NewCaption"
        
        let updatedTask = TaskModel(label: newLabel, caption: newCaption)
        
        interactor.updateTask(task: updatedTask) { result in
            switch result {
            case .success:
                let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", task.id! as CVarArg)
                do {
                    let fetchTask = try self.context.fetch(fetchRequest)
                    if let editedTask = fetchTask.first {
                        XCTAssertEqual(editedTask.label, newLabel)
                        XCTAssertEqual(editedTask.caption, newCaption)
                        XCTAssertFalse(editedTask.isDone)
                    }
                } catch {
                    XCTFail("Error fetching task: \(error)")
                }
            case .failure(let error):
                XCTFail("Error: \(error)")
                
            }
            
        }
    }
    
    func testUpdateTask_failure() {
        // Создаём тестовые данные, где id не задан
        let updatedTask = TaskModel(label: "newLabel", caption: "newCaption")
        
        // Ожидаем ошибку при выполнении updateTask
        let expectation = expectation(description: "Expected failure in updateTask")
        
        interactor.updateTask(task: updatedTask) { result in
            switch result {
            case .success:
                XCTFail("Wrong behavior, error expected")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should not be nil")
                XCTAssertEqual(error.localizedDescription, "Task not found")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0) // Учитываем асинхронность
    }
    


}
