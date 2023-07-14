//
//  ChatMessage.swift
//  GPTApp
//
//  Created by TouKir on 01/07/2023.
//

import Foundation

struct ChatMessage: Codable, Identifiable{
    let id: String
    let content: String
    let dateCreated: Date
    let role: SenderRole
}
