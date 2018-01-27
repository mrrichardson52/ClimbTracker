//
//  registerResource.swift
//  ClimbTracker-Mobile-iOS
//
//  Created by Matthew Richardson on 1/21/18.
//  Copyright © 2018 Matthew Richardson. All rights reserved.
//

import UIKit

class RegisterResource: ApiResource {
    typealias ResponseModel = ResultResponse
    typealias RequestModel = User
    var methodPath = "/registration"
}
