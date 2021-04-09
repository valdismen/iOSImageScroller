//
//  CircleScrollerView.swift
//  ImageScroller
//

import UIKit

final class CircleScrollerView: UIView {
	override var frame: CGRect {
		didSet {
			recalculateItems()
		}
	}

	private enum Constants {
		static let radius: CGFloat = 200
		static let fullHorizontalMargins: CGFloat = 20 * 2
		static let sensivity: CGFloat = 5
	}

	private let items: [UIView]
	private var scroller: Scroller?

	private var currentAngle: CGFloat = 0
	private var centerOfView: CGPoint = .zero
	private var rotationSpeed: CGFloat = 0
	private var lastMoveTime: TimeInterval?
	private var lastDeltaY: CGFloat = 0

	init(items: [UIView], scrollerType: ScrollerTypes) {
		self.items = items
		super.init(frame: .zero)
		addViews()
		setupScroller(scrollerType: scrollerType)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		centerOfView = CGPoint(x: frame.width / 2, y: frame.height / 2)
		recalculateItems()
	}

	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		scroller?.touchesMoved(touches, with: event, view: self)
	}

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		scroller?.touchesEnded(touches, with: event, view: self)
	}

	private func setupScroller(scrollerType: ScrollerTypes) {
		let scroller: Scroller

		switch scrollerType {
		case .scrollerDefault:
			scroller = ScrollerDefault()
		}

		self.scroller = scroller
		self.scroller?.delegate = self
	}

	private func addViews() {
		items.forEach { addSubview($0) }
	}

	private func recalculateItems() {
		let anglePerItem = 2 * CGFloat.pi / CGFloat(items.count)
		let itemsAngles = (0..<items.count).map { number -> (sin: CGFloat, cos: CGFloat) in
			let itemAngle = currentAngle + CGFloat(number) * anglePerItem
			return (sin: sin(itemAngle), cos: cos(itemAngle))
		}

		zip(itemsAngles, items).sorted(by: {
			$0.0.cos < $1.0.cos
		}).forEach {
			configureItemFrame(item: $1, sinValue: $0.sin, cosValue: $0.cos)
			bringSubviewToFront($1)
		}
	}

	private func configureItemFrame(item: UIView, sinValue: CGFloat, cosValue: CGFloat) {
		let scalingFactor = cosValue.map(from: -1...1, to: 0.1...1.0)
		let sideSize = (frame.width - Constants.fullHorizontalMargins) * scalingFactor
		let sideOffset = sideSize / 2
		let yOffset = sinValue * Constants.radius

		item.frame = CGRect(
			x: centerOfView.x - sideOffset,
			y: centerOfView.y - sideOffset + yOffset,
			width: sideSize,
			height: sideSize
		)
	}
}

extension CircleScrollerView: Scrollable {
	func updateScroll(scrollPos: CGFloat) {
		currentAngle = scrollPos / (2 * CGFloat.pi * Constants.radius) * Constants.sensivity
		recalculateItems()
	}
}
