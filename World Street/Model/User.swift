//
//  User.swift
//  World Street
//
//  Created by 罗帅卿 on 6/5/20.
//  Copyright © 2020 Shuaiqing Luo. All rights reserved.
//

import UIKit

class User {
    var userName: String
    var userImage: UIImage?
    var userId: String?
    
    init(userName: String, userImage: UIImage? = nil, userId: String? = nil) {
        self.userName = userName
        self.userImage = userImage
        self.userId = userId
    }
}
