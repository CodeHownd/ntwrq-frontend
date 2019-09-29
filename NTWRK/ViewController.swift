//
//  ViewController.swift
//  NTWRK
//
//  Created by David Yashgur on 9/19/19.
//  Copyright © 2019 David Yashgur. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    let URL_USER_LOGIN = "http://ec2-3-83-143-79.compute-1.amazonaws.com/v0/login.php"
    
    let defaultValues = UserDefaults.standard

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblValidationMessage: UILabel!

    
    @IBAction func loginUser(_ sender: Any) {

        let parameters: Parameters=[
            "email":txtEmail.text!,
            "password":txtPassword.text!
        ]
        
             
        AF.request(URL_USER_LOGIN, method: .post, parameters: parameters).responseJSON{
            response in
            print(response)
            
            switch response.result {
            case .success(let value):
                if let jsonData = value as? NSDictionary {
                    if(!(jsonData.value(forKey: "error") as! Bool)){
                        
                        let user = jsonData.value(forKey: "user") as! NSDictionary
                        
                        let userEmail = user.value(forKey: "email") as! String
                        let userName = user.value(forKey: "name") as! String
                        
                        self.defaultValues.set(userEmail, forKey: "useremail")
                        self.defaultValues.set(userName, forKey: "username")
                        
                        self.defaultValues.synchronize()
                        
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        guard let mainAppViewController = storyBoard.instantiateViewController(withIdentifier: "MainAppViewController") as? MainAppViewController else {
                            fatalError("Failed to load MainAppViewController from storyboard.")
                        }
                        self.navigationController?.pushViewController(mainAppViewController, animated: true)
                        
                        self.dismiss(animated: false, completion: nil)
                        
                        
                    }else{
                        self.lblValidationMessage.text = "Invalid Email or Password"
                    }
                }
            case .failure(let error): break
                // error handling
            }
        }
        return
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtPassword.returnKeyType = UIReturnKeyType.done
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        if defaultValues.string(forKey: "useremail") != nil {
            if #available(iOS 13.0, *) {
                let mainAppViewController = self.storyboard?.instantiateViewController(identifier: "MainAppViewController", creator: nil) as! MainAppViewController
                self.navigationController?.pushViewController(mainAppViewController, animated: true)
            } else {
                // Fallback on earlier versions
            }
            
        }
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


}
