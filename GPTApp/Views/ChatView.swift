//
//  ChatView.swift
//  GPTApp
//
//  Created by TouKir on 01/07/2023.
//

import SwiftUI
import RealmSwift

struct ChatView: View {
    
    @EnvironmentObject private var vm: ChatViewModel
    private let spaceName = "scroll"
    
    var body: some View {
        
        ZStack{
            VStack {
                
                chatWindow
                    
                
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

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {

            Group{
                ChatView()
                    .preferredColorScheme(.light)
                    .environmentObject(ChatViewModel())
                ChatView()
                    .preferredColorScheme(.dark)
                    .environmentObject(ChatViewModel())
            }
        
    }
}

extension ChatView {
    
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
    
    private var chatWindow: some View{

        ScrollViewReader{ proxy in
            
            ScrollView {
                
               
                LazyVStack{
        
                    ForEach(vm.chatMessageRealmGroup.chatMessagesRealm) { message in
                        messageView(message: message).id(message.id)
                    }
                    
                }.background(GeometryReader { currentUserPosition -> Color in
                    
                    DispatchQueue.main.async {
                        
                        if vm.offset != -currentUserPosition.frame(in: .named(spaceName)).origin.y {
                            
                            vm.offset = -currentUserPosition.frame(in: .named(spaceName)).origin.y
                            vm.downButtonOnScreenLogic()
                            
                        }
                        
                        
                    }
                    
                    return Color.clear
                })
                
            }
            
            .coordinateSpace(name: spaceName)
            .onChange(of: vm.messagesCount) { _ in
                
//                print(vm.messagesCount!)
                
                scrollToBottomOfChat(proxy)
            
            }
            .onAppear {
                scrollToBottomOfChat(proxy)
            }
            .onTapGesture {
                self.endEditing()
            }
            
            .overlay(alignment: .bottomTrailing, content: {
                Button {
                    
                    scrollToBottomOfChat(proxy)
                    
                } label: {
                    downArrowImageView
                }
                .disabled(vm.downButtonDisabled)
                
            })
            .padding()
            
        }
        
    }
    
    
    private var userTextField: some View{
        
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
    
    
    private var sendButton: some View{
        Button {
            
            self.endEditing()
            vm.sendMessage()
            
        } label: {
            Text("Send")
                .foregroundColor(Color(Constants.chatTextColors))
                .padding()
                .background(Color(Constants.chatEnviromentColors))
                .cornerRadius(12)
        }
    }
    
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
    
    
    private func scrollToBottomOfChat(_ proxy: ScrollViewProxy){
        
        withAnimation {
            proxy.scrollTo(vm.chatMessageRealmGroup.chatMessagesRealm.last?.id, anchor: .bottom)
        }
        
        vm.currentBottomOfTheChat = vm.offset
    }
    
    private var downArrowImageView: some View {
        Image(systemName: "arrow.down")
            .resizable()
            .scaledToFit()
            .frame(width: 18, height: 18)
            .foregroundColor(Color(Constants.chatTextColors).opacity(vm.downButtonOpacity))
            .frame(width: 33, height: 33)
            .background(Color(Constants.chatEnviromentColors).opacity(vm.downButtonOpacity))
            .cornerRadius(100)
            .shadow(radius: 10)
    }
    
    
    
}


