//
//  MainLoginViewController.swift
//  finalProject
//
//  Created by Jack Standefer on 4/24/22.
//

import UIKit
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import CoreLocation

class MainLoginViewController: UIViewController {
    
    var authUI: FUIAuth!
    var currentLocation: CLLocation!
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var usernameSignInButton: UIButton!
    @IBOutlet weak var newUserSignInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        getLocation()
        
        usernameSignInButton.isHidden = true
        newUserSignInButton.isHidden = true
        
        authUI = FUIAuth.defaultAuthUI()
        authUI.delegate = self
        
        signIn()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SuccessfulGoogleSignIn" {
            let destination = segue.destination as! LoadingViewController
            guard let currentUser = authUI.auth?.currentUser else {
                print("couldn't get current user")
                return
            }
            if currentLocation != nil {
                destination.currentLocation = currentLocation
            } else {
                print("could not pass location to MainViewController")
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

extension MainLoginViewController: CLLocationManagerDelegate {
    func getLocation() {
//        creating a CLLocationManager will automatically check authorization
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Checking authorization status")
        handleAuthenticationStatus(status: status)
    }
    
    func handleAuthenticationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            self.oneButtonAlert(title: "Location services denied", message: "Parental controls may be restricting location use in this app. ")
        case .denied:
            showAlertToPrivacySettings(title: "User has not authorized location settings", message: "Select settings below to enable location services for this app")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            print("Unknown case of \(status)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last ?? CLLocation()
        print("Current location is \(currentLocation.coordinate.latitude), \(currentLocation.coordinate.longitude)")
        }
    
    func showAlertToPrivacySettings(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            print("Something went wrong getting the UIApplication.openSettingsURLString")
            return
        }
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR: \(error.localizedDescription). Failed to get device location")
    }
}
