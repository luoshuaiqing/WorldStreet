//
//  Post.swift
//  World Street
//
//  Created by 罗帅卿 on 6/5/20.
//  Copyright © 2020 Shuaiqing Luo. All rights reserved.
//

import UIKit
import GooglePlaces

class Post {
    var postImages: [UIImage]
    let postTitle: String
    var postLikeCnt: Int = 0
    var postDescription: String
    let postOwner: User
    var postCoordinates: CLLocationCoordinate2D
    let postId: String
    var liked: Bool
    
    init(postImages: [UIImage], postTitle: String, postOwner: User, postDescription: String, postLatitude: Double, postLongitude: Double, postId: String = "", likeCount: Int = 0, liked: Bool = false) {
        self.postImages = postImages
        self.postTitle = postTitle
        self.postOwner = postOwner
        self.postDescription = postDescription
        self.postCoordinates = CLLocationCoordinate2D(latitude: postLatitude, longitude: postLongitude)
        self.postId = postId
        self.postLikeCnt = likeCount
        self.liked = liked
    }
}
