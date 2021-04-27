//
//  ProfileViewController.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-05.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblUsername.text=UserData.emailAddress
        lblMobileNumber.text=UserData.mobileNumber
    }
}
