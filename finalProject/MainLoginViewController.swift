//
//  MainLoginViewController.swift
//  finalProject
//
//  Created by Jack Standefer on 4/24/22.
//

// issues - crashes on first login
// sort posts by time
// need to add time posted to Post
// crashed when clicking camera from change profile picture

import UIKit
import FirebaseAuthUI
import FirebaseGoogleAuthUI

class MainLoginViewController: UIViewController {
    
    var authUI: FUIAuth!
    @IBOutlet weak var usernameSignInButton: UIButton!
    @IBOutlet weak var newUserSignInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameSignInButton.isHidden = true
        newUserSignInButton.isHidden = true
        
        authUI = FUIAuth.defaultAuthUI()
        authUI.delegate = self
        
        signIn()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SuccessfulGoogleSignIn" {
            let navVC = segue.destination
            let destination = navVC.children.first as! MainViewController
            guard let currentUser = authUI.auth?.currentUser else {
                print("couldn't get current user")
                return
            }
            let user = ScoreUser(user: currentUser)
            destination.currentUser = user
        }
    }
    
    func signIn() {
        // note FUIGoogleAuth line was previously: FUIGoogleAuth(), Google changed to line below in latest update
        let providers: [FUIAuthProvider] = [
          FUIGoogleAuth(authUI: authUI!),
        ]
        if authUI.auth?.currentUser == nil { // user has not signed in
            self.authUI.providers = providers // show providers named after let providers: above
            let loginViewController = authUI.authViewController()
            loginViewController.modalPresentationStyle = .fullScreen
            present(loginViewController, animated: true, completion: nil)
        } else { // user is already logged in
            guard let currentUser = authUI.auth?.currentUser else {
                print("couldn't get current user")
                return
            }
            let user = ScoreUser(user: currentUser)
            user.saveIfNewUser { success in
                if success {
                    self.performSegue(withIdentifier: "SuccessfulGoogleSignIn", sender: nil)
                } else {
                    print("Tried to save a new user but failed")
                }
            }
        }
    }
    
    @IBAction func googleLoginButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "SuccessfulGoogleSignIn", sender: nil)
    }
    
    @IBAction func usernameSignUpButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "UsernameSignIn", sender: nil)
    }
    
    @IBAction func newUserSignUpButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "NewUserSignUp", sender: nil)
    }
}

extension MainLoginViewController: FUIAuthDelegate {
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
//        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
//        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
//            return true
//        }
//        return false
//    }
//    
//    private func authUI(_ authUI: FUIAuth, didSignInWith user: ScoreUser?, error: Error?) {
//        guard error == nil else {
//            print("error during signin")
//            return
//        }
//        if let user = user {
//            print("signed in with user \(user.email ?? "unknown email")")
//        }
//    }
//    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
//        let marginInsets: CGFloat = 16.0 // amount to indent UIImageView on each side
//        let topSafeArea = self.view.safeAreaInsets.top
//
//        // Create an instance of the FirebaseAuth login view controller
//        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
//
//        // Set background color to white
//        loginViewController.view.backgroundColor = UIColor.white
//        loginViewController.view.subviews[0].backgroundColor = UIColor.clear
//        loginViewController.view.subviews[0].subviews[0].backgroundColor = UIColor.clear
//
//        // Create a frame for a UIImageView to hold our logo
//        let x = marginInsets
//        let y = marginInsets + topSafeArea
//        let width = self.view.frame.width - (marginInsets * 2)
//        //        let height = loginViewController.view.subviews[0].frame.height - (topSafeArea) - (marginInsets * 2)
//        let height = UIScreen.main.bounds.height - (topSafeArea) - (marginInsets * 2)
//
//        let logoFrame = CGRect(x: x, y: y, width: width, height: height)
//
//        // Create the UIImageView using the frame created above & add the "logo" image
//        let logoImageView = UIImageView(frame: logoFrame)
//        logoImageView.image = UIImage(named: "logo")
//        logoImageView.contentMode = .scaleAspectFit // Set imageView to Aspect Fit
//        loginViewController.view.addSubview(logoImageView) // Add ImageView to the login controller's main view
//        return loginViewController
//    }
}
