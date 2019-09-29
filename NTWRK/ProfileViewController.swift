//
//  ProfileViewController.swift
//  NTWRK
//
//  Created by David Yashgur on 9/23/19.
//  Copyright © 2019 David Yashgur. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var ImageView: UIImageView!
    
    let defaultValues = UserDefaults.standard
    
    @IBAction func generateCode(_ sender: Any) {
        if defaultValues.string(forKey: "useremail") != nil {
            let data = defaultValues.string(forKey: "useremail")!.data(using: .ascii, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey:  "inputMessage")
            
            let img = UIImage(ciImage: (filter?.outputImage)!)
            
            ImageView.image = img
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
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
