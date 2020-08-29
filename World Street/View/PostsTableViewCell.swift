//
//  PostsTableViewCell.swift
//  World Street
//
//  Created by 罗帅卿 on 6/5/20.
//  Copyright © 2020 Shuaiqing Luo. All rights reserved.
//

import UIKit
import Firebase

class PostsTableViewCell: UITableViewCell {

    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var leftUserImageView: UIImageView!
    @IBOutlet weak var leftUserNameLabel: UILabel!
    @IBOutlet weak var leftLikeButton: UIButton!
    @IBOutlet weak var leftLikeCntLabel: UILabel!
    
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var rightTitleLabel: UILabel!
    @IBOutlet weak var rightUserImageView: UIImageView!
    @IBOutlet weak var rightLikeButton: UIButton!
    @IBOutlet weak var rightLikeCntLabel: UILabel!
    @IBOutlet weak var rightUserNameLabel: UILabel!
    @IBOutlet weak var rightStackView: UIStackView!
    
    
    
    var leftPost: Post?
    var rightPost: Post?
    
    var delegate: myTableViewControllerDelegate?
    
    let borderWidth = 2
    let borderColor = UIColor.darkGray.cgColor
    let cornerRadius = 8
    
    let databaseRef = Database.database().reference()
    let viewerUid = Auth.auth().currentUser!.uid
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        leftView.layer.borderWidth = CGFloat(borderWidth)
        leftView.layer.borderColor = borderColor
        leftView.layer.cornerRadius = CGFloat(cornerRadius)
        
        rightView.layer.borderWidth = CGFloat(borderWidth)
        rightView.layer.borderColor = borderColor
        rightView.layer.cornerRadius = CGFloat(cornerRadius)
        
        
//      configuring the tap gesture on the image view and title label
        let tapGesture1 = UITapGestureRecognizer(target: self,
                                            action: #selector(leftPostTapped))
        leftImageView.isUserInteractionEnabled = true
        leftImageView.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self,
        action: #selector(leftPostTapped))
        leftTitleLabel.isUserInteractionEnabled = true
        leftTitleLabel.addGestureRecognizer(tapGesture2)
        
        let tapGesture3 = UITapGestureRecognizer(target: self,
                                            action: #selector(rightPostTapped))
        rightImageView.isUserInteractionEnabled = true
        rightImageView.addGestureRecognizer(tapGesture3)

        let tapGesture4 = UITapGestureRecognizer(target: self,
        action: #selector(rightPostTapped))
        rightTitleLabel.isUserInteractionEnabled = true
        rightTitleLabel.addGestureRecognizer(tapGesture4)

    }


    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//  showing the first post image by default
    func setLeftCell(leftPost: Post) {
        self.leftImageView.image = leftPost.postImages[0]
        self.leftTitleLabel.text = leftPost.postTitle
        self.leftUserNameLabel.text = leftPost.postOwner.userName
        self.leftUserImageView.image = leftPost.postOwner.userImage
        self.leftLikeCntLabel.text = "\(leftPost.postLikeCnt)"
        self.leftUserImageView.makeRounded()
        
        if leftPost.liked {
            self.leftLikeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        else {
             self.leftLikeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        self.leftPost = leftPost
    }
    
//  showing the first post image by default
    func setRightCell(rightPost: Post) {
        self.rightImageView.image = rightPost.postImages[0]
        self.rightTitleLabel.text = rightPost.postTitle
        self.rightUserNameLabel.text = rightPost.postOwner.userName
        self.rightUserImageView.image = rightPost.postOwner.userImage
        self.rightLikeCntLabel.text = "\(rightPost.postLikeCnt)"
        self.rightUserImageView.makeRounded()
        
        if rightPost.liked {
            self.rightLikeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        else {
             self.rightLikeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        self.rightPost = rightPost
    }
    
    func hideRightCell() {
        self.rightStackView.isHidden = true
        self.rightView.layer.borderWidth = CGFloat(0)
    }
    
    func showRightCell() {
        self.rightStackView.isHidden = false
        self.rightView.layer.borderWidth = CGFloat(borderWidth)
    }
    
//  go to the specific post when it is tapped
    @objc func leftPostTapped() {
        if self.delegate != nil && leftPost != nil {
            self.delegate?.callSegueFromCell(identifier: "detailedPostSegue", sender: leftPost!)
        }
    }
    
    @objc func rightPostTapped() {
        if self.delegate != nil && rightPost != nil {
            self.delegate?.callSegueFromCell(identifier: "detailedPostSegue", sender: rightPost!)
        }
    }

    @IBAction func leftLikeButtonPressed(_ sender: UIButton) {
        if let post = leftPost {
            if post.liked {
                // Changed to unlike
                self.databaseRef.child("posts/\(post.postId)/liked_by/\(self.viewerUid)").removeValue()
                post.postLikeCnt = post.postLikeCnt - 1
                self.databaseRef.child("post_likes").child(self.viewerUid).child(post.postId).removeValue()
                sender.setImage(UIImage(systemName: "heart"), for: .normal)
                self.leftLikeCntLabel.text = "\(Int(leftLikeCntLabel.text!)! - 1)"
            }
            else {
                // Change to like
                let timestamp_millis = Int64(NSDate().timeIntervalSince1970 * 1000)
                print("ts:", timestamp_millis)
                print("postId:", post.postId)
                print("viewerId:", self.viewerUid)
                self.databaseRef.child("posts/\(post.postId)/liked_by/\(self.viewerUid)").setValue(timestamp_millis)
                self.databaseRef.child("post_likes").child(self.viewerUid).child(post.postId).setValue(timestamp_millis)
                post.postLikeCnt = post.postLikeCnt + 1
                sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                self.leftLikeCntLabel.text = "\(Int(leftLikeCntLabel.text!)! + 1)"
            }
            post.liked = !post.liked
        }
        
    }
    
    @IBAction func rightLikeButtonPressed(_ sender: UIButton) {
        if let post = rightPost {
            if post.liked {
                // Changed to unlike
                self.databaseRef.child("posts/\(post.postId)/liked_by/\(self.viewerUid)").removeValue()
                post.postLikeCnt = post.postLikeCnt - 1
                self.databaseRef.child("post_likes").child(self.viewerUid).child(post.postId).removeValue()
                sender.setImage(UIImage(systemName: "heart"), for: .normal)
                self.rightLikeCntLabel.text = "\(Int(rightLikeCntLabel.text!)! - 1)"
            }
            else {
                // Change to like
                let timestamp_millis = Int64(NSDate().timeIntervalSince1970 * 1000)
                print("ts:", timestamp_millis)
                print("postId:", post.postId)
                print("viewerId:", self.viewerUid)
                self.databaseRef.child("posts/\(post.postId)/liked_by/\(self.viewerUid)").setValue(timestamp_millis)
                self.databaseRef.child("post_likes").child(self.viewerUid).child(post.postId).setValue(timestamp_millis)
                post.postLikeCnt = post.postLikeCnt + 1
                sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                self.rightLikeCntLabel.text = "\(Int(rightLikeCntLabel.text!)! + 1)"
            }
            post.liked = !post.liked
        }
    }

}


protocol myTableViewControllerDelegate {
    func callSegueFromCell(identifier: String, sender: Any)
}
