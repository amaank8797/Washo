//
//  TodoListView.swift
//  Washo
//
//  Created by Amaan Amaan on 05/01/25.
//
import SwiftUI

struct TodoListView: View {
    @StateObject private var viewModel = TodoViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach($viewModel.categories) { $category in
                    TodoCategorySection(category: $category, viewModel: viewModel)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Car Wash Checklist")
        }
    }
}

struct TodoCategorySection: View {
    @Binding var category: TodoCategory
    var viewModel: TodoViewModel

    var body: some View {
        Section(header: Text(category.name)) {
            ForEach(category.tasks) { task in
                TodoTaskRow(category: category, task: task, viewModel: viewModel)
            }
            .onDelete { offsets in
                viewModel.deleteTask(from: category, at: offsets)
            }

            // Add new task inline within each category
            HStack {
                TextField("New Task...", text: $category.newTaskTitle)
                    .textFieldStyle(.roundedBorder)

                Button(action: {
                    addTask()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                }
            }
        }
    }

    private func addTask() {
        guard !category.newTaskTitle.isEmpty else { return }
        viewModel.addTask(to: category, title: category.newTaskTitle)
        category.newTaskTitle = ""
    }
}

struct TodoTaskRow: View {
    var category: TodoCategory
    var task: TodoTask
    var viewModel: TodoViewModel

    var body: some View {
        HStack {
            Button(action: {
                viewModel.toggleTaskCompletion(category: category, task: task)
            }) {
                Image(systemName: task.isCompleted ? "checkmark.square" : "square")
                    .foregroundColor(task.isCompleted ? .green : .primary)
            }
            .buttonStyle(BorderlessButtonStyle())

            Text(task.title)
                .strikethrough(task.isCompleted, color: .black)
        }
    }
}

#Preview {
    TodoListView()
}
