//
//  NutriChatViewController.swift
//  Nutrition
//
//  Created by Yumel Hernandez on 3/30/19.
//  Copyright © 2019 Yumel Hernandez. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "MessagesCell"


class NutriChatViewController: UITableViewController {
    
    var nutritionist : String?
    var users = [User]()
    var patientHere = String()
    var name = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // nutritionistFetching()
        fetchUsers()
        //Register cell
       
        tableView.register(MessagesCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.backgroundColor = UIColor(hex: "17252A")
        self.tableView.separatorColor = .white
       // self.tableView.separatorStyle = 

    }

    
    //MARK - UITableView
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MessagesCell
        cell.user =  users[indexPath.row]
        
       // self.tableView.separatorColor = .black
        
        cell.contentView.backgroundColor = UIColor(hex: "17252A")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // self.dismiss(animated: true) {
        
            let user = self.users[indexPath.row]
            patientHere = user.uid
            name = user.name
        
        
        
            print("yupp yupp")
            print(patientHere)
        
   //    let ChatApp = NutritionistTexting()
//            self.navigationController?.pushViewController(ChatApp, animated: true)
//        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let main_viewController = storyboard.instantiateViewController(withIdentifier: "NutritionistTexting")
//        self.present(main_viewController, animated: true, completion: nil)
        
    //    self.performSegue(withIdentifier: "klk", sender: self)
        
        let chatController = NutritionistTexting()
        chatController.patient = patientHere
        chatController.name = name
        
         navigationController?.pushViewController(chatController, animated: true)
        
        
      //  }
    }
    

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            let vc = segue.destination as! NutritionistTexting
//        
//        if segue.identifier == "klk" {
//            vc.patient = "yaaa"
//        }
//        
//        }
    
    
    
    
    //MARK - NavigationBars
    

    func fetchUsers() {
         guard let currentId = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("Nutritionist/\(currentId)/clients").observe(.childAdded) { (snapshot) in
          let uid = snapshot.key
            if uid != Auth.auth().currentUser?.uid {
                Database.fetchUser(with: uid, completion: { (User) in
                    self.users.append(User)
                    self.tableView.reloadData()
                })
                
                
            }
        }
    }

}




//                Database.database().reference().child("users").child(uid).observeSingleEvent(of: .childAdded) { (snapshot) in
//                    self.users.append(snapshot.key)
//                    guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
//                     let name = dictionary["name"] as? String
//
//                })




//class NutriChatViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//
//}
