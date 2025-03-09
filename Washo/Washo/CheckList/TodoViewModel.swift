//
//  TodoViewModel.swift
//  Washo
//
//  Created by Amaan Amaan on 05/01/25.
//

import Foundation
import SwiftUI

class TodoViewModel: ObservableObject {
    @Published var categories: [TodoCategory] = []

    private let userDefaultsKey = "TodoCategories"

    init() {
        loadCategories()
        if categories.isEmpty {
            // If there is no data in UserDefaults, seed with the initial categories.
            seedInitialCategories()
        }
    }

    // MARK: - Public Methods

    /// Add a new task to a specific category.
    func addTask(to category: TodoCategory, title: String) {
        guard let index = categories.firstIndex(where: { $0.id == category.id }) else { return }
        let newTask = TodoTask(title: title)
        categories[index].tasks.append(newTask)
        saveCategories()
    }

    /// Toggle completion status of a task.
    func toggleTaskCompletion(category: TodoCategory, task: TodoTask) {
        guard
            let categoryIndex = categories.firstIndex(where: { $0.id == category.id }),
            let taskIndex = categories[categoryIndex].tasks.firstIndex(where: { $0.id == task.id })
        else { return }

        categories[categoryIndex].tasks[taskIndex].isCompleted.toggle()
        saveCategories()
    }

    /// Delete a task (via swipe-to-delete).
    func deleteTask(from category: TodoCategory, at offsets: IndexSet) {
        guard let index = categories.firstIndex(where: { $0.id == category.id }) else { return }
        categories[index].tasks.remove(atOffsets: offsets)
        saveCategories()
    }

    // MARK: - Persistence

    /// Save categories to UserDefaults.
    private func saveCategories() {
        do {
            let encodedData = try JSONEncoder().encode(categories)
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
        } catch {
            print("Failed to encode categories: \(error)")
        }
    }

    /// Load categories from UserDefaults.
    private func loadCategories() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else { return }
        do {
            categories = try JSONDecoder().decode([TodoCategory].self, from: data)
        } catch {
            print("Failed to decode categories: \(error)")
        }
    }

    /// Seed with the initial categories from the provided checklist.
    private func seedInitialCategories() {
        categories = [
            TodoCategory(name: "1. Exterior Cleaning", tasks: [
                TodoTask(title: "Pre-wash inspection"),
                TodoTask(title: "Rinse car to remove loose dirt"),
                TodoTask(title: "Apply car shampoo or foam"),
                TodoTask(title: "Hand wash with a sponge/mitt"),
                TodoTask(title: "Clean wheels and tires"),
                TodoTask(title: "Remove bugs, tar, or sap"),
                TodoTask(title: "Rinse thoroughly"),
                TodoTask(title: "Dry with microfiber towels")
            ]),
            TodoCategory(name: "2. Interior Cleaning", tasks: [
                TodoTask(title: "Remove trash and personal items"),
                TodoTask(title: "Vacuum carpets, mats, and seats"),
                TodoTask(title: "Clean dashboard, vents, and center console"),
                TodoTask(title: "Wipe door panels and handles"),
                TodoTask(title: "Clean interior windows and mirrors"),
                TodoTask(title: "Shampoo carpets or upholstery (if needed)"),
                TodoTask(title: "Apply air freshener")
            ]),
            TodoCategory(name: "3. Glass and Mirrors", tasks: [
                TodoTask(title: "Clean exterior windows and mirrors"),
                TodoTask(title: "Check for streaks and polish")
            ]),
            TodoCategory(name: "4. Detailing", tasks: [
                TodoTask(title: "Apply wax or polish to the exterior"),
                TodoTask(title: "Buff and shine paintwork"),
                TodoTask(title: "Treat tires with protective dressing"),
                TodoTask(title: "Clean and dress plastic trims")
            ]),
            TodoCategory(name: "5. Additional Services", tasks: [
                TodoTask(title: "Engine bay cleaning (optional)"),
                TodoTask(title: "Headlight restoration"),
                TodoTask(title: "Apply ceramic coating"),
                TodoTask(title: "Odor removal (ozone treatment)")
            ]),
            TodoCategory(name: "6. Final Inspection", tasks: [
                TodoTask(title: "Check for missed spots or streaks"),
                TodoTask(title: "Ensure tools/materials are stored properly"),
                TodoTask(title: "Take before/after photos"),
                TodoTask(title: "Confirm customer satisfaction")
            ]),
            TodoCategory(name: "7. Maintenance and Supplies", tasks: [
                TodoTask(title: "Refill car shampoo"),
                TodoTask(title: "Restock microfiber towels"),
                TodoTask(title: "Maintain vacuum cleaners"),
                TodoTask(title: "Check other equipment")
            ])
        ]
        saveCategories()
    }
}

