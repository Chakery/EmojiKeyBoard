//
//  UILabelExtension.swift
//  EmojiKeyBoardDemo
//
//  Created by Chakery on 16/3/5.
//  Copyright © 2016年 Chakery. All rights reserved.
//

import UIKit

extension UILabel {
	/// 给label设置带表情的字符串
	///
	/// - parameter string: 带表情的字符串
	func setEmojiText(string: String) {
		let attritube = NSMutableAttributedString(string: string)

		while let property = attritube.string.between("[", "]") {
			guard let emojiModel = EmojiPackageManager.verificationEmojiWithString(property.value) else { continue }

			let attachment = NSTextAttachment()
			attachment.image = emojiModel.pngImage
			attachment.bounds = CGRect(x: 0, y: -4, width: font!.lineHeight, height: font!.lineHeight)
			let attributeString = NSAttributedString(attachment: attachment)
			attritube.replaceCharactersInRange(property.range, withAttributedString: attributeString)
		}
		self.attributedText = attritube
	}
}
