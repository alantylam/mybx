//
//  BxPages.swift
//  MenuBar
//
//  Created by Nabil Muthanna on 2017-10-16.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit

protocol BXPagerOptions {
    var menuHeight: Float { get }
    var menuOptions: BXPagerMenuOptions { get }
}

protocol BXPagerMenuOptions {
    var scrollBarHeight: Float { get }
    var spacingBetweenItems: Float { get }
    var menuItemScrollBarColor: UIColor { get }
    var showAllItemsOnScreen: Bool { get }
    var menuItemWidth: Float { get }
}


class BXPageMenuController: UIViewController {
    
    //MARK: - APIs
    
    let viewControllerList: [UIViewController]
    let menuItems: [BXMenuBarCellType]
    let initialViewControllerIndex: Int
    var options: BXPagerOptions!
    
    init(_ controllers: [UIViewController], menuItems: [BXMenuBarCellType], initialViewControllerIndex: Int) {
        self.viewControllerList = controllers
        self.initialViewControllerIndex = initialViewControllerIndex
        self.menuItems = menuItems
        super.init(nibName: nil, bundle: nil)
        options = Dimension(traitCollection: traitCollection)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var menuBarHeightConstraint: NSLayoutConstraint?
    fileprivate lazy var menuBar: BXMenuBar = {
        let menuBar = BXMenuBar(frame: .zero, items: self.menuItems, options: self.options.menuOptions)
        menuBar.items =  self.menuItems
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        menuBar.selectedItemIndex = 0
        menuBar.onItemSelected = { [weak self] index in
            self?.pageController.setCurrentViewController(at: index)
        }
        menuBar.options = self.options.menuOptions
        return menuBar
    }()
    
    fileprivate lazy var pageController: BXPageController = {
        let pageController = BXPageController(self.viewControllerList, withInitialVCIndex: self.initialViewControllerIndex)
        pageController.didDisplayViewController = { [weak self] index in
            self?.menuBar.selectedItemIndex = index
        }
        return pageController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMenuBar()
        setupPageController()
    }
    
    open func showMenu() {
        menuBarHeightConstraint?.constant = CGFloat(options.menuHeight)
        animateMenuToggle()
    }
    
    open func hideMenu() {
        menuBarHeightConstraint?.constant = CGFloat(0)
        animateMenuToggle()
    }
    
    fileprivate func animateMenuToggle() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
    fileprivate func setupMenuBar() {
        view.addSubview(menuBar)
        
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        menuBar.layoutTo(edges: [.left, .right], ofView: view, withMargin: 0)
        menuBarHeightConstraint = menuBar.heightAnchor.constraint(equalToConstant: CGFloat(options.menuHeight))
        menuBarHeightConstraint?.isActive = true
    }
    
    fileprivate func setupPageController() {
        addChildViewController(pageController)
        view.addSubview(pageController.view)
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        pageController.view.layoutTo(edges: [.left, .right, .bottom], ofView: view, withMargin: 0)
        pageController.view.layout(edge: .top, toEdge: .bottom, ofView: menuBar, withMargin: 0)
        pageController.didMove(toParentViewController: self)
    }

}





class BXPageController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    var viewControllerList:[UIViewController]
    var currentVCIndex: Int
    
    var didDisplayViewController: (Int) -> () = { _ in }
    var didScrollToOffset: (CGPoint) -> () = { _ in }
    
