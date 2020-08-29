//
//  ChatViewController.swift
//  World Street
//
//  Created by 罗帅卿 on 6/4/20.
//  Copyright © 2020 Shuaiqing Luo. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    let sender: User? = nil
    let receiver: User? = nil
    
    var otherUserUid: String = ""
    
    var otherUserPhoto: UIImage? = nil
    var curUserPhoto: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
//      register messagecell
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")

//      show the navigation bar
        navigationController?.setNavigationBarHidden(false, animated: false)

        
        loadMessages()
        
        download_profile_image(user: "current")
        download_profile_image(user: "other")
        
    }
    
    func download_profile_image(user: String) {
        var userId = Auth.auth().currentUser!.uid
        if user == "other" {
            userId = self.otherUserUid
        }
        let storagePath = "profile_images/\(userId)"
        let imageStorageRef = Storage.storage().reference(withPath: storagePath)
        imageStorageRef.getData(maxSize: Constants.ImageSettings.maxImageDownloadSize, completion: { (data, error) in
            if let error = error {
                print("Error in dowloading file from path: " + storagePath)
                print(error)
            } else {
                if let image = UIImage(data: data!) {
                    if user == "other" {
                        self.otherUserPhoto = image
                    } else{
                        self.curUserPhoto = image
                    }
                    self.tableView.reloadData()
                    print("downloaded user image")
                }
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func backBarButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        if let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email {
            if !messageBody.trimmingCharacters(in: .whitespaces).isEmpty {
                if self.otherUserUid != nil && Auth.auth().currentUser?.uid != nil {
                    var user1 = self.otherUserUid
                    var user2 = Auth.auth().currentUser!.uid
                    if user1.lexicographicallyPrecedes(user2) {
                        let tmp = user1
                        user1 = user2
                        user2 = tmp
                    }
                    db.collection("chatrooms")
                    .document(user1 + "-" + user2)
                    .collection("messages")
                    .addDocument(data: [
                        "sender": messageSender,
                        "body": messageBody,
                        "timestamp": Date().timeIntervalSince1970
                    ]) { (error) in
                        if let e = error {
                            print("There was an issue saviing data to firestore: \(e)")
                        }
                        else {
                            print("Successfully saved data.")
                            DispatchQueue.main.async {
                                self.messageTextField.text = ""
                            }
                        }
                    }
                }

            }
        }
    }
    
    func loadMessages() {
//        db.collection("messages")
//            .order(by: "timestamp")
//            .addSnapshotListener { (querySnapshot, error) in
//            if let e = error {
//                print("There was an issue retrieving data from Firestore. \(e)")
//            }
//            else {
//                if let snapshotDocuments = querySnapshot?.documents {
//                    self.messages = []
//                    for doc in snapshotDocuments {
//                        let data = doc.data()
//                        if let messaegeSender = data["sender"] as? String, let messageBody = data["body"] as? String {
//                            let newMessage = Message(sender: messaegeSender, body: messageBody)
//                            self.messages.append(newMessage)
//
//                            DispatchQueue.main.async {
//                                self.tableView.reloadData()
//
//                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
//                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
//                            }
//
//                        }
//                    }
//                }
//            }
//        }

        if self.otherUserUid != nil && Auth.auth().currentUser?.uid != nil {
            var user1 = self.otherUserUid
            var user2 = Auth.auth().currentUser!.uid
            if user1.lexicographicallyPrecedes(user2) {
                let tmp = user1
                user1 = user2
                user2 = tmp
            }
            db.collection("chatrooms")
            .document(user1 + "-" + user2)
            .collection("messages")
            .order(by: "timestamp")
                .addSnapshotListener { (querySnapshot, error) in
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                }
                else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        self.messages = []
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let messaegeSender = data["sender"] as? String, let messageBody = data["body"] as? String {
                                let newMessage = Message(sender: messaegeSender, body: messageBody)
                                self.messages.append(newMessage)
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    
                                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                }
                                
                            }
                        }
                    }

                }
            }
        }
    }
    
}

// for displaying data in the table
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell
        
        cell.label.text = messages[indexPath.row].body
        
    
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.rightImageView.image = self.curUserPhoto
            
//          todo: load current user's image here
        }
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.leftImageView.image = self.otherUserPhoto
            
//          todo: load the other user's image here
        }
        

        return cell
    }
    
    
}

// for interaction with the user
extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

