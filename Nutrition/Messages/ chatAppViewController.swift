//
//  chatAppViewController.swift
//  Nutrition
//
//  Created by Yumel Hernandez on 3/20/19.
//  Copyright © 2019 Yumel Hernandez. All rights reserved.
//

import UIKit
import MessageKit
import Firebase
import FirebaseFirestore
import MessageInputBar
import Photos


class chatAppViewController: MessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    


    
   
    var messages: [Message] = []
    var member: Member!
    var imagen: Image!
    var hella: todos!
   // let db = Firestore.firestore()
    
    let someImageView: UIImageView = {
        let theImageView = UIImageView()
        theImageView.translatesAutoresizingMaskIntoConstraints = false //You need to call this property so the image is added to your view
        theImageView.layer.masksToBounds = true
        return theImageView
    }()
  

    
    struct myVariables {
        static var ref: DatabaseReference!
    }
    
    var messageRef = Database.database().reference().child("messages")
    let storage = Storage.storage()
    var userMessageRef = Database.database().reference().child("user-messages")
    let currentUser = Auth.auth().currentUser?.uid
    var nutritionistInfo : [String] = []
    var myselfID : [String] = []
    var nutritionist : String?
    var nutritionistName: String?
    var uid: String?
    var name: String?
    var urlLast: URL?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       // self.navigationController?.navigationBar.barTintColor = .white
    
     
       // self.navigationController?.navigationBar.topItem?.title = "hello"
        
       
        
        member = Member(name: "", color: .orange, id: currentUser ?? "uhh")
        //member = Member(name: name ??"", color: .orange, id: currentUser ?? "uhh")
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        
        //observeMessages()
        observeMess()
        nutritionistFetching()
        userKey()
        nutritionistNameFetching ()
        setUpNavBar()
        
        
        
        let cameraItem = InputBarButtonItem(type: .system)
        cameraItem.tintColor = .black
        //cameraItem.title = "+"
        cameraItem.image = #imageLiteral(resourceName: "camera")
        
        
        // 2
        cameraItem.addTarget(
            self,
            action: #selector(cameraButtonPressed),
            for: .primaryActionTriggered
        )
        cameraItem.setSize(CGSize(width: 60, height: 30), animated: false)
        
        // 3
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
       
        

        

        
        
        ///------------
        //self.messagesCollectionView.reloadData()
        //self.messagesCollectionView.scrollToBottom(animated: true) //
        
        

    }
    
    


    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func observeMess () {
        
        
        if let email = Auth.auth().currentUser?.email {
            Database.database().reference().child("users").queryOrdered(byChild: "email").queryEqual(toValue: email).observe( .childAdded) { (snapshot) in
                
                
                
                if let dictionary  = snapshot.value as? [String: AnyObject] {
                    
                    let testing = dictionary["Nutritionist"] as? String
                    //                    print("lololo")
                    //                    print(testing!)
                    
                    
                    guard let currentId = Auth.auth().currentUser?.uid else {return}
 
                    // print(currentId)
                    //guard let partnerId = self.nutritionist else {return}
                    //print(partnerId)
                    //userMessageRef.child(currentId).observe(.childAdded) { (snapshot) in
                    self.userMessageRef.child(currentId).child(testing!).observe(.childAdded) { (snapshot) in
                        
                        let messageKey = snapshot.key
                        print("cacacaca")
                        print(messageKey)
                        self.fetchMessages(messageId: messageKey)
                        
                        
                       
                        
                        
                    }
                }
            }
            
        }
        
    
        
    }

    

    @objc func cameraButtonPressed() {
        
                    messageInputBar.isHidden = true
                    let picker = UIImagePickerController()
                    picker.delegate = self
                    picker.allowsEditing = true
                    picker.sourceType = .photoLibrary
                    self.present(picker, animated: true, completion: nil)
        
    }
    

        
   @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?

        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
        uploadToFireBaseStorageUsingImage(image: selectedImage)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadToFireBaseStorageUsingImage(image: UIImage) {
        let imageName = UUID().uuidString
       let ref = Storage.storage().reference().child("messages_images").child(imageName)
        
        if let uploadData = image.jpegData(compressionQuality: 0.2) {
            ref.putData(uploadData, metadata: nil) { (metadata, error) in
                
                if error != nil {
                    print("Failed to upload image:", error)
                    return
                }
                //print(metadata?.dow)
                ref.downloadURL(completion: { (url, error) in
                    if let urlFinal = url {

                        
                        print(urlFinal.absoluteString)
                        self.sendMessageWithImageUrl(imageUrl: urlFinal.absoluteString)
                        
                        
//                        // testing
//
//                        self.messagesCollectionView.reloadData()
//                        self.messagesCollectionView.scrollToBottom(animated: true)
//
//                        // end
                        
                    }
                })
            }
        }
       
    }
    
    ///
    
    
    func sendMessageWithImageUrl(imageUrl: String) {
        
        
        let newMessage = Message(
            member: member,
            text: imageUrl,
            messageId: UUID().uuidString, Nutritionista: self.nutritionist ?? "No Nutritionist", imagen: nil)
        
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        //currentID = currentUser for us
        //user  = Nutritionist for us (toID)
        
        if let uid =  Auth.auth().currentUser?.uid {
            
            let messageData = ["name": newMessage.member.name, "text": imageUrl,
                               "messageId": newMessage.messageId,  "currentUser": uid,
                               "Nutritionist": newMessage.Nutritionista,
                               "Date": creationDate] as [String : Any]
            
            let messaNew = messageRef.childByAutoId()
            messaNew.updateChildValues(messageData)
            
            userMessageRef.child(uid).child(self.nutritionist ?? "88888").updateChildValues([messaNew.key! : 1])
            userMessageRef.child(self.nutritionist ?? "No nutritionist").child(uid).updateChildValues([messaNew.key! : 1])
            
            //            user_message_ref.child("\(self.myselfID[0])").child(self.nutritionistInfo["Nutritionist"] ?? "no nutritionist").updateChildValues([messaNew.key:1])
            //            user_message_ref.child(self.nutritionistInfo["Nutritionist"] ?? "No Nutritionist").child("\(self.myselfID[0])").updateChildValues([messaNew.key:1])
            
            messageInputBar.isHidden = false
             messageInputBar.inputTextView.text = ""
            
            print("Pressed")
            
            
        }
        
        
    }
    
    
    ///
    func fetchMessages(messageId:String) {
        print(messageId)
        
        messageRef.queryOrderedByKey().queryEqual(toValue: messageId).observe(.childAdded) { (snapshot) in
            
            //})
            //messageRef.child(messageId).observe(.childAdded) { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                let senderName = dictionary["name"] as? String
                let messageId = dictionary["messageId"] as? String
                let texto = dictionary["text"] as? String
                let currentUser = dictionary["currentUser"] as? String
                let nutritionista = dictionary["Nutritionist"] as? String
                
                
                //let image = UIImageView()
               ///guard let url = URL(string: texto!) else {return}
               // self.urlLast = url
                
               // guard let data = try? Data(contentsOf: url) else {return}
                //let hello = UIImage(data: data)
                //self.imagen.image = hello
                
                
                ///
                
                var imageTesting = UIImage()
                
                if texto!.contains("https://firebasestorage.googleapis.com/v0/b/nutrition") {
                    SDWebImageManager.shared().loadImage(
                        with: URL(string: texto!),
                        options: .highPriority,
                        progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                            
                            self.messagesCollectionView.reloadData()
                            self.messagesCollectionView.scrollToBottom(animated: true)
                            
                            if let testingAnything = image {
                                imageTesting = testingAnything
                            }
                    }
                    
                    // return .photo(Image(image: wuari))
                    
                }
                
                ///
                
                self.messages.append(Message(member: Member(name: senderName ?? "not found", color: .orange, id: currentUser ?? "not found"), text: texto ?? "not found", messageId: messageId ?? "Not found", Nutritionista: nutritionista ?? "No Nutritionist", imagen: imageTesting))
                
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToBottom(animated: true)
                
                
                
                
//                self.messagesCollectionView.reloadData()
//                self.messagesCollectionView.scrollToBottom(animated: true)
                
//                 self.messages.append(Message(member: Member(name: senderName ?? "not found", color: .orange, id: currentUser ?? "not found"), text: te xto ?? "not found", messageId: messageId ?? "Not found", Nutritionista: nutritionista ?? "No Nutritionist"))
//
                
                
            }
            
            
        }
        
