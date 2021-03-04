//
//  ProfileViewController.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-05.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var lblEmailAddress: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserData()
    }
}
