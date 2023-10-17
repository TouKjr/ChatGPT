//
//  ChatListView.swift
//  ChatGPT
//
//  Created by TouKir on 13/10/2023.
//

import SwiftUI

struct ChatListView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                NavigationLink("Chat #1") {
                    
                }
            }
            .navigationTitle("All chats")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        
    }
}

#Preview {
    ChatListView()
}
