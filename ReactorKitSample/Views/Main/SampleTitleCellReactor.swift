//
//  SampleTitleCellReactor.swift
//  ReactorKitSample
//
//  Created by 윤중현 on 2018. 9. 27..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import ReactorKit

class SampleTitleCellReactor: TitleCellReactor {
    var sample: Sample
    init(sample: Sample) {
        self.sample = sample
        super.init()
        initialState = State(title: sample.title)
    }
}
