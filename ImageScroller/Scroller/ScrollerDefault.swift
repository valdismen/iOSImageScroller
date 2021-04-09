//
//  ScrollerDefault.swift
//  ImageScroller
//

import UIKit

final class ScrollerDefault: Scroller {
	private enum Constants {
		static let friction: CGFloat = 0.99
		static let minSpeed: CGFloat = 10
	}

	weak var delegate: Scrollable?
	
	private var scrollPos: CGFloat = 0
	private var scrollSpeed: CGFloat = 0
	private var lastMoveTime: TimeInterval?
	private var lastDeltaY: CGFloat = 0
	private lazy var displayLink = CADisplayLink(target: self, selector: #selector(onFrameUpdate))

	func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?, view: UIView) {
		guard touches.count == 1, let touch = touches.first else {
			return
		}

		let currentLocation = touch.location(in: view)
		let previousLocation = touch.previousLocation(in: view)
		let deltaY = currentLocation.y - previousLocation.y
		lastMoveTime = touch.timestamp
		lastDeltaY = deltaY
		scrollSpeed = 0
		scrollPos += deltaY

		delegate?.updateScroll(scrollPos: scrollPos)
	}

	func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?, view: UIView) {
		guard let eventTime = event?.timestamp, let lastTime = lastMoveTime else {
			return
		}

		let deltaTime = CGFloat(eventTime - lastTime)
		scrollSpeed = lastDeltaY / deltaTime
		startRotation()
	}

	private func startRotation() {
		displayLink.add(to: .main, forMode: .common)
	}

	@objc private func onFrameUpdate() {
		scrollPos += scrollSpeed * CGFloat(displayLink.duration)
		scrollSpeed *= Constants.friction

		if abs(scrollSpeed) < Constants.minSpeed {
			displayLink.remove(from: .main, forMode: .common)
		}

		delegate?.updateScroll(scrollPos: scrollPos)
	}
}
