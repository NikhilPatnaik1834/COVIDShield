//
//  RedSubmit.swift
//  Map
//
//  Created by Nikhil Patnaik on 29/04/2020.
//  Copyright © 2020 Nikhil Patnaik. All rights reserved.
//

// The purpose of the code below is to send the userID and the Dot color to the MapScreenViewController

import UIKit
import FirebaseDatabase
import FirebaseAuth

class RedSubmit: UIViewController {

    var reddot = "reddot"
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
        }
    }
    
    
    @IBAction func redbutton(_ sender: Any) {
        performSegue(withIdentifier: "reddata", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MapScreenViewController
        vc.dot = ""
        vc.mapUserID = ""
        vc.dot = reddot
        vc.mapUserID = userID
    }
}
