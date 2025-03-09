//
//  User.swift
//  Don't Crash Out
//
//  Created by Amaan Amaan on 11/12/24.
//

import Foundation

struct User: Codable {
    let uid: String
    let email: String
    let fullName: String
    let role: String // "admin" or "worker"

    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

