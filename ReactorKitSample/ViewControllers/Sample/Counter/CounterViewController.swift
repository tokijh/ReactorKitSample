//
//  CounterViewController.swift
//  ReactorKitSample
//
//  Created by 윤중현 on 10/11/2018.
//  Copyright © 2018 tokijh. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class CounterViewController: UIViewController, View {
    fileprivate typealias State = CounterViewReactor.State
    fileprivate typealias Action = CounterViewReactor.Action
    
    // MARK DisposeBag
    var disposeBag = DisposeBag()
    
    // MARK Life cycle
    init(reactor: CounterViewReactor) {
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
    func bind(reactor: CounterViewReactor) {
        bind(state: reactor.state)
        bind(action: reactor.action)
    }
    
    private func bind(state: Observable<State>) {
        bindCountLabel(state: state)
    }
    
    private func bind(action: ActionSubject<Action>) {
        bindPlusButton(action: action)
        bindMinusButton(action: action)
    }
    
    // MARK View
    private func setupView() {
        view.backgroundColor = UIColor.white
        layoutView()
    }
    
    private func layoutView() {
        view.addSubview(countLabel)
        countLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        view.addSubview(plusButton)
        plusButton.snp.makeConstraints {
            $0.centerY.equalTo(countLabel)
            $0.left.equalTo(countLabel.snp.right).offset(16)
        }
        view.addSubview(minusButton)
        minusButton.snp.makeConstraints {
            $0.centerY.equalTo(countLabel)
            $0.right.equalTo(countLabel.snp.left).offset(-16)
        }
    }
    
    // MARK CountLabel
    public private(set) lazy var countLabel: UILabel = UILabel()
    private func bindCountLabel(state: Observable<State>) {
        state.map({ $0.count })
            .map({ "\($0)" })
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK Plus Button
    public private(set) lazy var plusButton: UIButton = UIButton()
        .then {
            $0.setTitle("+", for: .normal)
            $0.setTitleColor(UIColor.blue, for: .normal)
        }
    private func bindPlusButton(action: ActionSubject<Action>) {
        plusButton.rx.tap
            .map({ Action.plus })
            .bind(to: action)
            .disposed(by: disposeBag)
    }
    
    // MARK Minus Button
    public private(set) lazy var minusButton: UIButton = UIButton()
        .then {
            $0.setTitle("-", for: .normal)
            $0.setTitleColor(UIColor.blue, for: .normal)
        }
    private func bindMinusButton(action: ActionSubject<Action>) {
        minusButton.rx.tap
            .map({ Action.minus })
            .bind(to: action)
            .disposed(by: disposeBag)
    }
}
