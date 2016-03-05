//
//  NSAttributedStringExtension.swift
//  EmojiKeyBoardDemo
//
//  Created by Chakery on 16/3/5.
//  Copyright © 2016年 Chakery. All rights reserved.
//

import UIKit

extension NSAttributedString {
	// 遍历属性, 获取字符串
	func getPlainString() -> String {
		let plainStr = NSMutableString(string: self.string)
		var base: Int = 0
		self.enumerateAttribute(NSAttachmentAttributeName, inRange: NSMakeRange(0, self.length), options: []) { (value, range, stop) -> Void in
			if let value = value as? EmojiTextAttachment {
				if let emojiTag = value.emojiTag {
					plainStr.replaceCharactersInRange(NSMakeRange(range.location + base, range.length), withString: emojiTag)
					base += emojiTag.characters.count - 1
				}
			}
		}
		return plainStr as String
	}
}
