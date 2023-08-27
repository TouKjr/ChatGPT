//
//  OpenAICompletionsBody.swift
//  GPTApp
//
//  Created by TouKir on 02/07/2023.
//

import Foundation

struct OpenAIChatBody: Codable{
    let model: String
    let messages: [OpenAIChatMessage]
    let temperature: Float?
    
}



