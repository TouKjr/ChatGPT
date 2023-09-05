//
//  ChatButtonTemplate.swift
//  ChatGPT
//
//  Created by TouKir on 05/09/2023.
//

import SwiftUI

struct ChatButtonTemplate: View {
    let buttonText: String
    var body: some View {
        Text(buttonText)
            .foregroundColor(Color(Constants.chatTextColors))
            .padding()
            .background(Color(Constants.chatEnviromentColors))
            .cornerRadius(12)
    }
}

struct ChatButtonTemplate_Previews: PreviewProvider {
    static var previews: some View {
        ChatButtonTemplate(buttonText: "Preview")
    }
}
