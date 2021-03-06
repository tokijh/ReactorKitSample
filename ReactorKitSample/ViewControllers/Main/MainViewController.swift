//
//  MainViewController.swift
//  ReactorKitSample
//
//  Created by 윤중현 on 2018. 9. 27..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

class MainViewController: UIViewController, View {
    // MARK DisposeBag
    var disposeBag = DisposeBag()
    
    // MARK Life cycle
    init(reactor: MainViewReactor) {
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
    func bind(reactor: MainViewReactor) {
        bind(state: reactor.state)
        bind(action: reactor.action)
    }
    
    private func bind(state: Observable<MainViewReactor.State>) {
        state.map({ $0.pushingVC })
            .filterNil()
            .subscribe(onNext: { [weak self] vc in
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        bindTableView(state: state)
    }
    
    private func bind(action: ActionSubject<MainViewReactor.Action>) {
        rx.viewDidLoad.map({ Reactor.Action.refresh })
            .bind(to: action)
            .disposed(by: disposeBag)
        bindTableView(action: action)
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
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MainSampleSection>(configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
        switch item {
        case let .sampleTitle(reactor):
            if let cell = tableView.dequeue(TitleCell.self, indexPath: indexPath) {
                cell.reactor = reactor
                return cell
            }
        }
        return UITableViewCell()
    })
    
    private func bindTableView(state: Observable<MainViewReactor.State>) {
        state.map({ $0.sections }).bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
    private func bindTableView(action: ActionSubject<MainViewReactor.Action>) {
        tableView.rx.modelSelected(MainSampleSection.Value.self)
            .map({ Reactor.Action.selectSample($0) })
            .bind(to: action)
            .disposed(by: disposeBag)
    }
}
