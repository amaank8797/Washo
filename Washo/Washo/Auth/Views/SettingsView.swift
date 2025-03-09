//
//  SettingsView.swift
//  Washo
//
//  Created by Amaan Amaan on 05/01/25.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("General Settings")) {
                    Toggle("Dark Mode", isOn: .constant(false)) // Replace with a binding to user settings
                    Toggle("Notifications", isOn: .constant(true)) // Replace with a binding to user settings
                }
                
                Section(header: Text("App Info")) {
                    Text("Version: 1.0.0")
                    Text("Build: 2025.01")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView()
}



struct MoreFunctionsView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Advanced Options")) {
                    Button("Feature 1") {
                        print("Feature 1 action")
                    }
                    
                    Button("Feature 2") {
                        print("Feature 2 action")
                    }
                    
                    Button("Feature 3") {
                        print("Feature 3 action")
                    }
                }
            }
            .navigationTitle("More Functions")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//#Preview {
//    MoreFunctionsView()
//}

