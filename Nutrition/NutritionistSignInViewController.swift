//
//  NutritionistSignInViewController.swift
//  Nutrition
//
//  Created by Yumel Hernandez on 3/17/19.
//  Copyright © 2019 Yumel Hernandez. All rights reserved.
//

import UIKit
import Firebase

class NutritionistSignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        password.delegate = self

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false;
    }
    
    @IBAction func signIn(_ sender: Any) {
        if email.text == "" || password.text == "" {
            displayAlert(title: "Missing Information", message: "You must provide both an email and a password")
        } else {
            if let email = email.text {
                if let password = password.text {
                    Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                        if error != nil {
                            self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
                        } else {
                        
                            ///
                            if let email = Auth.auth().currentUser?.email {
                                Database.database().reference().child("Nutritionist").queryOrdered(byChild: "email").queryEqual(toValue: email).observe( .childAdded) { (snapshot) in
                                    
                                   

//                                    if let userValues = snapshot.value as? [String:Any] {
//
//
//                                        if let test = userValues["access"] {
//                                            if let test2 = test as? Int64 {
//
//                                            if test2 == 1  {
//                                                self.displayAlert(title: "Congrats", message: "You made it")
//                                            } else {
//                                                self.displayAlert(title: "Error", message: "No tienes acceso")
//                                            }
//                                        }
//                                        }
//
//
//                                    }

                                    //self.displayAlert(title: "Congrats", message: "You made it")
                                    let NutritionistChatController = NutriChatViewController()
                                    self.navigationController?.pushViewController(NutritionistChatController, animated: true)


                                }
                            }
                            ///
                            
                            
                        }
                    }
                    
                } } }
    }
    
    func displayAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
