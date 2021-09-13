//
//  ErrorResponse.swift
//  On the Mapp
//
//  Created by Simon Wells on 2021/5/13.
//

import Foundation

struct ErrorResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    
    enum Codingkeys: String, CodingKey {
        case statusCode = "status"
        case statusMessage = "error"
        
    }    
}
