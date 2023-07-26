//
//  SenderRoleRealm.swift
//  ChatGPT
//
//  Created by TouKir on 18/07/2023.
//

import Foundation
import RealmSwift

enum SenderRoleRealm: String, Codable {
    case system
    case user
    case assistant
}