//        // testing
//
//        self.messagesCollectionView.reloadData()
//        self.messagesCollectionView.scrollToBottom(animated: true)
//
//        // end
    
    }
    
    
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        messageInputBar.isHidden = false
    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
//        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
//
//
//
//        }
//        self.dismiss(animated: true, completion: nil)
//    }
    

    

//    func makeBackButton() -> UIButton {
//        self.navigationController?.navigationBar.barTintColor = .white
//        let backButtonImage = UIImage(named: "backbutton")?.withRenderingMode(.alwaysTemplate)
//        let backButton = UIButton(type: .custom)
//        backButton.setImage(backButtonImage, for: .normal)
//        backButton.tintColor = .blue
//        backButton.setTitle("  Back", for: .normal)
//        backButton.setTitleColor(.blue, for: .normal)
//        backButton.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
//
//
//        return backButton
//    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
        return
    }

    
    func nutritionistFetching () {
        
        if let email = Auth.auth().currentUser?.email {
            Database.database().reference().child("users").queryOrdered(byChild: "email").queryEqual(toValue: email).observe( .childAdded) { (snapshot) in
                
                if let dictionary  = snapshot.value as? [String: AnyObject] {
                    self.nutritionist = dictionary["Nutritionist"] as? String
                    
                    
                    
                }
                
            } }
        
    }
    
    func nutritionistNameFetching () {
        
        Database.database().reference().child("Nutritionist").child(self.nutritionist ?? "888").observeSingleEvent(of: .childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
          
            let name  = dictionary["name"] as? String
            self.nutritionistName = name

          }
        }
        
    }
    
    func setUpNavBar() {
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        self.view.addSubview(navBar)
        navBar.items?.append(UINavigationItem(title: ""))
        let backButton = UIBarButtonItem(title: "Atras", style: .plain, target: self, action: #selector(self.backButtonPressed))
        backButton.tintColor = .orange
        navBar.topItem?.leftBarButtonItem = backButton
        navBar.topItem?.title = self.nutritionistName
        
    }

    
//    func observeMess () {
//
//        if let email = Auth.auth().currentUser?.email {
//            Database.database().reference().child("users").queryOrdered(byChild: "email").queryEqual(toValue: email).observe( .childAdded) { (snapshot) in
//
//                if let dictionary  = snapshot.value as? [String: AnyObject] {
//
//                    let testing = dictionary["Nutritionist"] as? String
////                    print("lololo")
////                    print(testing!)
//
//
//                    guard let currentId = Auth.auth().currentUser?.uid else {return}
//                    // print(currentId)
//                    //guard let partnerId = self.nutritionist else {return}
//                    //print(partnerId)
//                    //userMessageRef.child(currentId).observe(.childAdded) { (snapshot) in
//                    self.userMessageRef.child(currentId).child(testing!).observe(.childAdded) { (snapshot) in
//
//                        let messageKey = snapshot.key
//                        print("cacacaca")
//                        print(messageKey)
//                        self.fetchMessages(messageId: messageKey)
//
//
//                    }
//                }
//            }
//
//        }
//
//
//
//    }
    
    
    //resume.task() 
    
//fetchmessages was here
    
    
    func userKey () {
        
        
        if let email = Auth.auth().currentUser?.email {
            Database.database().reference().child("users").queryOrdered(byChild: "email").queryEqual(toValue: email).observe( .childAdded) { (snapshot) in
                
                self.myselfID.append(snapshot.key)
                
            } }
        
    }
    
    
    ///------------------------
    
    
    
    
    

  ///----------------------------
}



