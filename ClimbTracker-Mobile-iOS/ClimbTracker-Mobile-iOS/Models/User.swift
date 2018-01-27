//
//  User.swift
//  ClimbTracker-Mobile-iOS
//
//  Created by Matthew Richardson on 1/14/18.
//  Copyright © 2018 Matthew Richardson. All rights reserved.
//

import UIKit

struct UserResponse: ApiResponseModel {
    
    var errors: [String]?
    var model: User?
    
}

struct User: Decodable, ApiRequestModel {
    var username: String
    var nickname: String?
    var password: String?
}

