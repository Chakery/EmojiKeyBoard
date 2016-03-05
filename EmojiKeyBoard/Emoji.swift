//
//  EmojiModel.swift
//  EmojiKeyBoardDemo
//
//  Created by Chakery on 16/3/3.
//  Copyright © 2016年 Chakery. All rights reserved.
//

import UIKit

///  @brief 表情模型
struct EmojiModel {
	var id: String? // 表情对应的包ID
	var chs: String? // 表情发送时的对应的文本(简体中文)
	var cht: String? // 表情发送时的对应的文本(繁体中文)
	var gif: String? // Gif表情名称
	var png: String? // Png表情名称
	var code: String? // 表情十六进制编码
	var gifImage: UIImage? // gif图片路径
	var pngImage: UIImage? // png图片路径
	var emoji: String? // 表情
	var deleteBtn: Bool // false: 表情 | true: 删除按钮

	init(id: String?, dic: [String : AnyObject]?, deleteBtn: Bool = false) {
		self.id = id
		self.chs = dic?["chs"] as? String
		self.cht = dic?["cht"] as? String
		self.gif = dic?["gif"] as? String
		self.png = dic?["png"] as? String
		self.code = dic?["code"] as? String
		self.deleteBtn = deleteBtn

		if let png = self.png {
			self.pngImage = UIImage(named: "EmojiKeyBoard.bundle/\(id!)/\(png)")
		}
		if let gif = self.gif {
			self.gifImage = UIImage(named: "EmojiKeyBoard.bundle/\(id!)/\(gif)")
		}
		if deleteBtn {
			self.pngImage = UIImage(named: "EmojiKeyBoard.bundle/delete.png")
		}
		if let code = self.code {
			let scanner = NSScanner(string: code)
			var result: UInt32 = 0
			scanner.scanHexInt(&result)
			let chat = Character(UnicodeScalar(result))
			emoji = "\(chat)"
		}
	}
}

///  @brief 表情包模型
struct EmojiPackageModel {
	var id: String? // 表情包ID
	var name: String? // 表情包中文名称
	var emojis: [EmojiModel]? // 表情

	init(id: String?, name: String?, emojis: [EmojiModel]?) {
		self.id = id
		self.name = name
		self.emojis = emojis
	}
}