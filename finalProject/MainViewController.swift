//
//  ViewController.swift
//  finalProject
//
//  Created by Jack Standefer on 4/6/22.
//

// TODO: GENERAL:
// connect to firebase, add saving/loading data functions
// add login view controller
// figure out comments, likes, etc.

// TODO: FIREBASE:
// set up following system
// add saving/loading data functions

// TODO: LOCATION:
// set up location use alerts, getting location, etc.
// only show posts from followed people, users in 10mi? radius

// TODO: ABOUT:
// add this link in a button that says "How Google uses data when you use our partners' sites or apps": www.google.com/policies/privacy/partners/

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var posts: [Post] = []
    var cellHeight: CGFloat = 125
    var currentUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        posts.append(Post(author: User(username: "test poster"), text: "short text"))
        posts.append(Post(author: User(username: "test poster"), text: "longer text that i'm hoping spans two lines"))
        posts.append(Post(author: User(username: "test poster"), text: "even longer text that should really span three or more lines but if it doesn't that's not a big deal"))
        posts.append(Post(author: User(username: "test poster"), text: "tesljasldfjas;ldfjalskdjf;lasjdfalskdfja;lsdfj"))
        posts.append(Post(author: User(username: "test poster"), text: "tesljasldfjas;ldfjalskdjf;lasjdfalskdfja;lsdfj"))
        posts.append(Post(author: User(username: "test poster"), text: "tesljasldfjas;ldfjalskdjf;lasjdfalskdfja;lsdfj"))
        posts.append(Post(author: User(username: "test poster"), text: "tesljasldfjas;ldfjalskdjf;lasjdfalskdfja;lsdfj"))
        posts.append(Post(author: User(username: "test poster"), text: "tesljasldfjas;ldfjalskdjf;lasjdfalskdfja;lsdfj"))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! PostViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.post = posts[selectedIndexPath.row]
        } else if segue.identifier == "AddPost" {
            let destination = segue.destination as! NewPostViewController
            destination.user = currentUser
        } else if segue.identifier == "ShowProfile" {
            let navVC = segue.destination as! UINavigationController
            let destination = navVC.viewControllers.first as! ProfileViewController
            destination.user = currentUser
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.usernameLabel.text = posts[indexPath.row].author.username
        cell.postTextLabel.text = posts[indexPath.row].text
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}
