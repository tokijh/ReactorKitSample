//
//  SampleTodoListViewReactor.swift
//  ReactorKitSample
//
//  Created by 윤중현 on 2018. 9. 28..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import ReactorKit
import RxSwift
import Then

class SampleTodoListViewReactor: Reactor {
    
    enum Action {
        case refresh
//        case loadMore
    }
    
    enum Mutation {
        case setRefreshing(Bool)
        case setLoading(Bool)
        case setTodos([Todo], pagingMeta: PagingMetaType?)
//        case appendTodos([Todo])
    }
    
    struct State: Then {
        var pagingMeta: PagingMetaType?
        var isRefreshing: Bool = false
        var isLoading: Bool = false
        var sections: [TodoSection] = []
    }
    
    let initialState = State.init(pagingMeta: PagingMeta(start: 0, limit: 10), isRefreshing: false, isLoading: false, sections: [])
    
    // MARK Service
    let service: JSONPlaceholderServiceType
    
    init(service: JSONPlaceholderServiceType) {
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            guard !self.currentState.isRefreshing,
                !self.currentState.isLoading,
                let pagingMeta = self.currentState.pagingMeta
                else { return .empty() }
            let startRefreshing = Observable<Mutation>.just(.setRefreshing(true))
            let endRefreshing = Observable<Mutation>.just(.setRefreshing(false))
            let setTodos = service.todos(start: pagingMeta.start, limit: pagingMeta.limit)
                .withLatestFrom(state.map({ $0.pagingMeta }), resultSelector: { (result, pagingMeta) -> ([Todo], PagingMetaType?)? in
                    switch result {
                    case let .success(todos):
                        if todos.count > 0 {
                            var pagingMeta = pagingMeta
                            pagingMeta?.start += todos.count
                            return (todos, pagingMeta)
                        }
                    case let .error(error):
                        print(error)
                    default: break
                    }
                    return nil
                })
                .filterNil()
                .map({ result -> Mutation in
                    return .setTodos(result.0, pagingMeta: result.1)
                })
            return .concat([startRefreshing, setTodos, endRefreshing])
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
        case let .setTodos(todos, pagingMeta):
            let todoTitleRows = todos
                .map({ TodoTitleCellReactor(todo: $0) })
                .map({ TodoSection.Value.todoTitle($0) })
            state.sections = [.todos(todoTitleRows)]
            state.pagingMeta = pagingMeta
            return state
        }
    }
}
