//
//  HomePage.swift
//  Map
//
//  Created by Nikhil Patnaik on 25/04/2020.
//  Copyright © 2020 Nikhil Patnaik. All rights reserved.
//

//Home page is the only ViewController where the Nav Bar is hidden. The code below achieves this feature.

import UIKit

class HomePage: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }


}
