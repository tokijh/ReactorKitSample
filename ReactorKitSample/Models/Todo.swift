//
//  Todo.swift
//  ReactorKitSample
//
//  Created by 윤중현 on 2018. 9. 28..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import Then

class Todo: Codable, Then {
    var userId: Int = 0
    var title: String = ""
    var id: Int = 0
    var isCompleted: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case userId
        case title
        case id
        case isCompleted = "completed"
    }
}
