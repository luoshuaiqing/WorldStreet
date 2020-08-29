//
//  Reply.swift
//  World Street
//
//  Created by 罗帅卿 on 7/18/20.
//  Copyright © 2020 Shuaiqing Luo. All rights reserved.
//

import UIKit

class Reply {
    let fromUser: User
    let content: String
    let timeStamps: String
    let followups: [Reply]?
    let isBaseReply: Bool
    let id: String
    

//  followups == nil <=> isBaseReply == true
    init(fromUser: User, content: String, timeStamps: String, followups: [Reply]? = nil, isBaseReply: Bool, id: String = "") {
        self.fromUser = fromUser
        self.content = content
        self.timeStamps = timeStamps
        self.followups = followups
        self.isBaseReply = isBaseReply
        self.id = id
    }
    
    
}
