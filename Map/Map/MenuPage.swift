//
//  MenuPage.swift
//  Map
//
//  Created by Nikhil Patnaik on 12/06/2020.
//  Copyright © 2020 Nikhil Patnaik. All rights reserved.
//

//When the user opens COVIDSHIELD for the first time, they have no data in the database. They need to fill the database by going through the 'Status Questionnaire'. However, they cannot use the 'Proceed To Map' before answering the questions of the status questionnaire, therefore the 'Proceed To Map' button is disabled as a result of querying the database and finding no data associated with the user. If there is a Dot color defined for the user in the database, the 'Proceed To Map' button is enabled.

import UIKit
import FirebaseDatabase
import FirebaseAuth

class MenuPage: UIViewController {

    var checkDotExist = ""
    var ref: DatabaseReference!
    var userID = ""
    @IBOutlet weak var seeMapButton: BaseButton!
    
    
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
    
    func seeMap(userID: String){
        ref.child("Users").child(userID).observe(DataEventType.value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            self.checkDotExist = value?["dot"] as? String ?? ""
            self.enableButton(checkDotExist: self.checkDotExist)
          }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func enableButton(checkDotExist: String){
        if checkDotExist != ""{
            seeMapButton.isEnabled = true
        }else{
            seeMapButton.isEnabled = false
        }
    }
}



