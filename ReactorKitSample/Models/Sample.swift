//
//  Sample.swift
//  ReactorKitSample
//
//  Created by 윤중현 on 2018. 9. 27..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import Then

class Sample: Then {
    var title: String = ""
}

extension Sample {
    var viewController: UIViewController? {
        switch title {
        case "TodoList": return SampleTodoListViewController(reactor: SampleTodoListViewReactor(service: JSONPlaceholderService()))
        case "CollectionLoadmore": return CollectionLoadmoreViewController(reactor: CollectionLoadmoreViewReactor(service: JSONPlaceholderService()))
        case "Counter": return CounterViewController(reactor: CounterViewReactor())
        default: return nil
        }
    }
}
