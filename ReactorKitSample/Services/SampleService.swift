//
//  SampleService.swift
//  ReactorKitSample
//
//  Created by 윤중현 on 2018. 9. 27..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import RxSwift

protocol SampleServiceType: ServiceType {
    func samples(paging: Paging<Sample>) -> Single<[Sample]>
}

class SampleService: SampleServiceType {
    func samples(paging: Paging<Sample>) -> Single<[Sample]> {
        return Single.just([
            Sample().then { $0.title = "TodoList" },
            Sample().then { $0.title = "CollectionLoadmore" }
        ])
    }
}
