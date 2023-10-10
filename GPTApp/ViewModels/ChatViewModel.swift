import Foundation
import SwiftUI
import RealmSwift

class ChatViewModel: ObservableObject {
    
    @ObservedRealmObject var chatMessageRealmGroup: ChatMessageRealmGroup
    
    @Published var messagesCount: Int?
    @Published var messageText: String = "" 
    @Published var sizesOfChatWindow: CGSize = .zero
    @Published var downButtonOpacity: Double = 0.0
    @Published var downButtonDisabled: Bool = true
    @Published var answerGeneratingHUD = false
    @Published var showAlert: Bool = false
    
    let openAIService = OpenAIService()
    
    init() {
        let realm = ChatMessageRealmGroup.CreateRealm
        let chatMessageRealmGroupObject = realm.objects(ChatMessageRealmGroup.self)
        self.chatMessageRealmGroup = chatMessageRealmGroupObject.first!
        self.messagesCount = chatMessageRealmGroupObject.first!.chatMessagesRealm.count
    }
    
    func sendMessage(){
        let newMessage = ChatMessageRealm(value: ["id":"\(UUID().uuidString)","content": "\(messageText)", "role": "\(SenderRole.user)"])
        if messageText != "" {
            $chatMessageRealmGroup.chatMessagesRealm.append(newMessage)
            messagesCount = chatMessageRealmGroup.chatMessagesRealm.count
            messageText = ""
            Task{
                answerGeneratingHUD.toggle()
                let response = await openAIService.sendMessage(messages: Array(chatMessageRealmGroup.chatMessagesRealm))
                guard let receivedOpenAIMessage = response?.choices.first?.message else{
                    print("No receive message")
                    let receivedMessage = ChatMessageRealm(value: ["id":"\(UUID().uuidString)","content": "Sorry, something go wrong, try again later", "role": "\(SenderRole.assistant)"])
                    $chatMessageRealmGroup.chatMessagesRealm.append(receivedMessage)
                    messagesCount = chatMessageRealmGroup.chatMessagesRealm.count
                    answerGeneratingHUD.toggle()
                    return
                }
                let receivedMessage = ChatMessageRealm(value: ["id":"\(UUID().uuidString)","content": "\(receivedOpenAIMessage.content)", "role": "\(receivedOpenAIMessage.role)"])
                await MainActor.run{
                    $chatMessageRealmGroup.chatMessagesRealm.append(receivedMessage)
                    messagesCount = chatMessageRealmGroup.chatMessagesRealm.count
                    answerGeneratingHUD.toggle()
                }
            }
        }
    }
    
    func clearChat(){
        let realm = try! Realm()
        try! realm.write {
            let allChatMessages = realm.objects(ChatMessageRealm.self)
            realm.delete(allChatMessages)
        }
        messagesCount = chatMessageRealmGroup.chatMessagesRealm.count
    }
    
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
    
    func endEditing() {
        UIApplication.shared.endEditing()
    }
    
}
