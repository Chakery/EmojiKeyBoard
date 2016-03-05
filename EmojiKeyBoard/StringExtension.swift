//
//  StringExtension.swift
//  EmojiKeyBoardDemo
//
//  Created by Chakery on 16/3/5.
//  Copyright © 2016年 Chakery. All rights reserved.
//

import Foundation

///  @brief 字符串属性
struct StringProperty {
	/// 原来的字符串
	var source: String
	/// 找到的字符串
	var value: String
	/// 位置
	var range: Range<String.Index>

	init(source: String, value: String, range: Range<String.Index>) {
		self.source = source
		self.value = value
		self.range = range
	}
}

extension String {
	func between(start: String, _ end: String) -> StringProperty? {

		guard let leftRange = rangeOfString(start), rightRange = rangeOfString(end, options: .RegularExpressionSearch)
		where start != end && leftRange.endIndex != rightRange.startIndex
		else { return nil }

		let value = self[leftRange.endIndex ... rightRange.startIndex.predecessor()]
		let source = "\(start)\(value)\(end)"

		return StringProperty(source: source, value: value, range: Range<Index>(start: leftRange.startIndex, end: rightRange.endIndex))
	}
}