extension chatAppViewController: MessagesDataSource {
    func numberOfSections(
        in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func currentSender() -> Sender {
        return Sender(id: member.id, displayName: member.name)
        
        //     return Sender(id: member.name, displayName: member.name)
    }
    
    func messageForItem(
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
    }
    
    func messageTopLabelHeight(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 12
    }
    
    func messageTopLabelAttributedText(
        for message: MessageType,
        at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(
            string: message.sender.displayName,
            attributes: [.font: UIFont.systemFont(ofSize: 12)])
    }
}

extension chatAppViewController: MessagesLayoutDelegate {
    func heightForLocation(message: MessageType,
                           at indexPath: IndexPath,
                           with maxWidth: CGFloat,
                           in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 0
    }
}

extension chatAppViewController: MessagesDisplayDelegate {
    func configureAvatarView(
        _ avatarView: AvatarView,
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) {
        
        let message = messages[indexPath.section]
        let color = message.member.color
        avatarView.backgroundColor = color
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath,
                         in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        // 1
        return isFromCurrentSender(message: message) ? .black : .orange
    }
    
    
//    func configureMediaMessageImageView(_ imageView: UIImageView,
//                                        for message: MessageType,
//                                        at indexPath: IndexPath,
//                                        in messagesCollectionView: MessagesCollectionView) {
//
//        guard let url: URL = URL(string: "https://firebasestorage.googleapis.com/v0/b/nutrition-d9b58.appspot.com/o/messages_images%2F9EB249A0-323E-471A-88CA-01FFED7EF560?alt=media&token=9341d81a-282e-4601-b132-523de822ff98") else {return}
//        imageView.load(url: urlLast ?? url)
//    }
    
}





extension chatAppViewController : MessageInputBarDelegate {
    
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        
        let newMessage = Message(
            member: member,
            text: text,
            messageId: UUID().uuidString, Nutritionista: self.nutritionist ?? "No Nutritionist", imagen: nil)
        
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        //currentID = currentUser for us
        //user  = Nutritionist for us (toID)
        
