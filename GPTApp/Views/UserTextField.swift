//
//  UserTextField.swift
//  ChatGPT
//
//  Created by TouKir on 07/09/2023.
//

import SwiftUI

struct UserTextField: View {
    
    @EnvironmentObject private var vm: ChatViewModel
    
    var body: some View {
        TextEditor(text: $vm.messageText)
            .frame(width: 260, height: 150)
            .cornerRadius(12)
            .overlay(content: {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(Constants.chatEnviromentColors).opacity(0.45),lineWidth: 5)
            })
            .font(.subheadline)
            .padding()
    }
}

