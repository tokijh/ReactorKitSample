//
//  TodoTitleCellReactor.swift
//  ReactorKitSample
//
//  Created by 윤중현 on 2018. 9. 28..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import ReactorKit

class TodoTitleCellReactor: TitleCellReactor {
    init(todo: Todo) {
        super.init()
        initialState = State(title: todo.title)
    }
}
