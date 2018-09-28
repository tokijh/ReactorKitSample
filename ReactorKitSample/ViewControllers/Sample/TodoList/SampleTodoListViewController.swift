//
//  SampleTodoListViewController.swift
//  ReactorKitSample
//
//  Created by 윤중현 on 2018. 9. 28..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

class SampleTodoListViewController: UIViewController, View {
    // MARK DisposeBag
    var disposeBag = DisposeBag()
    
    // MARK Life cycle
    init(reactor: SampleTodoListViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupView()
    }
    
    // MARK Reactor Binder
    func bind(reactor: SampleTodoListViewReactor) {
        bind(state: reactor.state)
        bind(action: reactor.action)
    }
    
    private func bind(state: Observable<SampleTodoListViewReactor.State>) {
        bindTableView(state: state)
    }
    
    private func bind(action: ActionSubject<SampleTodoListViewReactor.Action>) {
        rx.viewDidLoad.map({ Reactor.Action.refresh })
            .bind(to: action)
            .disposed(by: disposeBag)
    }
    
    // MARK View
    private func setupView() {
        view.backgroundColor = UIColor.white
        layoutView()
    }
    
    private func layoutView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK TableView
    public private(set) lazy var tableView: UITableView = UITableView().then {
        $0.register(cell: TitleCell.self)
    }
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<TodoSection>(configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
        switch item {
        case let .todoTitle(reactor):
            if let cell = tableView.dequeue(TitleCell.self, indexPath: indexPath) {
                cell.reactor = reactor
                return cell
            }
        }
        return UITableViewCell()
    })
    
    private func bindTableView(state: Observable<SampleTodoListViewReactor.State>) {
        state.map({ $0.sections }).bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
}
