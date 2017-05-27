//
//  SignUpViewController.swift
//  Events
//
//  Created by Sandeep Raghunandhan on 4/10/17.
//  Copyright © 2017 Events-iOS. All rights reserved.
//

import UIKit
import FirebaseAuth
class SignUpViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
    
    @IBOutlet weak var errorMessage: UILabel!
    let auth: FIRAuth = FIRAuth.auth()!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validateForm() -> Bool {
        // Check if names were entered
        if (firstName.text! == "" || lastName.text! == "") {
            errorMessage.text = "Please enter a valid name"
            return false
        }
        // Check if email was entered
        if (email.text == "") {
            errorMessage.text = "Please enter a valid email"
            return false;
        }
        // Check if password fields were entered
        if (password.text == "" ){
            errorMessage.text = "Please enter a valid password"
            return false
        }
        // Check if passwords match
        if (password.text != confirmPass.text) {
            errorMessage.text = "Passwords do not match"
            return false
        }
        
        return true
    }
    
    @IBAction func onSignUpTapped(_ sender: Any) {
        let firstNameText = firstName.text!
        let lastNameText = lastName.text!
        let emailText = email.text!
        let passwordText = password.text!
        
        if (validateForm()) {
        
        auth.createUser(withEmail: emailText, password: passwordText) { (user: FIRUser?, error: Error?) in
            if let error = error{
                self.errorMessage.text = error.localizedDescription
            }
            else {
                if let user = user {
                    let newUser = User(dictionary: ["first_name" : firstNameText,
                                                    "last_name" : lastNameText,
                                                    "email" : emailText,
                                                    "uid" : user.uid])
                    User.addUser(newUser: newUser, callback: { (result: String) in
                        if result == "success" {
                            self.performSegue(withIdentifier: "signupSegue", sender: nil)
                        }
                        else {
                            self.errorMessage.text = result
                        }
                    })
                    
                }
            }
        }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
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
