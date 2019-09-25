//
//  MessagesCell.swift
//  Nutrition
//
//  Created by Yumel Hernandez on 3/30/19.
//  Copyright © 2019 Yumel Hernandez. All rights reserved.
//

import UIKit

class MessagesCell: UITableViewCell {

    var user: User? {
        
        didSet {
            guard let name = user?.name else {return}
            textLabel?.text = name
        }
    }
 
    
    //Profile image
    let timeStampLabel : UILabel = {
        let label  = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.text = ""
        return label
    }()
    
    let profileImage: UIImage = {

        var image  = UIImage()
        image = UIImage(named: "person")!
        return image
    }()
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
    
        
        let imageview = UIImageView(image: profileImage)
        addSubview(imageview)
        imageview.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom:  0, paddingRight: 10, width: 45, height: 45)
        
        
       // addSubview(timeStampLabel)
        //timeStampLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom:  0, paddingRight: 10, width: 0, height: 0)
        
       // textLabel?.text = "Joker"
        //detailTextLabel?.text = "Testing to see if it works"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
         // how we position our cells text label and detial text label
        
        textLabel?.frame = CGRect(x: 20, y:textLabel!.frame.origin.y - 5, width: 335 /*textLabel!.frame.width + 60*/, height: textLabel!.frame.height + 8)
        textLabel?.backgroundColor = UIColor(hex: "17252A")
        textLabel?.textAlignment = .left
    
    
       // detailTextLabel?.frame = CGRect(x: 68, y:detailTextLabel!.frame.origin.y + 2, width: self.frame.width - 108, height: textLabel!.frame.height)
        
        textLabel?.font = UIFont.boldSystemFont(ofSize: 38)
        textLabel?.textColor = .white
       // detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        //detailTextLabel?.textColor = .lightGray
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
