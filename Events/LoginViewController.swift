//
//  LoginViewController.swift
//  Events
//
//  Created by Rajit Dang on 4/10/17.
//  Copyright © 2017 Events-iOS. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    // Fields where the user enters login details
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loginButton.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validateForm() -> Bool {
        if (userTextField.text == "" || passwordTextField.text == "" ) {
            errorMessage.text = "Please enter a valid email and password"
            return false
        }
        return true
    }
    

    @IBAction func onButtonPressed(_ sender: Any) {
        let username = userTextField.text ?? nil
        let password = passwordTextField.text ?? nil
        
        if (validateForm()) {
        FIRAuth.auth()?.signIn(withEmail: username!, password: password!) { (user, error) in
            if let user = user {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                print("Logged in with User ID: " + (user.uid))
            }
            if let error = error {
                print(error.localizedDescription)
            }
        }
        }

        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
