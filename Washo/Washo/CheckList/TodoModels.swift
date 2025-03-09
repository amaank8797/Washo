//
//  TodoModels.swift
//  Washo
//
//  Created by Amaan Amaan on 05/01/25.
//

import Foundation

/// Represents an individual to-do task under a specific category.
struct TodoTask: Identifiable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool

    init(id: UUID = UUID(), title: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
}

/// Represents a car-wash category (e.g., Exterior Cleaning) and its list of tasks.
struct TodoCategory: Identifiable, Codable {
    let id: UUID
    var name: String
    var tasks: [TodoTask]
    var newTaskTitle: String = "" // For adding new tasks

    init(id: UUID = UUID(), name: String, tasks: [TodoTask] = []) {
        self.id = id
        self.name = name
        self.tasks = tasks
    }
}

