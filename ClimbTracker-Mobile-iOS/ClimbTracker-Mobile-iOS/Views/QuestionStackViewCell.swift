//
//  QuestionStackViewCell.swift
//  ClimbTracker-Mobile-iOS
//
//  Created by Matthew Richardson on 1/25/18.
//  Copyright © 2018 Matthew Richardson. All rights reserved.
//

import UIKit

// When being initialized, setupCell must be called immediately before doing anything with the object
class QuestionStackViewCell: UIView {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var labelContainer: UIView!
    
    @IBOutlet weak var questionAnswerCollectionView: QuestionAnswerCollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    typealias CollectionViewDelegateAndDataSource = UICollectionViewDataSource & UICollectionViewDelegate;
    
    // stores what question this is
    var question: Question!
    var index: Int {
        return question.index; 
    }
    
    func setupCell(question: Question, dataSourceAndDelegate: CollectionViewDelegateAndDataSource) {
        // Initialize the content
        self.question = question;
        self.questionLabel.text = question.string;
        self.answerLabel.text = "***";
        self.questionAnswerCollectionView.answers = question.answers;
        
        // set the delegate and data source for the collection view
        self.questionAnswerCollectionView.dataSource = dataSourceAndDelegate;
        self.questionAnswerCollectionView.delegate = dataSourceAndDelegate;
        
        // This allows us to use autolayout for the collection view cells
        self.flowLayout.estimatedItemSize = CGSize(width: 40, height: 20);
        
        // Register the nib(s) that will be used for the collection view cells
        self.questionAnswerCollectionView.register(UINib(nibName: "QuestionAnswerCell", bundle: nil), forCellWithReuseIdentifier: "QuestionAnswerCell");
        
        // Give the entire card a shadow
        self.addShadow();
    }
    
    private func addShadow() {
        self.layer.shadowOffset = CGSize(width: 4, height: 4);
        self.layer.shadowColor = UIColor.darkGray.cgColor;
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.5;
    }

}
