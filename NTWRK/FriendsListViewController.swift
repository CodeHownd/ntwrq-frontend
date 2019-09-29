//
//  FriendsListViewController.swift
//  NTWRK
//
//  Created by David Yashgur on 9/23/19.
//  Copyright © 2019 David Yashgur. All rights reserved.
//

import UIKit
import Alamofire

class FriendsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let defaultValues = UserDefaults.standard

    let URL_USER_ALLFRIENDS = "http://ec2-3-83-143-79.compute-1.amazonaws.com/v0/getAllFriends.php"
    
    var friend_array : [String] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return friend_array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = friend_array[indexPath.row]
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
        
        let parameters: Parameters=[
            "email":self.defaultValues.string(forKey: "useremail")!
        ]
        
        AF.request(URL_USER_ALLFRIENDS, method: .post, parameters: parameters).responseJSON{
        response in
            
        switch response.result {
        case .success(let value):
            if let jsonData = value as? NSDictionary {
                let friend_array = jsonData.value(forKey: "friend_array") as! String
                self.friend_array = friend_array.components(separatedBy: ",")
                self.friend_array.removeLast()
                self.tableView.reloadData()
                }
                
        case .failure(let error): break
            // error handling
            
        }
        }
    }
    
    @objc func swipeAction(swipe:UISwipeGestureRecognizer) {
        switch swipe.direction.rawValue {
        case 1:
            performSegue(withIdentifier: "goLeft", sender: self)
        case 2:
            performSegue(withIdentifier: "goRight", sender: self)
        default:
            break
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
