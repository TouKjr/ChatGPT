//
//  ChatViewRealm.swift
//  ChatGPT
//
//  Created by TouKir on 18/07/2023.
//

import SwiftUI
import RealmSwift

struct LocalOnlyContentView: View {
    
    // Implicitly use the default realm's objects(ChatMessageRealmGroup.self)
    @ObservedResults(ChatMessageRealmGroup.self) var chatMessageRealmGroup
    
    var body: some View {
        ZStack{
            VStack {
                // The list shows the items in the realm.

                
            }
        }
    }
}


struct LocalOnlyContentView_Previews: PreviewProvider {
    static var previews: some View {
        LocalOnlyContentView()
    }
}


