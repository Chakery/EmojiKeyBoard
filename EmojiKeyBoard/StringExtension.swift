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
	/// 字符串
	var value: String
	/// 位置
	var range: NSRange

	init(value: String, range: NSRange) {
		self.value = value
		self.range = range
	}
}

extension String {
	/// 字符串查找, 返回以start开始 且 以end结尾的字符串
	///
	/// - parameter start: 开始字符串
	/// - parameter end:   结束字符串
	///
	/// - returns: 如果存在, 返回 StringProperty 对象, 否则返回nil
	func between(start: String, _ end: String) -> StringProperty? {
		var range = NSRange()
		var flag: Bool = false
		let string = self as NSString

		for var i = 0; i < string.length; i += 1 {
			let subStr = string.substringWithRange(NSRange(location: i, length: 1))
			if start == subStr {
				range.location = i
				flag = true
				continue
			} else if flag && subStr == end {
				flag = false
				range.length = i - range.location - 1
				let strRange = NSRange(location: range.location, length: range.length + start.characters.count + end.characters.count)
				let value = string.substringWithRange(strRange)
				return StringProperty(value: value, range: strRange)
			}
		}
		return nil
	}
}
