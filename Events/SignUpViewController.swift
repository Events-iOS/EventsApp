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
    
    let auth: FIRAuth = FIRAuth.auth()!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onSignUpTapped(_ sender: Any) {
        let firstNameText = firstName.text!
        let lastNameText = lastName.text!
        let emailText = email.text!
        let passwordText = password.text!
        let confirmPassText = confirmPass.text!
        
        auth.createUser(withEmail: emailText, password: passwordText) { (user: FIRUser?, error: Error?) in
            print("created user with uid: " + (user?.uid)!)
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
