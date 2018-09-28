//
//  Result.swift
//  ReactorKitSample
//
//  Created by 윤중현 on 2018. 9. 28..
//  Copyright © 2018년 tokijh. All rights reserved.
//

enum Result<Element> {
    case success(Element)
    case error(Error)
}
