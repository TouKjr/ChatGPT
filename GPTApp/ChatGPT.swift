//
//  GPTAppApp.swift
//  GPTApp
//
//  Created by TouKir on 01/07/2023.
//

import SwiftUI

@main
struct ChatGPT: App {
    var body: some Scene {
        WindowGroup {
            ChatView()
                .environmentObject(ChatViewModel())
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
