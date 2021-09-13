//
//  Location.swift
//  On the Mapp
//
//  Created by Simon Wells on 2020/11/20.
//

import Foundation

struct Location: Codable {
    let createdAt: String
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectId: String
    let uniqueKey: String?
    let updatedAt: String
    
    
    var locationLabel: String {
        var name = ""
        if let firstName = firstName {
            name = firstName
        }
        if let lastName = lastName {
            if name.isEmpty {
                name = lastName
            } else{
                name += " \(lastName)"
            }
        }
            if name.isEmpty {
                name = "FirstName Last Name"
            }
            return name
        }
    }
