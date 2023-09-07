//
//  DownArrowImageView.swift
//  ChatGPT
//
//  Created by TouKir on 07/09/2023.
//

import SwiftUI

struct DownArrowImageView: View {
    @EnvironmentObject private var vm: ChatViewModel
    
    var body: some View {
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
