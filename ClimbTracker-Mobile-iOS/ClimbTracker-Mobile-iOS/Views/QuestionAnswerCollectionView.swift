//
//  QuestionAnswerCollectionView.swift
//  ClimbTracker-Mobile-iOS
//
//  Created by Matthew Richardson on 1/25/18.
//  Copyright © 2018 Matthew Richardson. All rights reserved.
//

import UIKit

class QuestionAnswerCollectionView: UICollectionView {

    // stores all of the possible answers that will display as buttons
    // in the collection view
    var answers: Array<String> = [];
    
    // this stores the indexpath of the answer that the user chose
    // This will be nil until something is selected
    var indexPathOfAnswer: IndexPath?

}
