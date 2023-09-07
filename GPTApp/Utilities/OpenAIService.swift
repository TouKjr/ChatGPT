//
//  OpenAIService.swift
//  GPTApp
//
//  Created by TouKir on 01/07/2023.
//

import Foundation
import Alamofire
import SwiftUI

class OpenAIService{
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    func sendMessage(messages: [ChatMessageRealm]) async -> OpenAIChatResponse?{
        let openAIMessages = messages.map({OpenAIChatMessage(role: $0.role, content: $0.content)})
        
        let body = OpenAIChatBody(model: "gpt-3.5-turbo-16k", messages: openAIMessages, temperature: 0.7)
        
        let headers: HTTPHeaders = [
            "Authorization":"Bearer \(Constants.openAIAPIKey)"
        ]
        
        return try? await AF.request(baseURL, method: .post, parameters: body, encoder: .json, headers: headers).serializingDecodable(OpenAIChatResponse.self).value
    }
}
