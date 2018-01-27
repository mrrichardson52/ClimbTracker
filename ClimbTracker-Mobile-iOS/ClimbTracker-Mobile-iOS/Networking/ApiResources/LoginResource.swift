//
//  LoginResource.swift
//  ClimbTracker-Mobile-iOS
//
//  Created by Matthew Richardson on 1/21/18.
//  Copyright © 2018 Matthew Richardson. All rights reserved.
//

import UIKit

class LoginResource: ApiResource {
    typealias ResponseModel = LoginResultResponse
    typealias RequestModel = User
    var methodPath = "/login"
}
