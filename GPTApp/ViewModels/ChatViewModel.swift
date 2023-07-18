//
//  ChatViewModel.swift
//  GPTApp
//
//  Created by TouKir on 01/07/2023.
//

import Foundation
import SwiftUI

class ChatViewModel: ObservableObject {
    
    @Published var chatMessages: [ChatMessage] = []
    @Published var messageText: String = ""
    @Published var offset = CGFloat.zero
    @Published var currentBottomOfTheChat = CGFloat.zero
    @Published var downButtonOpacity: Double = 0.0 
    @Published var downButtonDisabled: Bool = true
    
    let openAIService = OpenAIService()
    
    func sendMessage(){
        let newMessage = ChatMessage(id: UUID().uuidString, content: messageText , dateCreated: Date(), role: .user)
        if messageText != "" {
            
            chatMessages.append(newMessage)
            messageText = ""
            
            Task{
                let response = await openAIService.sendMessage(messages: chatMessages)
                guard let receivedOpenAIMessage = response?.choices.first?.message else{
                    print("No receive message")
                    return
                }
                let receivedMessage = ChatMessage(id: UUID().uuidString, content:receivedOpenAIMessage.content , dateCreated: Date(), role: receivedOpenAIMessage.role)
                await MainActor.run{
                    chatMessages.append(receivedMessage)
                }
            }
            
        }
        
    }
    

    
    static let sampleMessages = [
        ChatMessage(id: UUID().uuidString, content: "Sample message from user", dateCreated: Date(), role: .user),
        ChatMessage(id: UUID().uuidString, content: "Sample message from gpt", dateCreated: Date(), role: .assistant),
        ChatMessage(id: UUID().uuidString, content: "Sample message from user", dateCreated: Date(), role: .user),
        ChatMessage(id: UUID().uuidString, content: "Sample message from gpt", dateCreated: Date(), role: .assistant)
    ]
    
    
    
    func downButtonOnScreenLogic() {
        
        DispatchQueue.global().async {
            
            if self.offset < self.currentBottomOfTheChat {
                
                DispatchQueue.main.async {
                    self.downButtonOpacity = 0.85
                    self.downButtonDisabled = false
                }
                
                
            }else{
                
                DispatchQueue.main.async {
                    self.downButtonOpacity = 0.0
                    self.downButtonDisabled = true
                }
    
            }
            
        }
    }
    
    
}

