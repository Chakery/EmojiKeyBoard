//
//  EmojiKeyBoardView.swift
//  EmojiKeyBoardDemo
//
//  Created by Chakery on 16/3/3.
//  Copyright © 2016年 Chakery. All rights reserved.
//

import UIKit

// 列
private let column: CGFloat = 8
// 行
private let row: CGFloat = 4
// 间隙
private let margin: CGFloat = 10
// 屏幕大小
private let mainRect = UIScreen.mainScreen().bounds
// 表情宽度
private let emojiWidth = (mainRect.width - ((column + 1) * margin)) / column
// 表情高度
private let emojiHeight = emojiWidth
// 工具栏高度
private let toolViewHeight: CGFloat = 30
// 工具栏的按钮宽度
private let toolButtonWidth: CGFloat = 80
// 键盘高度
private let keyBoardHeight = ((row + 1) * margin) + (row * emojiHeight)
// 回调
typealias block = (emojiKeyBoardView: EmojiKeyBoardView, emoji: EmojiModel) -> Void

class EmojiKeyBoardView: UIView {
	private let identifier = String(EmojiKeyBoardView) // identifier
	private var collectionView: UICollectionView! // 键盘
	private var toolView: UIView! // 工具栏
	private var pageControl: UIPageControl! // 页面控制器
	private var datasource: [EmojiPackageModel]? // 数据源
	private var currentEmojis: [EmojiModel]? // 当前显示的表情页面
	private var emojiHandle: block? // 回调
	private var tempButton: UIButton? // 保存当前被点击的按钮

	init() {
		super.init(frame: CGRect(x: 0, y: mainRect.height - keyBoardHeight - toolViewHeight, width: mainRect.width, height: keyBoardHeight + toolViewHeight))
		didInit()
		setupView()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func didInit() {
		dispatch_async(dispatch_get_global_queue(0, 0)) { [unowned self] _ in
			self.datasource = EmojiPackageManager.loadPackages
			// 处理数据源, 插入删除按钮
			for var i = 0; i < self.datasource!.count; i += 1 {
				let emojis = self.addDeleteButtonToDatasource(self.datasource![i].id, datasource: self.datasource![i].emojis!)
				self.datasource![i].emojis = emojis
			}
			dispatch_async(dispatch_get_main_queue()) { [unowned self] _ in
				self.setupToolView()
				self.currentEmojis = self.datasource?.first?.emojis!
				self.collectionView.reloadData()
			}
		}
	}

	private func setupView() {
		self.backgroundColor = UIColor.whiteColor()

		let rect = CGRect(x: 0, y: 0, width: mainRect.width, height: keyBoardHeight)
		let layout = EmojiLayout()
		layout.maxColumn = column
		layout.maxRow = row
		layout.margin = margin

		collectionView = UICollectionView(frame: rect, collectionViewLayout: layout)
		collectionView.backgroundColor = UIColor(white: 0, alpha: 0.1)
		collectionView.pagingEnabled = true
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.showsVerticalScrollIndicator = false
		collectionView.registerClass(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
		addSubview(collectionView)

		toolView = UIView(frame: CGRect(x: 0, y: bounds.height - toolViewHeight, width: bounds.width, height: toolViewHeight))
		toolView.backgroundColor = UIColor.orangeColor()
		addSubview(toolView)
	}

	/// 工具栏按钮
	private func setupToolView() {
		for var i = 0; i < datasource!.count; i += 1 {
			let button = UIButton(frame: CGRect(x: CGFloat(i) * toolButtonWidth, y: 0, width: toolButtonWidth, height: toolViewHeight))
			button.setTitle(datasource![i].name, forState: .Normal)
			button.tag = 1000 + i
			button.titleLabel?.font = UIFont.systemFontOfSize(14)
			button.addTarget(self, action: "toolButtonDidSelected:", forControlEvents: .TouchUpInside)
			toolView.addSubview(button)
		}
		let button = toolView.viewWithTag(1000) as! UIButton
		changeButtonStatus(button)
	}

	/// 工具栏按钮点击事件(切换表情包)
	@objc private func toolButtonDidSelected(button: UIButton) {
		changeButtonStatus(button)
		let index = button.tag % 1000
		currentEmojis = datasource![index].emojis!
		if let _ = currentEmojis {
			collectionView.contentSize = CGSize(width: CGFloat(totalPageAt(currentEmojis!.count)) * mainRect.width, height: keyBoardHeight)
			collectionView.contentOffset = CGPoint(x: 0, y: 0)
		}
		collectionView.reloadData()
	}

	/// 添加删除按钮
	///
	/// - parameter id:         表情包ID
	/// - parameter datasource: 数据源
	private func addDeleteButtonToDatasource(id: String?, datasource: [EmojiModel]) -> [EmojiModel] {
		let model = EmojiModel(id: id, dic: nil, deleteBtn: true)
		var emojis: [EmojiModel] = datasource
		let count = emojis.count / Int(column * row)
		var temp = Int(column * row) - 1
		for var i = 0; i < count; i += 1 {
			emojis.insert(model, atIndex: temp)
			temp += Int(column * row)
		}
		if datasource.count % Int(column * row) != 0 {
			emojis.append(model)
		}
		return emojis
	}

	/// 通过数据源计算得到, 当前的数据源能分成多少页
	///
	/// - parameter datasource: 表情数据源
	private func totalPageAt(count: Int) -> Int {
		var page = 0
		page = count / Int(column * row)
		page += count % Int(column * row) == 0 ? 0 : 1
		return page
	}

	/// 当前页显示多少个表情(最后一页显示的数量没法确定.)
	///
	/// - parameter page:       当前页(indexPath.section)
	/// - parameter datasource: 表情总数(currentEmojis.count)
	private func countOfCurrentPage(page: Int, count: Int) -> Int {
		let current = (page + 1) * Int(column * row)
		if current > count {
			return Int(column * row) - (current - count)
		}
		return Int(column * row)
	}

	/// 改变按钮的选中状态
	///
	/// - parameter button: 按钮
	private func changeButtonStatus(button: UIButton) {
		if let tempButton = tempButton {
			tempButton.backgroundColor = UIColor.clearColor()
		}
		tempButton = button
		button.backgroundColor = UIColor.grayColor()
	}
}

// MARK: - UICollectionViewDataSource
extension EmojiKeyBoardView: UICollectionViewDataSource, UICollectionViewDelegate {
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let index = indexPath.section * Int(column * row) + indexPath.row
		emojiHandle?(emojiKeyBoardView: self, emoji: currentEmojis![index])
	}

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if let total = currentEmojis?.count {
			return countOfCurrentPage(section, count: total)
		}
		return 0
	}

	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		if let datasource = currentEmojis {
			return totalPageAt(datasource.count)
		}
		return 0
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let item = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! EmojiCollectionViewCell
		if let models = currentEmojis {
			let index = (indexPath.section * Int(column * row)) + indexPath.row
			item.emojiModel = models[index]
		}
		return item
	}
}

// MARK: - interface
extension EmojiKeyBoardView {
	func emojiDidSelected(handle: block) {
		emojiHandle = handle
	}
}
