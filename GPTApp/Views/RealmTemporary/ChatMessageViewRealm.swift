import SwiftUI
import RealmSwift

struct ChatMessageViewRealm: View {
    
    @ObservedRealmObject var chatMessageRealmGroup: ChatMessageRealmGroup
    
    @State var messageText: String = ""
    

    var body: some View {
        ZStack{
            VStack{
                ScrollView {
                    
                    LazyVStack{
                        ForEach(chatMessageRealmGroup.chatMessagesRealm) { message in
                            messageView(message: message).id(message.id)
                        }
                        
                    }
                    
                }
                .padding()
                
                HStack{
                    userTextField
                    sendButton
                }
                .frame(height: 120)
                .padding(.bottom, 30)
            }
        }
        
        
    }
}

struct ChatMessageViewRealm_Previews: PreviewProvider {
    static var previews: some View {
        let realm = ChatMessageRealmGroup.CreateRealm
        let chatMessageRealmGroup = realm.objects(ChatMessageRealmGroup.self)
        ChatMessageViewRealm(chatMessageRealmGroup: chatMessageRealmGroup.first!)
    }
}

extension ChatMessageViewRealm {
    private func messageView(message: ChatMessageRealm) -> some View{
        HStack{
            if message.role == .user {Spacer()}
            
            
            Text(message.content)
                .foregroundColor(message.role == .user ? .white : Color(Constants.chatEnviromentColors))
                .padding()
                .background(message.role == .user ? .blue.opacity(0.9) : .gray.opacity(0.3))
                .cornerRadius(16)
            
            
            if message.role == .assistant {Spacer()}
        }
    }
    
    
    private var userTextField: some View{
        
        TextEditor(text: $messageText)
            .frame(width: 260, height: 150)
            .cornerRadius(12)
            .overlay(content: {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(Constants.chatEnviromentColors).opacity(0.45),lineWidth: 5)
            })
            .font(.subheadline)
            .padding()
        
    }
    
    private var sendButton: some View{
        Button {
            
//            self.endEditing()
//            vm.sendMessage()
            
        } label: {
            Text("Send")
                .foregroundColor(Color(Constants.chatTextColors))
                .padding()
                .background(Color(Constants.chatEnviromentColors))
                .cornerRadius(12)
        }
    }
    
}
