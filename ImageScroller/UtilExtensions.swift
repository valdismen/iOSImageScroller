//
//  UtilExtensions.swift
//  ImageScroller
//

import QuartzCore

extension CGFloat {
	func map(from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> CGFloat {
		return ((self - from.lowerBound) / (from.upperBound - from.lowerBound)) * (to.upperBound - to.lowerBound) + to.lowerBound
	}
}
