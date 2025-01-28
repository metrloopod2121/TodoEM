//
//  PresenterTest.swift
//  Todo_EMTests
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 29.01.2025.
//

import Foundation
import XCTest
@testable import Todo_EM

final class TodoListPresenterTests: XCTestCase {
    
    var presenter: TodoListPresenter!
    var mockViewState: MockTodoListViewState!
    var mockInteractor: MockTodoListInteractor!
    
    override func setUp() {
        super.setUp()
        
        mockViewState = MockTodoListViewState()
        mockInteractor = MockTodoListInteractor()
        presenter = TodoListPresenter(viewState: mockViewState, interactor: mockInteractor)
    }
    
    func testLoadTasks_success() {
        let expectation = self.expectation(description: "Tasks loaded")
        
        // Mocking the interactor's fetchTask to return a successful result
        let task1 = TaskModel(label: "Task 1", caption: "Caption 1")
        mockInteractor.mockFetchTaskResult = .success([task1])
        
        presenter.loadTasks()
        
        // Ожидаем завершения операции загрузки
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.mockViewState.didUpdateTasksCalled)
            XCTAssertEqual(self.mockViewState.updatedTasks?.count, 1)
            XCTAssertEqual(self.mockViewState.updatedTasks?.first?.label, "Task 1")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testLoadTasks_failure() {
        let expectation = self.expectation(description: "Error handled")
        
        // Mocking the interactor's fetchTask to return a failure result
        mockInteractor.mockFetchTaskResult = .failure(NSError(domain: "", code: 0, userInfo: nil))
        
        presenter.loadTasks()
        
        // Ожидаем завершения операции с ошибкой
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.mockViewState.didUpdateErrorCalled)
            XCTAssertEqual(self.mockViewState.updatedError, "The operation couldn’t be completed. ( error 0.)")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
}

class MockTodoListViewState: TodoListViewStateProtocol {
    
    func setUp(with presenter: any Todo_EM.TodoListPresenterProtocol) {
    }
    
    func fetchTasks() {
    }
    
    func addTask(task: Todo_EM.TaskModel) {
    }
    
    func deleteTask(by id: UUID) {
    }
    
    func updateTask(task: Todo_EM.TaskModel) {
    }
    
    var didUpdateTasksCalled = false
    var updatedTasks: [TaskModel]?
    var didUpdateErrorCalled = false
    var updatedError: String?
    
    func updateTasks(_ tasks: [TaskModel]) {
        didUpdateTasksCalled = true
        updatedTasks = tasks
    }
    
    func updateError(_ error: String) {
        didUpdateErrorCalled = true
        updatedError = error
    }
}

class MockTodoListInteractor: TodoListInteractorProtocol {
    func saveToCoreData(_ tasks: [Todo_EM.TaskModel]) {
    }
    
    func fetchTaskFromCoreData(completion: @escaping (Result<[Todo_EM.TaskModel], any Error>) -> Void) {
    }
    
    func fetchTasksFromAPI(completion: @escaping (Result<[Todo_EM.TaskModel], any Error>) -> Void) {
    }
    
    
    var mockFetchTaskResult: Result<[TaskModel], Error>?
    var mockUpdateTaskResult: Result<Void, Error>?
    var mockDeleteTaskResult: Result<Void, Error>?
    var saveTaskCalled = false
    
    func fetchTask(completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        if let result = mockFetchTaskResult {
            completion(result)
        }
    }
    
    func updateTask(task: TaskModel, completion: @escaping (Result<Void, Error>) -> Void) {
        if let result = mockUpdateTaskResult {
            completion(result)
        }
    }
    
    func saveTask(task: TaskModel) {
        saveTaskCalled = true
    }
    
    func deleteTask(by id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        if let result = mockDeleteTaskResult {
            completion(result)
        }
    }
}
