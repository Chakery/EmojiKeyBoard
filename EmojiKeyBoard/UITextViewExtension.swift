//
//  UITextViewExtension.swift
//  EmojiKeyBoardDemo
//
//  Created by Chakery on 16/3/5.
//  Copyright © 2016年 Chakery. All rights reserved.
//

import UIKit

extension UITextView {
	/// 插入表情
	///
	/// - parameter emojiModel: 表情模型
	func insertEmoji(emojiModel: EmojiModel) {
		// 删除按钮
		if emojiModel.deleteBtn {
			deleteBackward()
			return
		}
		// text 表情
		if let emoji = emojiModel.emoji {
			insertText(emoji)
		}
		// png 表情
		if let pngImage = emojiModel.pngImage {
			// 附件
			let attachment = EmojiTextAttachment()
			// 设置图片
			attachment.image = pngImage
			// 设置图片标志
			attachment.emojiTag = emojiModel.chs
			// 设置附件大小 (表情跟文本的大小一致)
			attachment.bounds = CGRect(x: 0, y: -4, width: font!.lineHeight, height: font!.lineHeight)

			// 带属性的文本, 把图片设置进去
			let attritubeString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
			// 设置字体
			attritubeString.addAttribute(NSFontAttributeName, value: font!, range: NSRange(location: 0, length: 1))

			// 获取原来的文本, 替换为现在的文本, 再给textView的属性文本赋值
			let att = NSMutableAttributedString(attributedString: attributedText)
			att.replaceCharactersInRange(self.selectedRange, withAttributedString: attritubeString)
			attributedText = att

			// 光标
			selectedRange.location += 1

			// 重写通知, 代理方法
			NSNotificationCenter.defaultCenter().postNotificationName(UITextViewTextDidChangeNotification, object: self)
			delegate?.textViewDidChange!(self)
		}
	}

	/// 把表情转换成字符串
	func emojiText() -> String {
		return self.attributedText.getPlainString()
	}
}
