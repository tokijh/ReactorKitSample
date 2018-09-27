//
//  SampleTitleCell.swift
//  ReactorKitSample
//
//  Created by 윤중현 on 2018. 9. 27..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift

class SampleTitleCell: UITableViewCell, View {
    // MARK DisposeBag
    var disposeBag = DisposeBag()
    
    // MARK Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupView()
    }
    
    // MARK Reactor Binder
    func bind(reactor: SampleTitleCellReactor) {
        bind(state: reactor.state)
    }
    
    private func bind(state: Observable<SampleTitleCellReactor.State>) {
        bindTitleLabel(state: state)
    }
    
    // MARK View
    private func setupView() {
        layoutView()
    }
    
    private func layoutView() {
        contentView.addSubview(titlelabel)
        titlelabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        }
    }
    
    // MARK Title Label
    public private(set) lazy var titlelabel: UILabel = UILabel()
    
    private func bindTitleLabel(state: Observable<SampleTitleCellReactor.State>) {
        state.map({ $0.title }).bind(to: titlelabel.rx.text).disposed(by: disposeBag)
    }
}
