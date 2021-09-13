//
//  StudentLocation.swift
//  On the Mapp
//
//  Created by Simon Wells on 2020/12/14.
//

import Foundation

struct StudentLocations: Codable {
    
    let results: [StudentInformation]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}