        if let uid =  Auth.auth().currentUser?.uid {
            
            let messageData = ["name": newMessage.member.name, "text": newMessage.text,
                               "messageId": newMessage.messageId,  "currentUser": uid,
                               "Nutritionist": newMessage.Nutritionista,
                               "Date": creationDate] as [String : Any]
            
            let messaNew = messageRef.childByAutoId()
            messaNew.updateChildValues(messageData)
            
            userMessageRef.child(uid).child(self.nutritionist ?? "88888").updateChildValues([messaNew.key! : 1])
            userMessageRef.child(self.nutritionist ?? "No nutritionist").child(uid).updateChildValues([messaNew.key! : 1])
            
            //            user_message_ref.child("\(self.myselfID[0])").child(self.nutritionistInfo["Nutritionist"] ?? "no nutritionist").updateChildValues([messaNew.key:1])
            //            user_message_ref.child(self.nutritionistInfo["Nutritionist"] ?? "No Nutritionist").child("\(self.myselfID[0])").updateChildValues([messaNew.key:1])
            
         
            
            print("Pressed")
            inputBar.inputTextView.text = ""
            
            

            
        }
        
        
    }
}


//extension UIImageView {
//    func load(url: URL) {
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//}



//ordered by time


//    func observeMessages () {
//        messageRef.observe(.childAdded) { (snapshot) in
//
//
//
//            if let dictionary = snapshot.value as? [String: Any] {
//             let senderName = dictionary["name"] as? String
//             let messageId = dictionary["messageId"] as? String
//             let texto = dictionary["text"] as? String
//            let currentUser = dictionary["currentUser"] as? String
//            let nutritionista = dictionary["Nutritionist"] as? String
//
//                self.messages.append(Message(member: Member(name: senderName ?? "not found", color: .orange, id: currentUser ?? "not found"), text: texto ?? "not found", messageId: messageId ?? "Not found", Nutritionista: nutritionista ?? "No Nutritionist"))
//
//                self.messagesCollectionView.reloadData()
//                self.messagesCollectionView.scrollToBottom(animated: true) //
//
//
//            }
//        }
//
//
//    }   //


//        messages.append(newMessage)
//
//        inputBar.inputTextView.text = " "
//
//        messagesCollectionView.reloadData()
//        messagesCollectionView.scrollToBottom(animated: true) //



//private func save(_ message: Message) {
//    reference?.addDocument(data: message) { error in
//        if let e = error {
//            print("Error sending message: \(e.localizedDescription)")
//            return
//        }
//
//        self.messagesCollectionView.scrollToBottom()
//    }
//}


//func fetchMessages(messageId:String) {
//    print(messageId)
//
//    messageRef.queryOrderedByKey().queryEqual(toValue: messageId).observe(.childAdded) { (snapshot) in
//
//        //})
//        //messageRef.child(messageId).observe(.childAdded) { (snapshot) in
//
//        if let dictionary = snapshot.value as? [String: Any] {
//            let senderName = dictionary["name"] as? String
//            let messageId = dictionary["messageId"] as? String
//            let texto = dictionary["text"] as? String
//            let currentUser = dictionary["currentUser"] as? String
//            let nutritionista = dictionary["Nutritionist"] as? String
//
//
//
//            self.messages.append(Message(member: Member(name: senderName ?? "not found", color: .orange, id: currentUser ?? "not found"), text: texto ?? "not found", messageId: messageId ?? "Not found", Nutritionista: nutritionista ?? "No Nutritionist"))
//
//
//
//            self.messagesCollectionView.reloadData()
//            self.messagesCollectionView.scrollToBottom(animated: true) //
//        }
//
//
//    }
//}
