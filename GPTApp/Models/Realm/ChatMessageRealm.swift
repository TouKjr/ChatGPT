//
//  ChatMessageRealm.swift
//  ChatGPT
//
//  Created by TouKir on 18/07/2023.
//

import Foundation
import RealmSwift
import SwiftUI

final class ChatMessageRealm: Object, ObjectKeyIdentifiable {
    /// The unique ID of the Item. `primaryKey: true` declares the
    /// _id member as the primary key to the realm.
    @Persisted(primaryKey: true) var _id: ObjectId

    @Persisted var content: String

    @Persisted var role: SenderRole
    
    @Persisted var dateCreated: Date
    
    /// The backlink to the `ItemGroup` this item is a part of.
    @Persisted(originProperty: "chatMessagesRealm") var group: LinkingObjects<ChatMessageRealmGroup>
    
}



extension ChatMessageRealm {
    static let chatMessage1 = ChatMessageRealm(value: ["content": "fluffy coasters", "role": "\(SenderRole.user.rawValue)"])
    static let chatMessage2 = ChatMessageRealm(value: ["content": "sudden cinder block", "role": "\(SenderRole.assistant.rawValue)"])
    static let chatMessage3 = ChatMessageRealm(value: ["content": "classy mouse pad", "role": "\(SenderRole.user.rawValue)"])
}







