//
//  userProfileViewController.swift
//  Nutrition
//
//  Created by Yumel Hernandez on 3/18/19.
//  Copyright © 2019 Yumel Hernandez. All rights reserved.
//

import UIKit
import Firebase


class userProfileViewController: UIViewController {

 //   var contactListArray:[DataSnapshot] = []
    var NutritionistID :[String] = []
    var userID : [String] = []
    var NutritionistDictionary : [String: String] = [:]
    
    
    
    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var height: UILabel!
    
    var postData = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let email = Auth.auth().currentUser?.email {
            Database.database().reference().child("users").queryOrdered(byChild: "email").queryEqual(toValue: email).observe( .childAdded) { (snapshot) in
       
                self.userID.append(snapshot.key)

                
                if let testing = snapshot.value as? [String:Any] {
                    
                    
                    self.name.text = testing["name"]! as? String
                    self.emailLabel.text = testing["email"]! as? String
                   // self.age.text = testing["age"]! as? String
                    self.weight.text = testing["weight"]! as? String
                    self.height.text = testing["height"]! as? String
                  
                    
                }
               
                    
                    
                }
            }
        
        }
    
    


    @IBAction func logOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch let error {
            print(error)
        }
       //try! Auth.auth().signOut()
       //self.dismiss(animated: true, completion: nil)
    }
    

    
    @IBAction func talkToNutritionist(_ sender: Any) {
       
//        Database.database().reference().child("Nutritionist").queryOrdered(byChild: "userNumber").observe(.childAdded) { (snapshot) in
//
//
//               self.NutritionistID.append(snapshot.key)  // adds all the nutritionist ids to an array
//            //  print(self.playingAround[0])        //retreieves the first or the ID of nutritionist with least number of user
//
//           // if let dictionary = snapshot.value as? [String:Any] {
//            //if let email = dictionary["email"] as? String  {
////                    self.playingAround.append(email)
////                    print(self.playingAround[0])
////                    self.age.text = self.playingAround[0]   //the email of the nutritionist with least number of users
//
//                if let emailingDictionary = Auth.auth().currentUser?.email {
//                let userDictionary : [String: String] = [self.userID[0]: emailingDictionary]
//              //  let NutritionistDictionary : [String: String] = ["Nutritionist": self.NutritionistID[0]]
//                  self.NutritionistDictionary = ["Nutritionist": self.NutritionistID[0]]
//
//
//                //let hello = "Nutritionist/\(self.playingAround[0])"
//
//                    Database.database().reference().child("Nutritionist/\(self.NutritionistID[0])/clients/").updateChildValues(userDictionary)
//                    Database.database().reference().child("users/\(self.userID[0])").updateChildValues(self.NutritionistDictionary)
//
//
//                }
//
//            }
        
    } // emil bs
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let vc = segue.destination as? chatAppViewController
//         vc?.nutritionistInfo = self.NutritionistDictionary
//        
//    }
        
 //   }
        
 //   }











//        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
//            print(snapshot)
//        }

//                let post = snapshot.value as? String
//
//                if let actualPost = post {
//
//                self.postData.append(actualPost)
//                print(self.postData)
//
//                }

}





//Database.database().reference().child("Nutritionist").queryOrdered(byChild: "userNumber").observe(.childAdded) { (snapshot) in
//
//
//    self.NutritionistID.append(snapshot.key)  // adds all the nutritionist ids to an array
//    //  print(self.playingAround[0])        //retreieves the first or the ID of nutritionist with least number of user
//
//    // if let dictionary = snapshot.value as? [String:Any] {
//    //if let email = dictionary["email"] as? String  {
//    //                    self.playingAround.append(email)
//    //                    print(self.playingAround[0])
//    //                    self.age.text = self.playingAround[0]   //the email of the nutritionist with least number of users
//
//    if let emailingDictionary = Auth.auth().currentUser?.email {
//        let userDictionary : [String: String] = [self.userID[0]: emailingDictionary]
//        //  let NutritionistDictionary : [String: String] = ["Nutritionist": self.NutritionistID[0]]
//        self.NutritionistDictionary = ["Nutritionist": self.NutritionistID[0]]
//
//
//        //let hello = "Nutritionist/\(self.playingAround[0])"
//
//        Database.database().reference().child("Nutritionist/\(self.NutritionistID[0])/clients/").updateChildValues(userDictionary)
//        Database.database().reference().child("users/\(self.userID[0])").updateChildValues(self.NutritionistDictionary)
//
//
//    }
//
//}
