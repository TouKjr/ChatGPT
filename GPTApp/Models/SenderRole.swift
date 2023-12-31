//
//  SenderRole.swift
//  GPTApp
//
//  Created by TouKir on 03/07/2023.
//

import Foundation
import RealmSwift

enum SenderRole: String, Codable, PersistableEnum {
    case system
    case user
    case assistant
}
