//
//  CreateResource.swift
//  ClimbTracker-Mobile-iOS
//
//  Created by Matthew Richardson on 1/14/18.
//  Copyright © 2018 Matthew Richardson. All rights reserved.
//

import UIKit

struct CreateResource: ApiResource {
    
    var methodPath: String = "/create"
    typealias Model = UserWrapper
    
}
