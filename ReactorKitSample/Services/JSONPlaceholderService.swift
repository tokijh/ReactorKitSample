//
//  JSONPlaceholderService.swift
//  ReactorKitSample
//
//  Created by 윤중현 on 2018. 9. 28..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import RxSwift
import Moya

protocol JSONPlaceholderServiceType: ServiceType {
    func todos(start: Int, limit: Int) -> Observable<Result<[Todo]>>
}

class JSONPlaceholderService: JSONPlaceholderServiceType {
    static let provider = MoyaProvider<JSONPlaceholderProvider>(plugins: [NetworkLoggerPlugin(verbose: true)])
    func todos(start: Int, limit: Int) -> Observable<Result<[Todo]>> {
        let token = JSONPlaceholderProvider.todos(start: start, limit: limit)
        return JSONPlaceholderService.provider.rx.request(token)
            .do(onSuccess: { (response) in
                print(try response.mapString())
            })
            .map([Todo].self)
            .map({ Result<[Todo]>.success($0) })
            .catchError({ Single.just(Result<[Todo]>.error($0)) })
            .asObservable()        
    }
}

enum JSONPlaceholderProvider {
    case todos(start: Int, limit: Int)
}

extension JSONPlaceholderProvider: TargetType {
    var baseURL: URL { return URL(string: "https://jsonplaceholder.typicode.com")! }
    
    var path: String {
        switch self {
        case .todos: return "/todos/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default: return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case let .todos(start, limit):
            let todos = Array(start..<start + limit)
                .map { idx -> Todo in
                    Todo().then {
                            $0.title = "Todo \(idx)"
                            $0.id = idx
                        }
                }
            return try! JSONEncoder().encode(todos)
        }
    }
    
    var task: Task {
        switch self {
        case let .todos(start, limit):
            var params: [String: Any] = [:]
            params["_start"] = start
            params["_limit"] = limit
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
