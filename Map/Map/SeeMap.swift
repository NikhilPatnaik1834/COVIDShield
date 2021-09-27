//
//  SeeMap.swift
//  Map
//
//  Created by Nikhil Patnaik on 12/06/2020.
//  Copyright © 2020 Nikhil Patnaik. All rights reserved.
//

//Two functions are achieved in this page.
//1. We retrieve the Dot color using the userID to define the latest status of the user.
// This is defined in the status() function
//2. We perform a data transfer between the 'SeeMap' ViewController and the 'MapScreenViewController'.

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SeeMap: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    var checkDotExist = ""
    var ref: DatabaseReference!
    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        anonymousAuth()
    }
    
    func anonymousAuth(){
        let auth = Auth.auth()
        auth.signInAnonymously { (result, err) in
            if let err = err{
                print(err.localizedDescription)
                return
            }
            self.userID = auth.currentUser!.uid
            self.seeMap(userID: self.userID)
        }
    }
    
    func status(colour: String){
        if self.checkDotExist == "reddot"{
            statusLabel.text = "REMINDER: Please turn off mobile data after using COVID SHIELD. Your current status is: Red. You will see yourself as a Blue dot on your device, but others will see you as a Red dot on their devices. If you wish to update your status, please follow the Status Questionnaire."
            self.imageView.image = UIImage(named: "RedDotStatus")
        }else if self.checkDotExist == "yellowdot"{
            statusLabel.text = "REMINDER: Please turn off mobile data after using COVID SHIELD. Your current status is: Yellow. You will see yourself as a Blue dot on your device, but others will see you as a Yellow dot on their devices. If you wish to update your status, please follow the Status Questionnaire."
            self.imageView.image = UIImage(named: "YellowDotStatus")
        }else if self.checkDotExist == "greendot"{
            statusLabel.text = "REMINDER: Please turn off mobile data after using COVID SHIELD. Your current status is: Green. You will see yourself as a Blue dot on your device, but others will see you as a Green dot on their devices. If you wish to update your status, please follow the Status Questionnaire."
            self.imageView.image = UIImage(named: "GreenDotStatus")
        }
    }
    
    
    
    
    func seeMap(userID: String){
        ref.child("Users").child(userID).observe(DataEventType.value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            self.checkDotExist = value?["dot"] as? String ?? ""
            self.status(colour: self.checkDotExist)
          }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    @IBAction func seeMapButtonConfirm(_ sender: Any) {
        performSegue(withIdentifier: "seeMapIdentifier", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MapScreenViewController
        vc.dot = ""
        vc.mapUserID = ""
        vc.dot = checkDotExist
        vc.mapUserID = userID
    }
}
