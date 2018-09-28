//
//  UIScrollView+Rx.swift
//  ReactorKitSample
//
//  Created by 윤중현 on 2018. 9. 28..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate let startLoadingOffset: CGFloat = 20.0
fileprivate func isNearTheBottomEdge(contentOffset: CGPoint, _ scrollView: UIScrollView) -> Bool {
    return contentOffset.y + scrollView.frame.size.height + startLoadingOffset > scrollView.contentSize.height
}

extension Reactive where Base: UIScrollView {
    var isReachedBottom: ControlEvent<Void> {
        let source = self.contentOffset
            .filter { [weak base = self.base] offset in
                guard let base = base else { return false }
                return isNearTheBottomEdge(contentOffset: base.contentOffset, base)
//                return base.isReachedBottom(withTolerance: base.height / 2)
            }
            .map { _ in Void() }
        return ControlEvent(events: source)
    }
}
