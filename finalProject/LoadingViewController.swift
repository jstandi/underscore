//
//  LoadingViewController.swift
//  finalProject
//
//  Created by Jack Standefer on 5/1/22.
//

import UIKit
import CoreLocation

class LoadingViewController: UIViewController {
    
    var currentUser: ScoreUser!
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation! {
        didSet {
            performSegue(withIdentifier: "FinishedLoading", sender: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FinishedLoading" {
            let navVC = segue.destination
            let destination = navVC.children.first! as! MainViewController
            destination.currentUser = currentUser
            destination.currentLocation = currentLocation
        }
    }

}

extension LoadingViewController: CLLocationManagerDelegate {
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
