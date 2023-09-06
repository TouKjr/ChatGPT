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
    
    
    var body: some View {
        
        ZStack{
            
            VStack {
                
                ChatWindow()
                
                
                HStack{
                    UserTextField()
                    VStack{
                        sendButton
                        clearButton
                    }
                    
                }
                .frame(height: 120)
                .padding(.bottom, 30)
                
            }
            
            if vm.answerGeneratingHUD {
                
                    HUDProgressView(placeholder: "GPT is thinking...")
                        .ignoresSafeArea(.all)
                
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
        
    private var sendButton: some View{
        Button {
            
            vm.endEditing()
            vm.sendMessage()
            
        } label: {
            ChatButtonTemplate(buttonText: "Send")
        }
    }
    
    private var clearButton: some View{
        Button {
            
            vm.endEditing()
            vm.clearChatPopUp()
            
            
        } label: {
            ChatButtonTemplate(buttonText: "Clear")
        }
    }
    
}


