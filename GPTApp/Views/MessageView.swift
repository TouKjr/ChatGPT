//
//  MessageView.swift
//  ChatGPT
//
//  Created by TouKir on 07/09/2023.
//

import SwiftUI

struct MessageView: View {
    let message: ChatMessageRealm
    var body: some View {
        HStack{
            if message.role == .user {Spacer()}
            
            
            Text(message.content)
                .textSelection(.enabled)
                .foregroundColor(message.role == .user ? .white : Color(Constants.chatEnviromentColors))
                .padding()
                .background(message.role == .user ? .blue.opacity(0.9) : .gray.opacity(0.3))
                .cornerRadius(16)
            
            
            if message.role == .assistant {Spacer()}
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(message: ChatMessageRealm(value: ["content": "fluffy coasters", "role": "\(SenderRole.user.rawValue)"]))
    }
}
