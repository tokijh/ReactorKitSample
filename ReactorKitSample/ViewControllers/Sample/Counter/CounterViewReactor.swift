//
//  CounterViewReactor.swift
//  ReactorKitSample
//
//  Created by 윤중현 on 10/11/2018.
//  Copyright © 2018 tokijh. All rights reserved.
//

import ReactorKit
import RxSwift

class CounterViewReactor: Reactor {
    enum Action {
        case plus
        case minus
    }
    
    enum Mutation {
        case plus
        case minus
    }
    
    struct State {
        var count: Int
    }
    
    let initialState = State(count: 0)
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .plus: return Observable.just(Mutation.plus)
        case .minus: return Observable.just(Mutation.minus)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .plus:
            state.count += 1
        case .minus:
            state.count -= 1
        }
        return state
    }
}
