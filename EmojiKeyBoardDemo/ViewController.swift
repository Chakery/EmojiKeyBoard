//
//  ViewController.swift
//  EmojiKeyBoardDemo
//
//  Created by Chakery on 16/3/3.
//  Copyright © 2016年 Chakery. All rights reserved.
//
//  /[\\[+](\\S?)[\\]+]/g
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var textView: UITextView!
	private var oldRect: CGRect!
	private var emojiView: EmojiKeyBoardView!
	private var isShow: Bool = false

	override func viewWillAppear(animated: Bool) {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardhandle", name: UIKeyboardWillShowNotification, object: nil)

		var rect = emojiView.frame
		oldRect = emojiView.frame
		rect.origin.y = UIScreen.mainScreen().bounds.height
		emojiView.frame = rect
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// 文本域
		textView.font = UIFont.systemFontOfSize(18)

		// 表情键盘
		emojiView = EmojiKeyBoardView()
		emojiView.emojiDidSelected { [unowned self](emojiKeyBoardView, emoji) -> Void in
			self.textView.insertEmoji(emoji)
		}
		view.addSubview(emojiView)
	}

	// 转换成字符串
	@IBAction func changeEmojiToString(sender: AnyObject) {
		print(textView.emojiText())
	}

	// 显示表情键盘
	@IBAction func showEmojiKeyBoard(sender: AnyObject) {
		view.endEditing(true)
		emojiKeyBoardAnimate()
	}

	// 键盘显示时回调
	func keyBoardhandle() {
		self.isShow = true
		emojiKeyBoardAnimate()
	}

	// 表情键盘出现时的动画
	private func emojiKeyBoardAnimate() {
		UIView.animateWithDuration(0.3) { [unowned self]() -> Void in
			var rect = self.emojiView.frame
			if self.isShow {
				rect.origin.y = UIScreen.mainScreen().bounds.height
			} else {
				rect = self.oldRect
			}
			self.isShow = !self.isShow
			self.emojiView.frame = rect
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
}
