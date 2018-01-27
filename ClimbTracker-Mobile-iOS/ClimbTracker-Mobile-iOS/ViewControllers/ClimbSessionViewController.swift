//
//  ClimbSessionViewController.swift
//  ClimbTracker-Mobile-iOS
//
//  Created by Matthew Richardson on 1/26/18.
//  Copyright © 2018 Matthew Richardson. All rights reserved.
//

import UIKit

class ClimbSessionViewController: UIViewController {
    
    var climbs: [Climb] = [];
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addClimbButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews();
    }
    
    func setupViews() {
        self.setupTableView();
    }
    
    func setupTableView() {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.register(UINib(nibName: "ClimbTableViewCell", bundle: nil), forCellReuseIdentifier: "ClimbTableViewCell");
        self.tableView.tableFooterView = UIView(frame: .zero);
        self.tableView.reloadData(); 
    }

    @IBAction func addClimbButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "CreateClimbViewController") as? CreateClimbViewController else {
            return;
        }
        viewController.delegate = self;
        self.navigationController?.pushViewController(viewController, animated: true);
    }
}

// MARK: CreateClimbDelegate functions

extension ClimbSessionViewController: CreateClimbDelegate {
    func add(climb: Climb) {
        self.climbs.append(climb);
        self.tableView.reloadData(); 
    }
}

// MARK: UITableViewDataSource functions

extension ClimbSessionViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (climbs.count == 0) {
            return "Wow. You haven't climbed anything.";
        }
        return "You climbed these!";
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return climbs.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ClimbTableViewCell") as? ClimbTableViewCell else {
            return UITableViewCell();
        }
        
        // grab the climb at this index
        let climb = self.climbs[indexPath.row];
        cell.climbTypeLabel.text = climb.climbType;
        cell.gradeLabel.text = climb.grade;
        cell.completionTypeLabel.text = climb.completionType!
        cell.locationLabel.text = climb.location;
        cell.countLabel.text = String(indexPath.row + 1);
        
        return cell;
    }
    
    
}

// MARK: UITableViewDelegate functions

extension ClimbSessionViewController: UITableViewDelegate {
    
    
    
}
