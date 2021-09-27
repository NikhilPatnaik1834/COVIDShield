//
//  GreenSubmit.swift
//  Map
//
//  Created by Nikhil Patnaik on 29/04/2020.
//  Copyright © 2020 Nikhil Patnaik. All rights reserved.
//

// The purpose of the code below is to send the userID and the Dot color to the MapScreenViewController

import UIKit
import FirebaseDatabase
import FirebaseAuth

class GreenSubmit: UIViewController {

    var greendot = "greendot"
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
    
    
    @IBAction func greenbutton(_ sender: Any) {
        performSegue(withIdentifier: "greendata", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MapScreenViewController
        vc.dot = ""
        vc.mapUserID = ""
        vc.dot = greendot
        vc.mapUserID = userID
    }

}
