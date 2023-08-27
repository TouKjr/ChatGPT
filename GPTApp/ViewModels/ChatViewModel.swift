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
    @Published var chatMessages: [ChatMessage] = []
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
        
    }
    
    
    func sendMessage(){
        
        
        // Временно убрал дату создания
        let newMessage = ChatMessageRealm(value: ["id":"\(UUID().uuidString)","content": "\(messageText)", "role": "\(SenderRole.user)"])
        if messageText != "" {
            //Очень плохая реализация, не забыть исправить
            //Ситуация такова, что нужно разобраться с тем, как работает write и возвращение realm и как следствие это исправить, скорее всего нужно ввести имплементацию выше в функции
            
            $chatMessageRealmGroup.chatMessagesRealm.append(newMessage)
            
            
            
            messageText = ""
            
            Task{
                let response = await openAIService.sendMessage(messages: Array(chatMessageRealmGroup.chatMessagesRealm))
                guard let receivedOpenAIMessage = response?.choices.first?.message else{
                    print("No receive message")
                    return
                }
                
                
                //Временно убрал дату создания
                
                let receivedMessage = ChatMessageRealm(value: ["id":"\(UUID().uuidString)","content": "\(receivedOpenAIMessage.content)", "role": "\(receivedOpenAIMessage.role)"])
                await MainActor.run{
                    //Очень плохая реализация, не забыть исправить
                    
                    $chatMessageRealmGroup.chatMessagesRealm.append(receivedMessage)
                    
                    
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

