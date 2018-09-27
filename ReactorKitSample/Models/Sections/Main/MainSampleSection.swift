//
//  MainSampleSection.swift
//  ReactorKitSample
//
//  Created by 윤중현 on 2018. 9. 27..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import RxDataSources

enum MainSampleSection {
    case samples([Value])
}

extension MainSampleSection: SectionModelType {
    init(original: MainSampleSection, items: [Value]) {
        switch original {
        case .samples: self = .samples(items)
        }
    }
    
    var items: [Value] {
        switch self {
        case let .samples(values): return values
        }
    }
    
    enum Value {
        case sampleTitle(SampleTitleCellReactor)
    }
}
