//
//  Message.swift
//  Nutrition
//
//  Created by Yumel Hernandez on 3/21/19.
//  Copyright © 2019 Yumel Hernandez. All rights reserved.
//

import Foundation
import UIKit
import MessageKit


struct todos {
    var foto =  UIImage()
    var tata = UIImage()
    var messages = MessagesViewController()
}



struct Member {
    let name: String
    let color: UIColor
    let id: String
}

struct Message {
    let member: Member
    let text: String
    let messageId: String
    let Nutritionista: String
    let imagen: UIImage?
    //let imagen: String
}


struct Image: MediaItem {

    
    var image: UIImage?
    
    var url: URL?
    
    var placeholderImage: UIImage
    
    var size: CGSize
    
    
    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
    
}



//These are just simple models to hold our message data. Instead of avatars,
//each member will have a color assigned to them and displayed next to their message.

extension Message: MessageType {
    
    
    var sender: Sender {
        return Sender(id: member.id, displayName: member.name)
        //return Sender(id: member.name, displayName: member.name)
    }
    
    var sentDate: Date {
        return Date()
    }
    
    var kind: MessageKind {
        
//       let vamosAber = chatAppViewController()
//
//        vamosAber.messagesCollectionView.reloadData()
//        vamosAber.messagesCollectionView.scrollToBottom(animated: true)
    
//        self.messagesCollectionView.reloadData()
//        self.messagesCollectionView.scrollToBottom(animated: true) //
        
     
  
        //----------------------------------------------------------
        
        var wuari = UIImage()

        if text.contains("https://firebasestorage.googleapis.com/v0/b/nutrition") {



            SDWebImageManager.shared().loadImage(
                with: URL(string: text),
                options: .highPriority,
                progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in

                 
                    wuari = image!
            }
            
//            if let image2 = imagen {
//                wuari = image2
//
//            }

    
            return .photo(Image(image: wuari))


        } else {
            return .text(text)
        }
        

    }
    
    //----------------------------------------------------------
    
 //   }
    
}

    


//converting JSON formt to swift friendly format

extension Member {
    var toJSON: Any {
        return [
            "name": name,
            "color": color.hexString,
            "id": id
        ]
    }
    
    init?(fromJSON json: Any) {
        guard
            let data = json as? [String: Any],
            let name = data["name"] as? String,
            let hexColor = data["color"] as? String,
            let id = data["id"] as? String
            else {
                print("Couldn't parse Member")
                return nil
        }
        
        self.name = name
        self.color = UIColor(hex: hexColor)
        self.id = id
    }
}


// below if text.contains("http") {

// var wuari = UIImage()
//
//            func klk(texti: String, completion: @escaping(UIImage?) -> ()) {
//
//                DispatchQueue.main.async {
//                    let url = URL(string: texti)
//                     //let url = URL(string: self.text)
//                    let data = try? Data(contentsOf: url!)
//                  //  let imageLast = UIImage(data: data!)
//
//                    completion(UIImage(data: data!))
//                    //return imageLast
//
//                }
//            }
//
//            klk(texti: text) { (image) in
//                if let imagen = image {
//
//
//                    wuari = imagen as UIImage
//
//
//                } else {
//
//                    print("klkkkkkk cacaca")
//                }
//            }
//            return .photo(Image(image: wuari))
//
//            // return .photo(Image(image: imageLast!))
//
//        } else {
//            return .text(text)
//        }

//  let url = URL(string: text)
// let data = try? Data(contentsOf: url!)
//  let imageLast = UIImage(data: data!)
//   completion(UIImage(data: data!))


//        SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: .continueInBackground, progress: nil, completed: {(image:UIImage?, data:Data?, error:Error?, finished:Bool) in
//                if image != nil {
//
//                    wuari = image!
//
//                }
//            })




//let postImageView: UIImageView = {
//    let theImageView = UIImageView()
//    theImageView.contentMode = .scaleAspectFill
//    theImageView.clipsToBounds = true
//    theImageView.translatesAutoresizingMaskIntoConstraints = false //You need to call this property so the image is added to your view
//    theImageView.layer.masksToBounds = true
//    
//    return theImageView
//}()


//        if text.contains("https://firebasestorage.googleapis.com/v0/b/nutrition") {
//
//
//
//            SDWebImageManager.shared().loadImage(
//                with: URL(string: text),
//                options: .highPriority,
//                progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
//
//                    wuari = image!
//            }
//
//            return .photo(Image(image: wuari))
//
//
//        } else {
//            return .text(text)
//        }
