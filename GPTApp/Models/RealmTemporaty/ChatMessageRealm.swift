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

    @Persisted var content = ""

//    @Persisted var dateCreated = Date()

    @Persisted var role = SenderRole.user.rawValue
    
    /// The backlink to the `ItemGroup` this item is a part of.
    @Persisted(originProperty: "chatMessagesRealm") var group: LinkingObjects<ChatMessageRealmGroup>
    
}

/// Represents a collection of items.
final class ChatMessageRealmGroup: Object, ObjectKeyIdentifiable {
    /// The unique ID of the ItemGroup. `primaryKey: true` declares the
    /// _id member as the primary key to the realm.
    @Persisted(primaryKey: true) var _id: ObjectId

    /// The collection of Items in this group.
    @Persisted var chatMessagesRealm = RealmSwift.List<ChatMessageRealm>()
    
}

extension ChatMessageRealm {
    static let chatMessage1 = ChatMessageRealm(value: ["content": "fluffy coasters", "role": "\(SenderRole.user.rawValue)"])
    static let chatMessage2 = ChatMessageRealm(value: ["content": "sudden cinder block", "role": "\(SenderRole.assistant.rawValue)"])
    static let chatMessage3 = ChatMessageRealm(value: ["content": "classy mouse pad", "role": "\(SenderRole.user.rawValue)"])
}


extension ChatMessageRealmGroup {
    static let chatMessageRealmGroup = ChatMessageRealmGroup(value: ["ownerId": "previewRealm"])
    
    static var previewRealm: Realm {
        var realm: Realm
        let identifier = "previewRealm"
        let config = Realm.Configuration(inMemoryIdentifier: identifier)
        do {
            realm = try Realm(configuration: config)
            // Check to see whether the in-memory realm already contains an ItemGroup.
            // If it does, we'll just return the existing realm.
            // If it doesn't, we'll add an ItemGroup and append the Items.
            let realmObjects = realm.objects(ChatMessageRealmGroup.self)
            if realmObjects.count == 1 {
                return realm
            } else {
                try realm.write {
                    realm.add(chatMessageRealmGroup)
                    chatMessageRealmGroup.chatMessagesRealm.append(objectsIn: [ChatMessageRealm.chatMessage1, ChatMessageRealm.chatMessage2, ChatMessageRealm.chatMessage3])
                }
                return realm
            }
        } catch let error {
            fatalError("Can't bootstrap item data: \(error.localizedDescription)")
        }
    }
}

struct ChatMessageRow: View {
    @ObservedRealmObject var chatMessageRealm: ChatMessageRealm
    var body: some View {
        // You can click an item in the list to navigate to an edit details screen.
        NavigationLink(destination: ChatMessageDetailsView(chatMessageRealm: chatMessageRealm)) {
            Text(chatMessageRealm.content)
        }
    }
}

struct ChatMessageDetailsView: View {
    @ObservedRealmObject var chatMessageRealm: ChatMessageRealm
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(chatMessageRealm.content)")
                .navigationBarTitle(chatMessageRealm.content)
            Text("\(chatMessageRealm.role)")
                .navigationBarTitle(chatMessageRealm.role)
        }.padding()
    }
}
