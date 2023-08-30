//
//  ChatViewModel.swift
//  GPTApp
//
//  Created by TouKir on 01/07/2023.
//

import Foundation
import SwiftUI
import RealmSwift

class ChatViewModel: ObservableObject {
    
    
    
    @ObservedRealmObject var chatMessageRealmGroup: ChatMessageRealmGroup
    @Published var chatMessages = [ChatMessage]()
    @Published var messagesCount: Int?
    @Published var messageText: String = ""
    @Published var offset = CGFloat.zero
    @Published var currentBottomOfTheChat = CGFloat.zero
    @Published var downButtonOpacity: Double = 0.0
    @Published var downButtonDisabled: Bool = true
    
    let openAIService = OpenAIService()
    
    init() {
        
        let realm = ChatMessageRealmGroup.previewRealm
        let chatMessageRealmGroupObject = realm.objects(ChatMessageRealmGroup.self)
        self.chatMessageRealmGroup = chatMessageRealmGroupObject.first!
        self.messagesCount = chatMessageRealmGroupObject.first!.chatMessagesRealm.count
        
    }
    
    
    func sendMessage(){
        
        
        // Временно убрал дату создания сообщения
        let newMessage = ChatMessageRealm(value: ["id":"\(UUID().uuidString)","content": "\(messageText)", "role": "\(SenderRole.user)"])
        
        if messageText != "" {
            
            
            
            $chatMessageRealmGroup.chatMessagesRealm.append(newMessage)
            messagesCount = chatMessageRealmGroup.chatMessagesRealm.count
            
            
            
            messageText = ""
            
            Task{
                let response = await openAIService.sendMessage(messages: Array(chatMessageRealmGroup.chatMessagesRealm))
                guard let receivedOpenAIMessage = response?.choices.first?.message else{
                    print("No receive message")
                    return
                }
                
                
                // Временно убрал дату создания сообщения
                let receivedMessage = ChatMessageRealm(value: ["id":"\(UUID().uuidString)","content": "\(receivedOpenAIMessage.content)", "role": "\(receivedOpenAIMessage.role)"])
                
                await MainActor.run{
                    
                    $chatMessageRealmGroup.chatMessagesRealm.append(receivedMessage)
                    messagesCount = chatMessageRealmGroup.chatMessagesRealm.count
            
                    
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

