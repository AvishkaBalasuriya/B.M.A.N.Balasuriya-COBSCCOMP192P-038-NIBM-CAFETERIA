//
//  ViewController.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-02.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblLogin: UILabel!
    
    var firebaseService=FirebaseService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardHider()
        addTapFunctions()
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        let loginViewController = storyboard?.instantiateViewController(withIdentifier:"LoginView") as? LoginViewController
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationItem.leftBarButtonItem=nil
        self.navigationItem.hidesBackButton=true
        self.navigationController?.pushViewController(loginViewController!, animated: true)
    }
    
    @IBAction func registerButton(_ sender: Any) {
        self.firebaseService.registerUser(emailAddress:txtEmailAddress.text!, mobileNumber: txtMobileNumber.text!, password: txtPassword.text!)
        {(result:Int?)->Void in
            if(result==1){
                self.firebaseService.addUserToFirestore(user: UserModel(emailAddress: self.txtEmailAddress.text!, mobileNumber: self.txtMobileNumber.text!))
                UserData.emailAddress=self.txtEmailAddress.text!
                UserData.mobileNumber=self.txtMobileNumber.text!
                let storePageViewController = self.storyboard?.instantiateViewController(withIdentifier:"StorePageView") as? StorePageViewController
                self.navigationController?.setNavigationBarHidden(true, animated: false)
                self.navigationItem.leftBarButtonItem=nil
                self.navigationItem.hidesBackButton=true
                self.navigationController?.pushViewController(storePageViewController!, animated: true)
            }else if(result==2){
                self.showAlert(title: "Oops!", message: "Email is already registered")
            }else if(result==0){
                self.showAlert(title: "Oops!", message: "An error occures while registering")
            }
        }
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func addKeyboardHider(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func showAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addTapFunctions(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.tapFunction))
        lblLogin.isUserInteractionEnabled = true
        lblLogin.addGestureRecognizer(tap)
    }
    
    func validateInputs(email:String,mobileNumber:String,password:String){
//        if(((email!="" && email!=nil) && (mobileNumber!="" && mobileNumber!=nil) && (password!="" && password!=nil))){
//
//        }else if()
    }
}

