//
//  ForgetPasswordViewController.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-02.
//

import UIKit

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var txtEmailAddress: UITextField!
    
    var firebaseService=FirebaseService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardHider()
        
    }
    @IBAction func forgetPassword(_ sender: Any) {
        self.firebaseService.forgetPassword(emailAddress:txtEmailAddress.text!)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func addKeyboardHider(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

}
