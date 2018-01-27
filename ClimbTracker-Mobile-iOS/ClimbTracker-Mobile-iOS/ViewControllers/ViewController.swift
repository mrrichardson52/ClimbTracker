//
//  ViewController.swift
//  ClimbTracker-Mobile-iOS
//
//  Created by Matthew Richardson on 1/14/18.
//  Copyright © 2018 Matthew Richardson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    static let TOKEN_KEY = "TOKEN_KEY";
    
    var request: AnyObject?
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var storeSessionButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    let password: String = "password"
    let nickname: String = "mitchapalooza"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func registerUser(_ sender: Any) {
        // grab the name
        guard let username = textField.text else {
            return;
        }
        
        // make sure the name is not empty
        if username == "" {
            NSLog("Error: name is empty");
            return;
        }
        
        // make the register request
        let registerResource = RegisterResource();
        let requestModel = User(username: username, nickname: nickname, password: password);
        let apiRequest = ApiRequest(resource: registerResource, httpMethod: "POST", requestModel: requestModel);
        self.request = apiRequest;
        apiRequest.load(withCompletion: { (getResponse: () throws -> ResultResponse) in
            do {
                let resultResponse = try getResponse();
                if let errors = resultResponse.errors {
                    NSLog("ERROR: " + errors[0]);
                    return;
                }
                guard let result = resultResponse.model else {
                    NSLog("ERROR: resut model is nil.");
                    return;
                }
                if (result.success) {
                    NSLog("Registered user successfully!");
                } else {
                    NSLog("ERROR: User not registered.");
                }
            } catch DataLoadingErrors.DecodedModelEmpty {
                NSLog("ERROR: decoded model is empty");
            } catch DataLoadingErrors.NoDataReturned {
                NSLog("ERROR: no data returned");
            } catch DataLoadingErrors.Unauthorized {
                NSLog("ERROR: unauthorized");
            } catch {
                NSLog("ERROR: " + error.localizedDescription);
            }
        });
    }
    
    @IBAction func login(_ sender: Any) {
        // grab the name
        guard let username = textField.text else {
            return;
        }
        
        // make sure the name is not empty
        if username == "" {
            NSLog("Error: name is empty");
            return;
        }
        
        loginUser(username: username);
    }
    
    func loginUser(username: String) {

        let loginResource = LoginResource();
        let requestModel = User(username: username, nickname: nickname, password: password);
        let apiRequest = ApiRequest(resource: loginResource, httpMethod: "POST", requestModel: requestModel);
        self.request = apiRequest;
        apiRequest.load(withCompletion: { (getResponse: () throws -> LoginResultResponse) in
            do {
                let loginResultResponse = try getResponse();
                if let errors = loginResultResponse.errors {
                    NSLog("ERROR: %@", errors[0]);
                    return;
                }
                guard let loginResult = loginResultResponse.model else {
                    NSLog("ERROR: Result model is nil.");
                    return;
                }
                let token = loginResult.token;
                NSLog("Login successful. Received token: " + token);
                // save the token in nsuserdefaults
                let defaults = UserDefaults();
                defaults.setValue(token, forKey: ViewController.TOKEN_KEY);
                defaults.synchronize();
            } catch DataLoadingErrors.DecodedModelEmpty {
                NSLog("ERROR: decoded model is empty");
            } catch DataLoadingErrors.NoDataReturned {
                NSLog("ERROR: no data returned");
            } catch DataLoadingErrors.Unauthorized {
                NSLog("ERROR: unauthorized");
            } catch {
                NSLog("ERROR: " + error.localizedDescription);
            }
        });
    }
    
    @IBAction func storeSession(_ sender: Any) {
        let storeSessionResource = StoreSessionResource();
        let requestModel = ClimbingSession();
        let apiRequest = ApiRequest(resource: storeSessionResource, httpMethod: "POST", requestModel: requestModel);
        self.request = apiRequest;
        apiRequest.load(withCompletion: { (getResponse: () throws -> ResultResponse) in
            do {
                let resultResponse = try getResponse();
                if let errors = resultResponse.errors {
                    NSLog("ERROR: %@", errors[0]);
                    return;
                }
                guard let result = resultResponse.model else {
                    NSLog("ERROR: result model is nil.");
                    return;
                }
                if (result.success) {
                    NSLog("Climbing session stored successfully!");
                } else {
                    NSLog("ERROR: Climbing session was not stored.");
                }
            } catch DataLoadingErrors.DecodedModelEmpty {
                NSLog("ERROR: decoded model is empty");
            } catch DataLoadingErrors.NoDataReturned {
                NSLog("ERROR: no data returned");
            } catch DataLoadingErrors.Unauthorized {
                NSLog("ERROR: unauthorized");
            } catch {
                NSLog("ERROR: " + error.localizedDescription);
            }
        });

    }
    
    @IBAction func logout(_ sender: Any) {
        let defaults = UserDefaults();
        defaults.removeObject(forKey: ViewController.TOKEN_KEY);
        defaults.synchronize(); 
    }
}

