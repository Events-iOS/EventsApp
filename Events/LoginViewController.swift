//
//  LoginViewController.swift
//  Events
//
//  Created by Rajit Dang on 4/10/17.
//  Copyright © 2017 Events-iOS. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    // Fields where the user enters login details
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onButtonPressed(_ sender: Any) {
        let username = userTextField.text ?? nil
        let password = passwordTextField.text ?? nil
        
        
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
