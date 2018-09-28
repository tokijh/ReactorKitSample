//
//  MainViewReactor.swift
//  ReactorKitSample
//
//  Created by 윤중현 on 2018. 9. 27..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import ReactorKit
import RxSwift

class MainViewReactor: Reactor {
    
    enum Action {
        case refresh
        case selectSample(MainSampleSection.Value)
    }
    
    enum Mutation {
        case setRefreshing(Bool)
        case setLoading(Bool)
        case setSamples([Sample], nextSample: Sample?)
        case selectSample(MainSampleSection.Value)
    }
    
    struct State {
        var isRefreshing: Bool = false
        var isLoading: Bool = false
        var nextSample: Sample?
        var sections: [MainSampleSection] = []
        var pushingVC: UIViewController?
    }
    
    let initialState = State()
    
    // MARK Service
    let sampleService: SampleServiceType
    
    init(sampleService: SampleServiceType) {
        self.sampleService = sampleService
    }
    
    func mutate(action: MainViewReactor.Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            guard !self.currentState.isRefreshing,
                !self.currentState.isLoading
                else { return .empty() }
            let startRefreshing = Observable<Mutation>.just(.setRefreshing(true))
            let endRefreshing = Observable<Mutation>.just(.setRefreshing(false))
            let setSamples = sampleService.samples(paging: .refresh).asObservable()
                .map({ list -> Mutation in
                    return .setSamples(list, nextSample: list.last)
                })
            return .concat([startRefreshing, setSamples, endRefreshing])
        case let .selectSample(section):
            return Observable.just(.selectSample(section))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setRefreshing(isRefreshing):
            let isEmpty = state.sections.first?.items.isEmpty == true
            state.isRefreshing = isRefreshing && !isEmpty
            return state
        case let .setLoading(isLoading):
            state.isLoading = isLoading
            return state
        case let .setSamples(samples, nextSample: nextSample):
            let sampleTitleRows = samples
                .map({ SampleTitleCellReactor(sample: $0) })
                .map({ MainSampleSection.Value.sampleTitle($0) })
            state.sections = [.samples(sampleTitleRows)]
            state.nextSample = nextSample
            return state
        case let .selectSample(section):
            switch section {
            case let .sampleTitle(reactor):
                state.pushingVC = SampleTodoListViewController(reactor: SampleTodoListViewReactor(service: JSONPlaceholderService()))
            }
            return state
        }
    }
}