    init(_ viewCotrollers: [UIViewController], withInitialVCIndex index: Int) {
        self.viewControllerList = viewCotrollers
        self.currentVCIndex = index
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        for view in self.view.subviews {
            if let view = view as? UIScrollView {
                view.delegate = self
                break
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCurrentViewController(at index: Int) {
        guard index >= 0 && index < viewControllerList.count else { return }
        
        if index < currentVCIndex {
            setViewControllers([viewControllerList[index]], direction: .reverse, animated: true, completion: nil)
            
        }
        if index >= currentVCIndex {
            setViewControllers([viewControllerList[index]], direction: .forward, animated: true, completion: nil)
        }
        currentVCIndex = index
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        if currentVCIndex >= 0 && currentVCIndex < viewControllerList.count {
            self.setViewControllers([viewControllerList[currentVCIndex]], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0 else {return nil}
        guard viewControllerList.count > previousIndex else {return nil}
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        let nextIndex = vcIndex + 1
        guard viewControllerList.count != nextIndex else { return nil}
        guard  viewControllerList.count > nextIndex else { return nil }
        return viewControllerList[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if(!completed) { return }
        if let viewControllers =  pageViewController.viewControllers {
            guard let vcIndex = viewControllerList.index(of: viewControllers[0]) else {return}
            didDisplayViewController(vcIndex)
            currentVCIndex = vcIndex
        }
    }
    
}


class BXMenuBar: UIView, UICollectionViewDelegateFlowLayout {
    
    var items: [BXMenuBarCellType] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var options: BXPagerMenuOptions
    
    var onItemSelected: ((Int) -> ()) = { _ in }
    var selectedItemIndex: Int? {
        didSet {
            guard (selectedItemIndex != nil) && (selectedItemIndex! < items.count) else { return }
            let indexPath = IndexPath(item: selectedItemIndex!, section: 0)
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            updateConstraintForScrollBar(at: selectedItemIndex!)
        }
    }
    
    
    var horizontalBarLeftConstrint: NSLayoutConstraint?
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BXMenuBarCell.self)
        collectionView.backgroundColor = StyleSheet.defaultTheme.mainColor
        return collectionView
    }()
    fileprivate lazy var horizontalBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(frame: CGRect, items: [BXMenuBarCellType], options: BXPagerMenuOptions) {
        self.items = items
        self.options = options
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        addSubviews([collectionView, horizontalBarView])
        // the following will change the size of menubar
        collectionView.layoutTo(edges: [.left, .top, .right, .bottom], ofView: self, withMargin: 0)
        horizontalBarLeftConstrint = horizontalBarView.leftAnchor.constraint(equalTo: leftAnchor)
        horizontalBarView.layoutTo(edges: [.bottom], ofView: self, withMargin: 0)
        
        if options.showAllItemsOnScreen {
            NSLayoutConstraint.activate([
                horizontalBarLeftConstrint!,
                horizontalBarView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: (1/CGFloat(items.count))),
                horizontalBarView.heightAnchor.constraint(equalToConstant: CGFloat(options.scrollBarHeight))
                ])
        } else {
            NSLayoutConstraint.activate([
                horizontalBarLeftConstrint!,
                horizontalBarView.widthAnchor.constraint(equalToConstant: CGFloat(options.menuItemWidth)),
                horizontalBarView.heightAnchor.constraint(equalToConstant: CGFloat(options.scrollBarHeight))
            ])
        }
        
        
    }
    
    func updateHorizontalBarLeftConstrint(withConstant constant: Float) {
        horizontalBarLeftConstrint?.constant = CGFloat(constant / Float(items.count))
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard items.count > 0 else { return }
        
        collectionView.collectionViewLayout.invalidateLayout()
        
        if let selectedItemIndex = selectedItemIndex {
            let x = CGFloat(selectedItemIndex) * (frame.width / CGFloat(items.count))
            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
                self?.horizontalBarLeftConstrint?.constant = x
                }, completion: nil)
        }
        
        updateTheme()
    }
    
    private func updateTheme() {
        horizontalBarView.backgroundColor = options.menuItemScrollBarColor
    }
    
    
    fileprivate func updateConstraintForScrollBar(at index: Int) {
        let x = CGFloat(index) * (frame.width / CGFloat(items.count))
        horizontalBarLeftConstrint?.constant = x
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if options.showAllItemsOnScreen{
            return CGSize(width: frame.width / CGFloat(items.count), height: frame.height)
        } else {
            return CGSize(width: CGFloat(options.menuItemWidth), height: frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(options.spacingBetweenItems)
    }
}

extension BXMenuBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BXMenuBarCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.type = items[indexPath.item]
        cell.backgroundColor = StyleSheet.defaultTheme.mainColor
        return cell
    }
}

extension BXMenuBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItemIndex = indexPath.item
        onItemSelected(indexPath.item)
    }
}


enum BXMenuBarCellType {
    case image(UIImage)
    case label(String)
}


final class BXMenuBarCell: UICollectionViewCell, ReusableView {
    
    fileprivate let itemColor = StyleSheet.defaultTheme.contentBackgroundColor.withAlphaComponent(0.6)

    var type: BXMenuBarCellType?
    
    override var isHighlighted: Bool {
        didSet {
            updateState(isHighlighted)
        }
    }
    override var isSelected: Bool {
        didSet {
            updateState(isSelected)
        }
    }
    
    fileprivate func updateState(_ isSelected: Bool) {
        guard let type = type else { return }
        switch  type{
        case .image(_):
            imageView.tintColor = isSelected ? .white : itemColor
        case .label(_):
            label.textColor = isSelected ? .white : itemColor
        }
    }
    
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        return imageView
    }()
    fileprivate lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont (name: "PingFangSC-Light", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let type = type else { return }
        switch type {
        case .image(let iconName):
            addSubview(imageView)
            imageView.layoutTo(edges: [.left, .top, .right, .bottom], ofView: self, withMargin: -2)
            imageView.image = iconName.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = (isSelected || isHighlighted)  ? .white : itemColor
            
        case .label(let labelText):
            addSubview(label)
            label.layoutTo(edges: [.left, .top, .right, .bottom], ofView: self, withMargin: -2)
            label.text = labelText
            label.textColor = (isSelected || isHighlighted) ? .white : itemColor
        }
    }
    
}







