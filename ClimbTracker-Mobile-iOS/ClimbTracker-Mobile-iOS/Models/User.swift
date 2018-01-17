//
//  User.swift
//  ClimbTracker-Mobile-iOS
//
//  Created by Matthew Richardson on 1/14/18.
//  Copyright © 2018 Matthew Richardson. All rights reserved.
//

import UIKit

class User: ApiModel {
    
    var name: String
    
    enum ModelKeys: String, CodingKey {
        case name
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let modelValues = try values.nestedContainer(keyedBy: ModelKeys.self, forKey: .model)
        name = try modelValues.contains(.name) ? modelValues.decode(String.self, forKey: .name) : ""
        try super.init(from: decoder);
    }
    
    override func encode(to encoder: Encoder) throws {
        // Implement later
    }
    
}
