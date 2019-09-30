//
//  MainAppViewController.swift
//  NTWRK
//
//  Created by David Yashgur on 9/21/19.
//  Copyright © 2019 David Yashgur. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class MainAppViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    
    var video = AVCaptureVideoPreviewLayer()
    
    let defaultValues = UserDefaults.standard
   
    @IBOutlet weak var lblMainApp: UILabel!
    
    @IBAction func buttonLogout(_ sender: Any) {
        
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()

        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
    self.navigationController?.pushViewController(loginViewController, animated: true)
        self.dismiss(animated: false, completion: nil)
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
        
        let session = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { print("Error, device not found")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        } catch {
            print("ERROR")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        session.startRunning()
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        let defaultValues = UserDefaults.standard

        // Do any additional setup after loading the view.
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
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects != nil && metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                let URL_USER_ADD_FRIEND = "https://ec2-3-83-143-79.compute-1.amazonaws.com/v0/addFriend.php"
                
                let parameters: Parameters=[
                    "new_friend":object.stringValue!,
                    "sender":defaultValues.string(forKey: "useremail")!
                ]
                
                var responseMessage: String = ""
                
                AF.request(URL_USER_ADD_FRIEND, method: .post, parameters: parameters).responseJSON{
                response in
                    
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        responseMessage = JSON["message"] as! String
                        }
                case .failure(let error):
                    // error handling
                    if let JSON = error as? [String: Any] {
                        responseMessage = JSON["error"] as! String
                        }
                    }
                }
                
                let alert = UIAlertController(title: "QR Code", message: responseMessage, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ratake", style: .default, handler:nil))
                
                present(alert, animated: true, completion: nil)
            }
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
