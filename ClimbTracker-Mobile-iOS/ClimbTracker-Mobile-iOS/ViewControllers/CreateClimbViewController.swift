//
//  CreateClimbViewController.swift
//  ClimbTracker-Mobile-iOS
//
//  Created by Matthew Richardson on 1/25/18.
//  Copyright © 2018 Matthew Richardson. All rights reserved.
//

import UIKit

// When adding to this Question enum:
// 1. Update count
// 2. Add case for string property
// 3. Add case for options property
enum Question: Int {
    case Location = 0
    case ClimbType = 1
    case Grade = 2
    case Completion = 3
    
    static let count: Int = 4
    
    var string: String {
        switch self {
        case .Location:
            return "Climb location:";
        case .ClimbType:
            return "Climb type:";
        case .Grade:
            return "Grade:";
        case .Completion:
            return "Completion type:";
        }
    }
    
    var answers: [String] {
        switch self {
        case .Location:
            return ["Indoor", "Outdoor"];
        case .ClimbType:
            return ["Boulder", "Lead", "Top Rope", "Free solo", "Trad", "Ice", "Tree", "Mountain"]
        case .Grade:
            return ["V0", "V1", "V2", "V3", "V4", "V5", "V6", "V7", "V8", "V9", "V10", "V11",
                    "V12", "5.5", "5.6", "5.7", "5.8", "5.9", "5.10", "5.11", "5.12", "5.13"]
        case .Completion:
            return ["Flash", "Onsite", "Send", "Redpoint", "Failed", "Cried and left", "Hell no", "Died"]
        }
    }
    
    var index: Int {
        return self.rawValue;
    }
}

protocol CreateClimbDelegate {
    func add(climb: Climb);
}

class CreateClimbViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    var currentQuestionIndex: Int?
    var nextQuestionIndex: Int?
    var gestureRecognizers: [UITapGestureRecognizer]
    var confirmationCellIndex: Int?
    var delegate: CreateClimbDelegate!
    
    required init?(coder aDecoder: NSCoder) {
        self.gestureRecognizers = [];
        super.init(coder: aDecoder);
        for _ in 0...Question.count-1 {
            self.gestureRecognizers.append(UITapGestureRecognizer(target: self, action: #selector(cellTapped(sender:))));
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Climb";
        
        self.addQuestionViews();
        
        // store which question is currently open
        self.currentQuestionIndex = 0;
        self.nextQuestionIndex = 1;
        
        // animate the first cell coming in
        self.animateCells(closingIndex: nil, openingIndex: 0);
        
        // The collection view heights in each question cell need to be resized to wrap the content.
        // We need to make sure the collections views are laid out first so that we know their content
        // size.
        self.view.layoutIfNeeded();
        self.setCollectionViewHeights();
    }
    
    private func addQuestionViews() {
        for index in 0...Question.count-1 {
            if let question = Question(rawValue: index) {
                self.addView(forQuestion: question);
            }
        }
    }
    
    private func addView(forQuestion: Question) {
        
        guard let questionCell = Bundle.main.loadNibNamed("QuestionStackViewCell", owner: self, options: nil)?[0] as? QuestionStackViewCell else {
            return;
        }
        
        
        
        // do some initialization for the cell
        questionCell.setupCell(question: forQuestion, dataSourceAndDelegate: self);
        
        // add question to the stack and hide it
        self.stackView.addArrangedSubview(questionCell);
        questionCell.isHidden = true;
        questionCell.alpha = 0.0;
        
    }
    
    private func reset() {
        for view in self.stackView.arrangedSubviews {
            self.stackView.removeArrangedSubview(view);
            view.removeFromSuperview();
        }
        self.confirmationCellIndex = nil;
        self.view.layoutIfNeeded();
        self.currentQuestionIndex = 0;
        self.nextQuestionIndex = 1;
        
        self.addQuestionViews();
        self.animateCells(closingIndex: nil, openingIndex: 0);
        self.view.layoutIfNeeded();
        self.setCollectionViewHeights();
    }
    
    @objc func cellTapped(sender: UITapGestureRecognizer? = nil) {
        // grab the cell that was tapped
        guard let tappedCell = sender?.view as? QuestionStackViewCell else {
            return;
        }
        
        // go ahead and animate the transition
        self.animateCells(closingIndex: self.currentQuestionIndex, openingIndex: tappedCell.index);
        
        // do the logic for setting currentQuestionIndex and nextQuestionIndex
        if let openIndex = self.currentQuestionIndex {
            guard let openCell = self.stackView.arrangedSubviews[openIndex] as? QuestionStackViewCell else {
                return;
            }
            
            if (openCell.questionAnswerCollectionView.indexPathOfAnswer == nil) {
                // the open question is unanswered - we should set next question equal to the current open one
                self.nextQuestionIndex = self.currentQuestionIndex;
                
            } else if (tappedCell.questionAnswerCollectionView.indexPathOfAnswer == nil) {
                // the tapped question is unanswered.
                // we can assume that index of the current next question and the index of the tapped
                // cell are equal since you can only click forward to an unanswered question if all
                // of the previous questions have been answered.
                self.incrementNextQuestionIndex();
            }
        }
        
        // regardless, the newly opened question will be the one in the tapped cell
        self.currentQuestionIndex = tappedCell.index;
        
    }
    
    private func setCollectionViewHeights() {
        for case let cell as QuestionStackViewCell in self.stackView.arrangedSubviews {
            cell.collectionViewHeightConstraint.constant = cell.flowLayout.collectionViewContentSize.height;
        }
    }
    
    private func indicateSelected(cell: QuestionAnswerCell) {
        cell.answerLabel.textColor = .white;
        cell.view.backgroundColor = .red;
    }
    
    private func indicateUnselected(cell: QuestionAnswerCell) {
        cell.answerLabel.textColor = .red;
        cell.view.backgroundColor = .white;
    }
    
    private func incrementNextQuestionIndex() {
        if let nextIndex = self.nextQuestionIndex {
            if (nextQuestionIndex == Question.count-1) {
                self.nextQuestionIndex = nil;
            } else {
                self.nextQuestionIndex = nextIndex + 1;
            }
        }
    }
    
    private func animateClosingCell(atIndex: Int?) {
        // see if we need to close a cell
        if let closingIndex = atIndex {
            guard let closeCell = self.stackView.arrangedSubviews[closingIndex] as? QuestionStackViewCell else {
                return;
            }
            
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseIn, animations: {
                closeCell.collectionViewHeightConstraint.constant = 0;
                closeCell.questionAnswerCollectionView.isHidden = true;
                closeCell.layoutIfNeeded();
            }, completion: { _ in
                // add the tap recognizer since we're closing it and we need it to reopen it
                closeCell.addGestureRecognizer(self.gestureRecognizers[closeCell.index]);
            })
        }
    }
    
    private func animateOpeningCell(atIndex: Int?) {
        if let openingIndex = atIndex {
            guard let openCell = self.stackView.arrangedSubviews[openingIndex] as? QuestionStackViewCell else {
                return;
            }
            
            // remove the tap recognizer so it doesn't block the collection view's didselectitemat function
            openCell.removeGestureRecognizer(gestureRecognizers[openCell.index]);
            
            if (openCell.isHidden) {
                // opening cell for the first time
                // we should try to curl in from right
                openCell.collectionViewHeightConstraint.constant = openCell.flowLayout.collectionViewContentSize.height;
                openCell.stackView.arrangedSubviews[1].isHidden = false;
                openCell.isHidden = false;
                openCell.layoutIfNeeded();
                UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveEaseIn, animations: {
                    openCell.alpha = 1.0;
                }, completion: nil);
            } else {
                // opening cell has been open before.
                // we only need animate add the collection view
                UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseIn, animations: {
                    openCell.collectionViewHeightConstraint.constant = openCell.flowLayout.collectionViewContentSize.height;
                    openCell.questionAnswerCollectionView.isHidden = false;
                    openCell.layoutIfNeeded();
                }, completion: nil);
            }
        }
    }
    
    private func animateCells(closingIndex: Int?, openingIndex: Int?) {
        // start by laying everything out before transitions
        self.view.layoutIfNeeded();
        
        // now animate the closing cell and pass in opening the cell as the completion to make
        // sure the opening happens after the closing
        self.animateClosingCell(atIndex: closingIndex);
        self.animateOpeningCell(atIndex: openingIndex);
        
    }
    
    private func addConfirmationCell() {
        guard let confirmationCell = Bundle.main.loadNibNamed("ClimbConfirmationCell", owner: self, options: nil)?[0] as? ClimbConfirmationCell else {
            return;
        }
        
        // initialize buttons
        confirmationCell.newClimbButton.setTitle("Add new climb", for: .normal);
        confirmationCell.doneButton.setTitle("Done", for: .normal);
        confirmationCell.newClimbButton.layer.cornerRadius = 5;
        confirmationCell.doneButton.layer.cornerRadius = 5;
        self.addShadow(forButton: confirmationCell.newClimbButton);
        self.addShadow(forButton: confirmationCell.doneButton);
        confirmationCell.newClimbButton.addTarget(self, action: #selector(newClimbButtonClicked), for: .touchUpInside);
        confirmationCell.doneButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside);
        confirmationCell.alpha = 0.0;
        confirmationCell.isHidden = false;
        self.confirmationCellIndex = self.stackView.arrangedSubviews.count;
        self.stackView.addArrangedSubview(confirmationCell);
        self.view.layoutIfNeeded();
        
        UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveEaseIn, animations: {
            confirmationCell.alpha = 1.0;
            self.view.layoutIfNeeded();
        }, completion: nil);
    }
    
    private func shouldAddConfirmationCell() -> Bool {
        if let index = self.confirmationCellIndex {
            if (self.stackView.arrangedSubviews[index] as? ClimbConfirmationCell != nil) {
                return false;
            }
        }
        return true;
    }
    
    func addShadow(forButton: UIButton) {
        forButton.layer.shadowOffset = CGSize(width: 4, height: 4);
        forButton.layer.shadowColor = UIColor.darkGray.cgColor;
        forButton.layer.shadowRadius = 3;
        forButton.layer.shadowOpacity = 0.5;
    }
    
    @objc private func doneButtonClicked() {
        self.sendBackClimb();
        self.popBack();
    }

    @objc private func newClimbButtonClicked() {
        self.sendBackClimb();
        self.reset();
    }
    
    private func popBack() {
        self.navigationController?.popViewController(animated: true); 
    }
    
    private func sendBackClimb() {
        var climbType = "";
        var completion = "";
        var grade = "";
        var location = "";
        for index in 0...Question.count-1 {
            // first get the question cell
            guard let cell = self.stackView.arrangedSubviews[index] as? QuestionStackViewCell else {
                continue;
            }
            switch cell.question! {
            case Question.ClimbType:
                climbType = cell.answerLabel.text!;
                break;
            case Question.Completion:
                completion = cell.answerLabel.text!;
                break;
            case Question.Grade:
                grade = cell.answerLabel.text!;
                break;
            case Question.Location:
                location = cell.answerLabel.text!;
                break
            }
        }
        self.delegate.add(climb: Climb(location: location, grade: grade, climbType: climbType, completionType: completion));
    }
        
}

