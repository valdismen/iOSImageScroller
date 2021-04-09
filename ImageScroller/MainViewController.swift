//
//  MainViewController.swift
//  ImageScroller
//

import UIKit

final class MainViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .black
		setupContent()
	}

	private func setupContent() {
		let circleScrollerLeft = CircleScrollerView(items: makeImageViews(count: 6), scrollerType: .scrollerDefault)
		circleScrollerLeft.frame = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width / 2, height: view.frame.height)

		let circleScrollerRight = CircleScrollerView(items: makeImageViews(count: 12), scrollerType: .scrollerDefault)
		circleScrollerRight.frame = CGRect(x: view.frame.width / 2, y: view.frame.minY, width: view.frame.width / 2, height: view.frame.height)

		view.addSubview(circleScrollerLeft)
		view.addSubview(circleScrollerRight)
	}

	private func makeImageViews(count: UInt) -> [ImageView] {
		return (1...count).map({ _ -> ImageView in
			let view = ImageView()
			let url = URL(string: "https://picsum.photos/500")!
			view.provider = ImageProviderUrl(url: url)
			view.backgroundColor = .lightGray
			view.contentMode = .scaleAspectFill
			return view
		})
	}
}

