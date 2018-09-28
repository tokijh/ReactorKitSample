//
//  Paging.swift
//  ReactorKitSample
//
//  Created by 윤중현 on 2018. 9. 27..
//  Copyright © 2018년 tokijh. All rights reserved.
//

enum Paging<Element> {
    case refresh
    case next(Element)
}
