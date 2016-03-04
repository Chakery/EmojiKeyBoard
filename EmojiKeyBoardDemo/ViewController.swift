//
//  ViewController.swift
//  EmojiKeyBoardDemo
//
//  Created by Chakery on 16/3/3.
//  Copyright © 2016年 Chakery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		let emoji = EmojiKeyBoardView()
		emoji.emojiDidSelected { (emojiKeyBoardView, emoji) -> Void in
			print(emoji)
		}
		view.addSubview(emoji)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
}
