//
//  ChatWindow.swift
//  ChatGPT
//
//  Created by TouKir on 07/09/2023.
//

import SwiftUI

struct ChatWindow: View {
    
    @EnvironmentObject private var vm: ChatViewModel
    private let spaceName = "scroll"
    
    
    var body: some View {
        
        ScrollViewReader{ proxy in
            
            ScrollView {
                
                ChildSizeReader(size: $vm.sizesOfChatWindow){
                    
                    VStack{
                        
                        ForEach(vm.chatMessageRealmGroup.chatMessagesRealm) { message in
                            MessageView(message: message).id(message.id)
                        }
                        
                    }.background(
                        GeometryReader { proxy in
                            Color.clear.preference(
                                key: ViewOffsetKey.self,
                                value: -1 * proxy.frame(in: .named(spaceName)).origin.y
                            )
                        }
                    )
                    .onPreferenceChange(
                        ViewOffsetKey.self,
                        perform: { value in
                            
                            if (vm.sizesOfChatWindow.height - value) < 700  {
                                vm.downButtonOnScreenLogic(false)
                            } else {
                                vm.downButtonOnScreenLogic(true)
                            }
                        }
                    )
                }
            }
            
            .coordinateSpace(name: spaceName)
            .onChange(of: vm.messagesCount) { _ in scrollToBottomOfChat(proxy)}
            .onAppear {scrollToBottomOfChat(proxy)}
            .onTapGesture {vm.endEditing()}
            .overlay(alignment: .bottomTrailing, content: {
                Button {scrollToBottomOfChat(proxy)} 
            label: {
                    DownArrowImageView()
                }
                .disabled(vm.downButtonDisabled)
                
            })
            .padding()
            
        }
    }
}

struct ChatWindow_Previews: PreviewProvider {
    static var previews: some View {
        ChatWindow()
    }
}

extension ChatWindow {
    private func scrollToBottomOfChat(_ proxy: ScrollViewProxy){
        withAnimation {proxy.scrollTo(vm.chatMessageRealmGroup.chatMessagesRealm.last?.id, anchor: .bottom)}
    }
}
