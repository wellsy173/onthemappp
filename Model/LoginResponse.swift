//
//  LoginResponse.swift
//  On the Mapp
//
//  Created by Simon Wells on 2020/11/20.
//

import Foundation


struct LoginResponse: Codable {
    let account: Account
}

struct Account: Codable {
    let registered: Bool
    let key: String
}


