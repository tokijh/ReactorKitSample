//
//  TodoSection.swift
//  ReactorKitSample
//
//  Created by 윤중현 on 2018. 9. 28..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import RxDataSources

enum TodoSection {
    case todos([Value])
}

extension TodoSection: SectionModelType {
    init(original: TodoSection, items: [Value]) {
        switch original {
        case .todos: self = .todos(items)
        }
    }
    
    var items: [Value] {
        switch self {
        case let .todos(values): return values
        }
    }
    
    enum Value {
        case todoTitle(TodoTitleCellReactor)
    }
}
