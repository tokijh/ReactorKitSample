//
//  CollectionLoadmoreViewController.swift
//  ReactorKitSample
//
//  Created by 윤중현 on 2018. 10. 8..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

class CollectionLoadmoreViewController: UIViewController, View {
    fileprivate typealias State = CollectionLoadmoreViewReactor.State
    fileprivate typealias Action = CollectionLoadmoreViewReactor.Action
    
    // MARK DisposeBag
    var disposeBag = DisposeBag()
    
    // MARK Life cycle
    init(reactor: CollectionLoadmoreViewReactor) {
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
    func bind(reactor: CollectionLoadmoreViewReactor) {
        bind(state: reactor.state)
        bind(action: reactor.action)
    }
    
    private func bind(state: Observable<State>) {
        bindCollectionView(state: state)
        bindRefreshControl(state: state)
    }
    
    private func bind(action: ActionSubject<Action>) {
        rx.viewDidLoad.map({ Action.refresh })
            .bind(to: action)
            .disposed(by: disposeBag)
        bindCollectionView(action: action)
        bindRefreshControl(action: action)
    }
    
    // MARK View
    private func setupView() {
        view.backgroundColor = UIColor.white
        setupCollectionView()
        layoutView()
        setupRefreshControl()
    }
    
    private func layoutView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK CollectionView
    public private(set) lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<TodoSection>(configureCell: { (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
        switch item {
        case let .todoTitle(reactor):
            if let cell = collectionView.dequeue(TitleCollectionCell.self, for: indexPath) {
                cell.reactor = reactor
                return cell
            }
        }
        return UICollectionViewCell()
    })
    
    private func setupCollectionView() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(cell: TitleCollectionCell.self)
    }
    
    private func bindCollectionView(state: Observable<State>) {
        state.map({ $0.sections }).bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
    private func bindCollectionView(action: ActionSubject<Action>) {
        collectionView.rx.isReachedBottom
            .map({ Reactor.Action.loadMore })
            .bind(to: action)
            .disposed(by: disposeBag)
    }
    
    // MARK RefreshControl
    public private(set) lazy var refreshControl = UIRefreshControl()
    
    private func setupRefreshControl() {
        collectionView.addSubview(refreshControl)
    }
    
    private func bindRefreshControl(state: Observable<State>) {
        state.map({ $0.isRefreshing })
            .distinctUntilChanged()
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    private func bindRefreshControl(action: ActionSubject<Action>) {
        refreshControl.rx.controlEvent(.valueChanged)
            .map({ Reactor.Action.refresh })
            .bind(to: action)
            .disposed(by: disposeBag)
    }
}

extension CollectionLoadmoreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
