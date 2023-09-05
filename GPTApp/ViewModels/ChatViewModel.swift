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
    //    @Published var chatMessages = [ChatMessage]()
    @Published var messagesCount: Int?
    @Published var messageText: String = ""
    @Published var offset: CGSize = .zero
    @Published var currentBottomOfTheChat: CGSize = .zero
    @Published var downButtonOpacity: Double = 0.0
    @Published var downButtonDisabled: Bool = true
    
    let openAIService = OpenAIService()
    
    init() {
        
        let realm = ChatMessageRealmGroup.CreateRealm
        let chatMessageRealmGroupObject = realm.objects(ChatMessageRealmGroup.self)
        self.chatMessageRealmGroup = chatMessageRealmGroupObject.first!
        self.messagesCount = chatMessageRealmGroupObject.first!.chatMessagesRealm.count
        
    }
    
    
    func sendMessage(){
        
        
        // Временно убрал дату создания сообщения
        let newMessage = ChatMessageRealm(value: ["id":"\(UUID().uuidString)","content": "\(messageText)", "role": "\(SenderRole.user)"])
        
        if messageText != "" {
            
            
            
            $chatMessageRealmGroup.chatMessagesRealm.append(newMessage)
            //Переделать на более грамотное решение
            
            messagesCount = chatMessageRealmGroup.chatMessagesRealm.count
            
            messageText = ""
            
            Task{
                let response = await openAIService.sendMessage(messages: Array(chatMessageRealmGroup.chatMessagesRealm))
                guard let receivedOpenAIMessage = response?.choices.first?.message else{
                    print("No receive message")
                    let receivedMessage = ChatMessageRealm(value: ["id":"\(UUID().uuidString)","content": "Sorry, something go wrong, try again later", "role": "\(SenderRole.assistant)"])
                    
                    $chatMessageRealmGroup.chatMessagesRealm.append(receivedMessage)
                    
                    //Переделать на более грамотное решение
                    messagesCount = chatMessageRealmGroup.chatMessagesRealm.count
                    
                    
                    return
                }
                
                
                // Временно убрал дату создания сообщения
                let receivedMessage = ChatMessageRealm(value: ["id":"\(UUID().uuidString)","content": "\(receivedOpenAIMessage.content)", "role": "\(receivedOpenAIMessage.role)"])
                
                await MainActor.run{
                    
                    $chatMessageRealmGroup.chatMessagesRealm.append(receivedMessage)
                    
                    //Переделать на более грамотное решение
                    messagesCount = chatMessageRealmGroup.chatMessagesRealm.count
                    
                    
                }
            }
            
        }
        
    }
    
    func clearChatPopUp(){
        let alert = UIAlertController(title: "Warning", message: "Clear the history of this chat?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        
        let delete = UIAlertAction(title: "Delete", style: .destructive) { _ in
            
            let realm = try! Realm()
            try! realm.write {
                let allChatMessages = realm.objects(ChatMessageRealm.self)
                realm.delete(allChatMessages)
            }
            
            //Переделать на более грамотное решение
            
            self.messagesCount = self.chatMessageRealmGroup.chatMessagesRealm.count
            
        }
        
        alert.addAction(cancel)
        alert.addAction(delete)
        
        UIApplication
            .shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .last?.rootViewController?.present(alert, animated: true, completion: {
                
            })
        
        
    }
    
    
    
    static let sampleMessages = [
        ChatMessage(id: UUID().uuidString, content: "Sample message from user", dateCreated: Date(), role: .user),
        ChatMessage(id: UUID().uuidString, content: "Sample message from gpt", dateCreated: Date(), role: .assistant),
        ChatMessage(id: UUID().uuidString, content: "Sample message from user", dateCreated: Date(), role: .user),
        ChatMessage(id: UUID().uuidString, content: "Sample message from gpt", dateCreated: Date(), role: .assistant)
    ]
    
    
    
    func downButtonOnScreenLogic(_ isNotReachedTheBottom: Bool) {
        
        DispatchQueue.global().async {
            
            if isNotReachedTheBottom {
                
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

