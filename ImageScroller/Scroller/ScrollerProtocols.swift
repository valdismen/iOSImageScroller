//
//  ScrollerProtocols.swift
//  ImageScroller
//

import UIKit

enum ScrollerTypes {
	case scrollerDefault
}

protocol Scrollable: AnyObject {
	func updateScroll(scrollPos: CGFloat)
}

protocol Scroller {
	var delegate: Scrollable? { get set }
	func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?, view: UIView)
	func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?, view: UIView)
}
