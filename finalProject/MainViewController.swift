//
//  ViewController.swift
//  finalProject
//
//  Created by Jack Standefer on 4/6/22.
//

// TODO: GENERAL:
// figure out tap gesture recognizer from author label

import UIKit
import Firebase
import CoreLocation

class MainViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var posts: Posts!
    var currentUser: ScoreUser!
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    var postsInRange: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        posts = Posts()
        tableView.delegate = self
        tableView.dataSource = self
        getLocation()
        
        posts.loadData {
            self.getLocation()
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.estimatedRowHeight = 175
            self.sortByTime()
            if self.currentLocation == nil {
                while self.currentLocation == nil {
                    self.getLocation()
                }
                print(self.currentLocation.coordinate)
                for post in self.posts.postArray {
                    if post.location.distance(from: self.currentLocation) < 16093.4 {
                        self.postsInRange.append(post)
                    }
                }
                self.tableView.reloadData()
            }
            for post in self.posts.postArray {
                if post.location.distance(from: self.currentLocation) < 16093.4 {
                    self.postsInRange.append(post)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! PostViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.post = postsInRange[selectedIndexPath.row]
            destination.currentUser = currentUser
        } else if segue.identifier == "AddPost" {
            let destination = segue.destination as! NewPostViewController
            destination.user = currentUser
        } else if segue.identifier == "ShowProfile" {
            let navVC = segue.destination as! UINavigationController
            let destination = navVC.viewControllers.first as! ProfileViewController
            destination.user = currentUser
            destination.currentUser = currentUser
        }
    }
    
    func sortByTime() {
        posts.postArray.sort(by: {$0.postedDate > $1.postedDate})
        tableView.reloadData()
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsInRange.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.usernameLabel.text = postsInRange[indexPath.row].postingUsername
        cell.postTextLabel.text = postsInRange[indexPath.row].text
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension MainViewController: CLLocationManagerDelegate {
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
