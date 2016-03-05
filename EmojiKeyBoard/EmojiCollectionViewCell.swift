//
//  EmojiCollectionViewCell.swift
//  EmojiKeyBoardDemo
//
//  Created by Chakery on 16/3/3.
//  Copyright © 2016年 Chakery. All rights reserved.
//

import UIKit

class EmojiCollectionViewCell: UICollectionViewCell {
	private var emojiButton: UIButton!
	var emojiModel: EmojiModel? {
		didSet {
			bindEmojiCollectionViewCell()
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupView() {
		emojiButton = UIButton(frame: bounds)
		emojiButton.userInteractionEnabled = false
		emojiButton.titleLabel?.font = UIFont.systemFontOfSize(bounds.width * 0.9)
		addSubview(emojiButton)
	}

	private func bindEmojiCollectionViewCell() {
		guard let _ = emojiModel else { return }
		// png 表情
		if let pngImage = emojiModel!.pngImage {
			emojiButton.setImage(pngImage, forState: .Normal)
		} else {
			emojiButton.setImage(nil, forState: .Normal)
		}
		// text 表情
		if let emoji = emojiModel!.emoji {
			emojiButton.setTitle(emoji, forState: .Normal)
		} else {
			emojiButton.setTitle(nil, forState: .Normal)
		}
		// 删除按钮
		if emojiModel!.deleteBtn {
			emojiButton.setImage(emojiModel!.pngImage, forState: .Normal)
		}
	}

	override func prepareForReuse() {
		emojiButton.setTitle(nil, forState: .Normal)
		emojiButton.setImage(nil, forState: .Normal)
	}
}
