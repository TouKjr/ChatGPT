//
//  ChatView.swift
//  GPTApp
//
//  Created by TouKir on 01/07/2023.
//

import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject private var vm: ChatViewModel
    
    
    
    var body: some View {
        
        VStack {
            chatWindow
            HStack{
                userTextField
                sendButton
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
    
    func messageView(message: ChatMessage) -> some View{
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
                    ForEach(vm.chatMessages, id: \.id) { message in
                        messageView(message: message).id(message.id)
                    }
                }
                
            }
            .onChange(of: vm.chatMessages.count) { _ in
                withAnimation {
                    proxy.scrollTo(vm.chatMessages.last?.id)
                }
                
            }
            .onTapGesture {
                self.endEditing()
            }
            .overlay(alignment: .bottomTrailing, content: {
                Button {
                    
                    withAnimation {
                        proxy.scrollTo(vm.chatMessages.last?.id)
                    }
                    
                } label: {
                    Image(systemName: "arrow.down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                        .foregroundColor(Color(Constants.chatTextColors).opacity(0.85))
                        .frame(width: 24, height: 24)
                        .background(Color(Constants.chatEnviromentColors).opacity(0.85))
                        .cornerRadius(100)
                }
                
            })
            .padding()
        }
    }
    
    
    private var userTextField:some View{
        
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
    
}

