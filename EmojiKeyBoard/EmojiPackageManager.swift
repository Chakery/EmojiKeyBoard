//
//  EmojiPackageManager.swift
//  EmojiKeyBoardDemo
//
//  Created by Chakery on 16/3/3.
//  Copyright © 2016年 Chakery. All rights reserved.
//

import Foundation

class EmojiPackageManager {
	/// bundle路径
	static let bundlePath = NSBundle.mainBundle().pathForResource("EmojiKeyBoard", ofType: "bundle")!
	/// emojiPackage路径
	static let emojiPackagePath = (EmojiPackageManager.bundlePath as NSString).stringByAppendingPathComponent("emojiPackage.plist")

	/// 加载所有表情
	static var loadPackages: [EmojiPackageModel] = {
		var emojiPackages: [EmojiPackageModel] = []
		let package = NSDictionary(contentsOfFile: emojiPackagePath)
		if let arr = package?["packages"] as? Array<AnyObject> {
			for dic in arr {
				if let dic = dic as? [String : AnyObject] {
					if let id = dic["id"] as? String {
						let emojis = EmojiPackageManager.loadEmojisAtPackageName(id)
						let packageModel = EmojiPackageModel(id: id, name: dic["name"] as? String, emojis: emojis)
						emojiPackages.append(packageModel)
					}
				}
			}
		}
		return emojiPackages
	}()

	/// 加载某一页表情
	///
	/// - parameter packageName: 表情包名
	class func loadEmojisAtPackageName(packageName: String) -> [EmojiModel] {
		let path = "\(bundlePath)/\(packageName)/info.plist"
		var emojis: [EmojiModel] = []
		let dic = NSDictionary(contentsOfFile: path) as! [String : AnyObject]
		if let arr = dic["emojis"] as? [AnyObject] {
			let _ = arr.map {
				emojis.append(EmojiModel(id: dic["id"] as? String, dic: $0 as? [String : AnyObject]))
			}
		}
		return emojis
	}

	/// 根据字符串查找对应的表情
	///
	/// - parameter string: 字符串
	///
	/// - returns: 表情对象
	class func verificationEmojiWithString(string: String) -> EmojiModel? {
		for package in loadPackages {
			guard let emojis = package.emojis else { continue }
			for item in emojis {
				guard let chs = item.chs else { continue }
				if chs == "[\(string)]" {
					return item
				}
			}
		}
		return nil
	}
}