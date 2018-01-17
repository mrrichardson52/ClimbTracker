//
//  ApiResponse.swift
//  ClimbTracker-Mobile-iOS
//
//  Created by Matthew Richardson on 1/15/18.
//  Copyright © 2018 Matthew Richardson. All rights reserved.
//

import UIKit

// do not instantiate this class - only inherit from this
class ApiModel: Codable {
    
    var errors: [String]?
    
    enum CodingKeys: String, CodingKey {
        case errors
        case model
    }
    
    // make sure to call super at the end on any child
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        errors = try? values.decode([String].self, forKey: .errors)
    }
    
    func encode(to encoder: Encoder) throws {
        // override this
    }
}
