//
//  User.swift
//  Nutrition
//
//  Created by Yumel Hernandez on 3/30/19.
//  Copyright © 2019 Yumel Hernandez. All rights reserved.
//

import Firebase

class User {
    
    var height: String!
    var email: String!
    var weight: String!
    var birthDate: String!
    var name: String!
    var profileImageUrl: String!
    var uid: String!
    var isFollowed = false
    
    init(uid: String, dictionary: Dictionary<String, AnyObject>) {
        
        self.uid = uid
        
        if let height = dictionary["height"] as? String {
            self.height = height
        }
        
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        
        if let weight = dictionary["weight"] as? String {
            self.weight = weight
        }
        
        if let birthDate = dictionary["birthDate"] as? String {
            self.birthDate = birthDate
        }
 }
}
