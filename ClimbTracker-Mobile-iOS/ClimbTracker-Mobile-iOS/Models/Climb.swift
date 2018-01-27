//
//  Climb.swift
//  ClimbTracker-Mobile-iOS
//
//  Created by Matthew Richardson on 1/21/18.
//  Copyright © 2018 Matthew Richardson. All rights reserved.
//

import UIKit

struct ClimbResponse: ApiResponseModel {
    
    var errors: [String]?
    var model: Climb?
    
}

struct Climb: Decodable, ApiRequestModel {
    var location: String
    var grade: String
    var climbType: String
    var completionType: String?
}


//class Climb: ApiModel {
//    var grade: String = "";
//    var climbType: String = "";
//    var completionType: String = "";
//    
////    override init(grade: String, climbType: String, completionType: String) {
////        self.grade = grade;
////        self.climbType = climbType;
////        self.completionType = completionType;
////    }
//}

