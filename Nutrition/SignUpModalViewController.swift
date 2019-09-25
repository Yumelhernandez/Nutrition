//
//  SignUpModalViewController.swift
//  Nutrition
//
//  Created by Yumel Hernandez on 3/17/19.
//  Copyright © 2019 Yumel Hernandez. All rights reserved.
//

import UIKit
import Firebase


class SignUpModalViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
  
    
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var birthDate: UITextField!
    @IBOutlet weak var hieght: UITextField!
    @IBOutlet weak var menOrWomen: UISegmentedControl!
    private var datePicker: UIDatePicker?
    
     var pickOption = [["3 Pies", "4 Pies", "5 Pies", "6 Pies", "7 Pies" ], ["0 pulgada","1 pulgada", "2 pulgada", "3 pulgada", "3 pulgada", "4 pulgada", "5 pulgada", "6 pulgada", "7 pulgada", "8 pulgada", "9 pulgada", "10 pulgada", "11 pulgada"]]
    
    
    //
    // var contactListArray:[DataSnapshot] = []
     var NutritionistID :[String] = []
     var userID : [String] = []
     var NutritionistDictionary : [String: String] = [:]
   
    ///
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
     
        returnText()
       
        //birthdate
//        datePicker = UIDatePicker()
//        datePicker?.datePickerMode = .date
//        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
//        birthDate.inputView = datePicker
      
      
       //height
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        hieght.inputView = pickerView
        
        //Adding buttons
//        birthDate.addDoneButtonToKeyboard(myAction: #selector(self.birthDate.resignFirstResponder))
        hieght.addDoneButtonToKeyboard(myAction: #selector(self.hieght.resignFirstResponder))
        weight.addDoneButtonToKeyboard(myAction: #selector(self.weight.resignFirstResponder))
        birthDate.addDoneButtonToKeyboard(myAction: #selector(self.weight.resignFirstResponder))
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return pickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let color = pickOption[0][pickerView.selectedRow(inComponent: 0)]
        let model = pickOption[1][pickerView.selectedRow(inComponent: 1)]
        hieght.text = color + " " + model
    }
    

    
    
    @IBAction func done(_ sender: Any) {
        if name.text == "" || lastName.text == "" || email.text == "" || weight.text == "" || birthDate.text == "" || hieght.text == "" {
            displayAlert(title: "Falta Informacion", message: "Porfavor conteste toda las preguntas")
        } else {
    
            if let email = email.text {
                if let password = password.text {
                    if let name = name.text {
                        if let weight = weight.text {
                            if let birthDate = birthDate.text {
                                if let height = hieght.text {
                                    if let lastName = lastName.text {
                                       
                    
                            
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    if let error = error {   //if user != nil {
                         self.displayAlert(title: "Error:", message: error.localizedDescription)
                  //  self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
                    } else {
                    
                        
                       if let uid =  Auth.auth().currentUser?.uid {
                        
                        let userDictionary : [String: Any] = ["name": name, "lastName": lastName, "email": email, "weight": weight, "birthDate": birthDate, "height": height, "UIID": uid, "acess": false]
                        //Database.database().reference().child("users").childByAutoId().setValue(userDictionary)
                        Database.database().reference().child("users").child(uid).setValue(userDictionary)
                        
                        
                        self.matchingAlgorithm()
                        

                        
                        
                        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let main_viewController = storyboard.instantiateViewController(withIdentifier: "sucess")
                        self.present(main_viewController, animated: true, completion: nil)
                      
                      
                        
                    }
                }
                    
                                        }  } } } } } } }
            
        }
        
        
        
    }
    
    func matchingAlgorithm () {
        
        
        if let email = Auth.auth().currentUser?.email {
            Database.database().reference().child("users").queryOrdered(byChild: "email").queryEqual(toValue: email).observe( .childAdded) { (snapshot) in
                
                self.userID.append(snapshot.key)
                
            }
        
        
        
        Database.database().reference().child("Nutritionist").queryOrdered(byChild: "userNumber").observe(.childAdded) { (snapshot) in
            
            
            self.NutritionistID.append(snapshot.key)  // adds all the nutritionist ids to an array
            
         //   if let uid =  Auth.auth().currentUser?.uid {
            //if let emailingDictionary = Auth.auth().currentUser?.email {
             //   let userDictionary : [String: String] = [self.userID[0]: emailingDictionary]
                let userDictionary : [String: String] = [self.userID[0]: email]
                
                
                //  let NutritionistDictionary : [String: String] = ["Nutritionist": self.NutritionistID[0]]
                self.NutritionistDictionary = ["Nutritionist": self.NutritionistID[0]]
                
                Database.database().reference().child("Nutritionist/\(self.NutritionistID[0])/clients/").updateChildValues(userDictionary)
                Database.database().reference().child("users/\(self.userID[0])").updateChildValues(self.NutritionistDictionary)
                
              //  } //uid
                
            }
            
        }
    }
    
//    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
//        view.endEditing(true)
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let vc = segue.destination as? chatAppViewController
//            vc?.nutritionistInfo = self.NutritionistID
//
//
//        
//    }

    
    
    
   @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        birthDate.text = dateFormatter.string(from: datePicker.date)
    

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    

    @IBAction func dismissPopUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    
    func returnText () {
    
        name.delegate = self
        lastName.delegate = self
        email.delegate = self
        password.delegate = self
        birthDate.delegate = self
        weight.delegate = self
        hieght.delegate = self
        
    
    }


}

extension UITextField {
    
    func addDoneButtonToKeyboard(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Termine", style: UIBarButtonItem.Style.done, target: self, action: myAction)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
}
    





//                        Database.database().reference().child("Nutritionist").queryOrdered(byChild: "userNumber").observe(.childAdded) { (snapshot) in
//
//
//                            self.NutritionistID.append(snapshot.key)  // adds all the nutritionist ids to an array
//
//
//                            if let emailingDictionary = Auth.auth().currentUser?.email {
//                                let userDictionary : [String: String] = [self.userID[0]: emailingDictionary]
//                                //  let NutritionistDictionary : [String: String] = ["Nutritionist": self.NutritionistID[0]]
//                                self.NutritionistDictionary = ["Nutritionist": self.NutritionistID[0]]
//
//                                Database.database().reference().child("Nutritionist/\(self.NutritionistID[0])/clients/").updateChildValues(userDictionary)
//                                Database.database().reference().child("users/\(self.userID[0])").updateChildValues(self.NutritionistDictionary)
//
//                            }
//
//                        }

///--------------------------------------------------------

