//
//  OpenAIChatMessage.swift
//  GPTApp
//
//  Created by TouKir on 03/07/2023.
//

import Foundation

struct OpenAIChatMessage: Codable {
    let role: SenderRole
    let content: String
}
