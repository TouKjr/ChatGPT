//
//  OpenAIChatResponse.swift
//  GPTApp
//
//  Created by TouKir on 03/07/2023.
//

import Foundation
import RealmSwift


struct OpenAIChatResponse: Codable{
    let choices: [OpenAIChatChoice]
}
