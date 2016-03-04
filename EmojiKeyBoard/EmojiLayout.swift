//
//  EmojiLayout.swift
//  UICollectionViewDemo
//
//  Created by Chakery on 16/3/4.
//  Copyright © 2016年 Chakery. All rights reserved.
//

import UIKit

class EmojiLayout: UICollectionViewLayout {
	// 保存所有item属性
	private var attributes: [UICollectionViewLayoutAttributes] = []
	// screen
	private let mainRect = UIScreen.mainScreen().bounds
	// section
	private var sections: Int = 0
	// item
	private var items: Int = 0
	// column
	var maxColumn: CGFloat = 0
	// row
	var maxRow: CGFloat = 0
	// margin
	var margin: CGFloat = 0

	// MARK: - 允许重新布局
	override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
		return true
	}

	// MARK: - 重新布局
	override func prepareLayout() {
		super.prepareLayout()

		attributes.removeAll()

		let itemsize = getItemSize(maxColumn, row: maxRow, margin: margin)
		sections = self.collectionView?.numberOfSections() ?? 0
		for section in 0 ..< sections {
			items = self.collectionView?.numberOfItemsInSection(section) ?? 0
			for item in 0 ..< items {
				let indexPath = NSIndexPath(forItem: item, inSection: section)
				let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)

				let x = margin + (itemsize.width + margin) * (CGFloat(item) % maxColumn) + (CGFloat(section) * mainRect.width)
				let y = margin + (itemsize.height + margin) * CGFloat(item / Int(maxColumn))
				attribute.frame = CGRect(x: x, y: y, width: itemsize.width, height: itemsize.height)

				attributes.append(attribute)
			}
		}
	}

	// MARK: - 返回当前可见的
	override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		var rectAttributes: [UICollectionViewLayoutAttributes] = []
		let _ = attributes.map {
			if CGRectContainsRect(rect, $0.frame) {
				rectAttributes.append($0)
			}
		}
		return rectAttributes
	}

	// MARK: - 返回大小
	override func collectionViewContentSize() -> CGSize {
		let itemsize = getItemSize(maxColumn, row: maxRow, margin: margin)
		return CGSize(width: CGFloat(sections) * mainRect.width, height: margin + (maxRow * (itemsize.height + margin)))
	}

	// MARK: - itemSize
	// 为了使得表情不变形, 因此 height = width
	private func getItemSize(column: CGFloat, row: CGFloat, margin: CGFloat) -> CGSize {
		let width = (mainRect.width - ((column + 1) * margin)) / column
		return CGSize(width: width, height: width)
	}
}
