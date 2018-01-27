//
//  ClimbingSession.swift
//  ClimbTracker-Mobile-iOS
//
//  Created by Matthew Richardson on 1/21/18.
//  Copyright © 2018 Matthew Richardson. All rights reserved.
//

import UIKit

struct ClimbingSessionResponse: ApiResponseModel {
    
    var errors: [String]?
    var model: ClimbingSession?
    
}

struct ClimbingSession: Decodable, ApiRequestModel {
    var climbs: [Climb]
    var date: Date
    var info: SessionInfo?
    
    init() {
        self.climbs = [Climb(location: "", grade: "V16", climbType: "Boulder", completionType: "Flash"),
                       Climb(location: "", grade: "V12", climbType: "Boulder", completionType: "Onsite")];
        
        // Initialize Date components
        var dateComponents = DateComponents();
        dateComponents.calendar = Calendar(identifier: .gregorian);
        dateComponents.year = 1995;
        dateComponents.month = 2;
        dateComponents.day = 23;
        self.date = dateComponents.date!;
        
        self.info = SessionInfo(energyBefore: 9, energyAfter: 6); 
    }
}

//class ClimbingSession: ApiModel {
//    var climbs: [Climb] = [];
//    var date: Date = Date()
//    var info: SessionInfo?
//
////    override init() {
////        self.climbs = [Climb(grade: "V16", climbType: "Boulder", completionType: "Flash"),
////                       Climb(grade: "V12", climbType: "Boulder", completionType: "Onsite")];
////
////        // Initialize Date components
////        var dateComponents = DateComponents();
////        dateComponents.calendar = Calendar(identifier: .gregorian);
////        dateComponents.year = 1995;
////        dateComponents.month = 2;
////        dateComponents.day = 23;
////        self.date = dateComponents.date!;
////    }
//}

