//
//  BlurView.swift
//  ChatGPT
//
//  Created by TouKir on 06/09/2023.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect (style: .systemThinMaterial))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
        
    }
    
    
}
