//
//  NewGoogleUserViewController.swift
//  finalProject
//
//  Created by Jack Standefer on 4/25/22.
//

import UIKit
import Firebase

class NewGoogleUserViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var continueButton: UIButton!
    
    var newUser: ScoreUser!
    var username: String!
    var dob: Date!

    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.isHidden = true
        continueButton.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SuccessfulNewGoogleUser" {
            let navVC = segue.destination
            let destination = navVC.children.first as! MainViewController
            destination.currentUser = newUser
        }
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func usernameTextFieldChanged(_ sender: UITextField) {
        let noSpaces = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if noSpaces != "" {
            datePicker.isHidden = false
            username = usernameTextField.text
        }
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        continueButton.isHidden = false
        dob = datePicker.date
    }
    
}
