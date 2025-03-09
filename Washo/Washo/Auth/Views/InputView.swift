//
//  InputView.swift
//  Don't Crash Out
//
//  Created by Amaan Amaan on 10/12/24.
//

import SwiftUI

struct InputView: View {
    let placeholder: String
    var isSecureField: Bool = false
    @Binding var text: String
    var body: some View {
        VStack(spacing: 12){
            
            if isSecureField {
                SecureField(placeholder, text: $text)
            }else {
                TextField(placeholder, text: $text)
            }
            Divider()
        }
        
    }
}

#Preview {
    InputView(
        placeholder: "email or phone number",
        text: .constant("")
    )
}

