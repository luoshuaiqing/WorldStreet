//
//  ChatRoomsTableViewController.swift
//  World Street
//
//  Created by 罗帅卿 on 7/30/20.
//  Copyright © 2020 Shuaiqing Luo. All rights reserved.
//

import UIKit
import Firebase

class ChatRoomsTableViewController: UITableViewController {

    var chatrooms: [User] = []
    let db = Firestore.firestore()
    var databaseRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.databaseRef = Database.database().reference()

        
//      get all messages with the current user as the sender
        db.collection("chatrooms")
            .whereField("users", arrayContains:  Auth.auth().currentUser!.uid)
            .addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            }
            else {
                if let snapshotDocuments = querySnapshot?.documents {
                    self.chatrooms = []
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let userUids = data["users"] as? Array<String> {
                            let otherUser = User(
                                    userName: "placeholder",
                                    userImage: #imageLiteral(resourceName: "placeholder"),
                                    userId: Auth.auth().currentUser!.uid == userUids[0] ? userUids[1] : userUids[0]
                            )
                            
                            self.chatrooms.append(otherUser)
                            self.downloadUserInfo(otherUser)
                        }
                    }
                    
                    
                    self.reloadTableData()
                }
            }
        }
    }
    
    func downloadUserInfo(_ user: User) {
        let userId = user.userId!
//      todo: fetch user photo and user name here and load into user object. reloaddata should be called after both async functions complete
        self.databaseRef.child("users/\(userId)").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let display_name = value?["display_name"] as? String {
                user.userName = display_name
            }
            self.reloadTableData()
        }
        
    }
    
    func reloadTableData() {
        if self.chatrooms.count >= 1 {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                let indexPath = IndexPath(row: self.chatrooms.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.chatrooms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatroomIdentifier", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = self.chatrooms[indexPath.row].userName
        cell.imageView?.image = self.chatrooms[indexPath.row].userImage
        cell.imageView?.makeRounded()
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedChatroom = self.chatrooms[indexPath.row]
        
        self.performSegue(withIdentifier: "chatroomSegue", sender: selectedChatroom.userId!)
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatroomSegue" {
            if let nextViewController = segue.destination as? ChatViewController {
                nextViewController.otherUserUid = sender as! String
            }
        }
    }

}
