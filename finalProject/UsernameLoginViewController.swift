//
//  UsernameLoginViewController.swift
//  finalProject
//
//  Created by Jack Standefer on 4/14/22.
//

import UIKit

class UsernameLoginViewController: UIViewController {

    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var username: String!
    private var email: String!
    private var password: String!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInButton.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as? UINavigationController
        let destination = navController?.viewControllers.first as! MainViewController
        destination.currentUser = user
    }
    
    @IBAction func cancelBarButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        // TODO: add conditional to only segue when there is a successful login, find user, send to MainViewController
        performSegue(withIdentifier: "SuccessfulUsernameLogin", sender: nil)
    }
    
    @IBAction func usernameTextFieldEditingChanged(_ sender: UITextField) {
        let noSpaces = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if noSpaces != "" {
            // TODO: use regex to figure out if text is a username or an email
            username = usernameTextField.text!
        }
    }
    
    @IBAction func passwordTextFieldEditingChanged(_ sender: UITextField) {
        let noSpaces = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if noSpaces != "" {
            password = passwordTextField.text!
            logInButton.isEnabled = true
        }
    }
    
}
