//
//  HUDProgressView.swift
//  ChatGPT
//
//  Created by TouKir on 06/09/2023.
//

import SwiftUI

struct HUDProgressView: View {
    var placeholder: String
    @State private var animate = false
    
    
    var body: some View {
        VStack(spacing: 28) {
            Circle()
                .stroke(AngularGradient(gradient:.init(colors: [Color.primary,Color.primary.opacity (0)]), center: .center))
                .frame(width: 80, height: 80)
                .rotationEffect(.init(degrees: animate ? 360 : 0))
            Text(placeholder)
                .fontWeight(.bold)
        }
        .padding(.vertical, 25)
        .padding(.horizontal, 35)
        .background(BlurView())
        .cornerRadius(20)
        .frame(maxWidth: .infinity,  maxHeight: .infinity)
        .background(Color.primary.opacity(0.35))
        .onAppear {
            withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)){
                animate.toggle()
            }
        }
        
        
    }
}


struct HUDProgressView_Previews: PreviewProvider {
    static var previews: some View {
        
        HUDProgressView(placeholder: "Wait Testus")
        
    }
}



