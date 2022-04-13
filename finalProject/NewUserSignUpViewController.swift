//
//  NewUserSignUpViewController.swift
//  finalProject
//
//  Created by Jack Standefer on 4/12/22.
//

import UIKit

class NewUserSignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var dobDatePicker: UIDatePicker!
    @IBOutlet weak var createAccountButton: UIButton!
    
    var username: String!
    private var password: String!
    var email: String!
    var dateOfBirth: Date!
    var newUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordLabel.isHidden = true
        passwordTextField.isHidden = true
        emailLabel.isHidden = true
        emailTextField.isHidden = true
        dobLabel.isHidden = true
        dobDatePicker.isHidden = true
        createAccountButton.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as? UINavigationController
        let destination = navController?.viewControllers.first as! MainViewController
        destination.currentUser = newUser
    }
    
    @IBAction func dobDatePickerValueChanged(_ sender: UIDatePicker) {
        // TODO: add conditional to ensure username, email not already in database before showing create account button
        dateOfBirth = dobDatePicker.date
        createAccountButton.isHidden = false
    }
    
    @IBAction func usernameTextFieldEditingChanged(_ sender: UITextField) {
        let noSpaces = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if noSpaces != "" {
            passwordLabel.isHidden = false
            passwordTextField.isHidden = false
            emailLabel.isHidden = false
            emailTextField.isHidden = false
            dobLabel.isHidden = false
            dobDatePicker.isHidden = false
            // TODO: make sure username is not already in database
            username = usernameTextField.text!
        }
    }
    
    @IBAction func passwordTextFieldEditingChanged(_ sender: UITextField) {
        let noSpaces = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if noSpaces != "" {
            password = passwordTextField.text!
        }
    }
    
    @IBAction func emailTextFieldEditingChanged(_ sender: UITextField) {
        let noSpaces = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if noSpaces != "" {
            // TODO: use regex and some email verification system to ensure email is valid, not already in database
            email = emailTextField.text!
        }
    }
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        newUser = User(username: username, password: password, email: email, dob: dateOfBirth)
    }
    
    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