// MARK: UICollectionViewDelegate methods

extension CreateClimbViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard
            let answerCell = collectionView.cellForItem(at: indexPath) as? QuestionAnswerCell,
            let openIndex = self.currentQuestionIndex,
            let questionCell = self.stackView.arrangedSubviews[openIndex] as? QuestionStackViewCell  else {
            return;
        }
        
        // deselect the current answer if it exists
        if let previousIndexPath = questionCell.questionAnswerCollectionView.indexPathOfAnswer {
            if let previousSelection = collectionView.cellForItem(at: previousIndexPath) as? QuestionAnswerCell {
                self.indicateUnselected(cell: previousSelection);
            }
        }
        
        // select the new answer
        questionCell.answerLabel.text = answerCell.answerLabel.text;
        questionCell.questionAnswerCollectionView.indexPathOfAnswer = indexPath;
        self.indicateSelected(cell: answerCell);
        
        // animate the transition
        self.animateCells(closingIndex: openIndex, openingIndex: self.nextQuestionIndex);
        
        // do logic for determining currentQuestionIndex and nextQuestionIndex
        self.currentQuestionIndex = self.nextQuestionIndex;
        self.incrementNextQuestionIndex();
        
        // if curreentQuestionIndex is nil, then all questions have been answered
        // and we should show some kind of confirmation to move forward
        if (self.currentQuestionIndex == nil && self.shouldAddConfirmationCell()) {
            // add the confirmation cell
            self.addConfirmationCell();
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        // get the answer cell and highlight
        if let answerCell = collectionView.cellForItem(at: indexPath) as? QuestionAnswerCell {
            answerCell.view.backgroundColor = .gray;
            answerCell.layer.borderColor = UIColor.gray.cgColor;
            answerCell.answerLabel.textColor = .white;
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        // get the answer cell and unhighlight
        if let answerCell = collectionView.cellForItem(at: indexPath) as? QuestionAnswerCell {
            answerCell.view.backgroundColor = .white;
            answerCell.layer.borderColor = UIColor.red.cgColor;
            answerCell.answerLabel.textColor = .red;
        }
    }
    
}

// MARK: UICollectionViewDataSource methods

extension CreateClimbViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let questionAnswerCollectionView = collectionView as? QuestionAnswerCollectionView else {
            return UICollectionViewCell(); // since we must return a cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionAnswerCell", for: indexPath) as? QuestionAnswerCell else {
            return UICollectionViewCell(); // since we must return a cell
        }
        
        // fill the cell with associated answer
        cell.answerLabel.text = questionAnswerCollectionView.answers[indexPath.row];
        
        if (questionAnswerCollectionView.indexPathOfAnswer == indexPath) {
            self.indicateSelected(cell: cell);
        } else {
            self.indicateUnselected(cell: cell);
        }
        
        // make cell have smooth corners with a border
        cell.layer.cornerRadius = 5;
        cell.layer.borderColor = UIColor.red.cgColor;
        cell.layer.borderWidth = 3.0;
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let questionAnswerCollectionView = collectionView as? QuestionAnswerCollectionView {
            return questionAnswerCollectionView.answers.count;
        }
        return 0;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    // No reason to rearrange answers
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return false;
    }

}
