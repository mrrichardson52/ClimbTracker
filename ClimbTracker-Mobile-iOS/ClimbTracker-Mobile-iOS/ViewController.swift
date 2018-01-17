//
//  ViewController.swift
//  ClimbTracker-Mobile-iOS
//
//  Created by Matthew Richardson on 1/14/18.
//  Copyright © 2018 Matthew Richardson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var request: AnyObject?
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func makeApiCall(_ sender: Any) {
        
        // grab the name
        guard let name = textField.text else {
            return;
        }
        
        // make sure the name is not empty
        if name == "" {
            NSLog("Error: name is empty");
            return;
        }
        
        // make an api call
        let createResource = CreateResource();
        let bodyParams = [ "name" : name ];
        let apiRequest = ApiRequest(resource: createResource, httpMethod: "POST", bodyParams: bodyParams);
        self.request = apiRequest; // store the request so it doesn't get deallocated by ARC
        apiRequest.load(withCompletion: { (response: User?) in
            guard let response = response else {
                return;
            }
            
            NSLog("MRR: the returned name is %@", response.name);
        });
    }
    
}

