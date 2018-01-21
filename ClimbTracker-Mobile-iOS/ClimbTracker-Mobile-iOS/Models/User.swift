//
//  User.swift
//  ClimbTracker-Mobile-iOS
//
//  Created by Matthew Richardson on 1/14/18.
//  Copyright © 2018 Matthew Richardson. All rights reserved.
//

import UIKit

struct UserWrapper: ApiModel {
    
    var errors: [String]
    var model: User
    
    init(model: User) {
        self.model = model;
        self.errors = [];
    }
    
}

struct User: Codable {
    
    var name: String
    
}
