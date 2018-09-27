//
//  SampleTitleCellReactor.swift
//  ReactorKitSample
//
//  Created by 윤중현 on 2018. 9. 27..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import ReactorKit

class SampleTitleCellReactor: Reactor {
    typealias Action = NoAction
    
    struct State {
        var title: String
    }
    
    let initialState: State
    
    init(sample: Sample) {
        initialState = State(title: sample.title)
    }
}
