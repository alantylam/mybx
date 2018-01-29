//
//  XpertListVC.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-10-27.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit

final class XpertListViewController: UITableViewController {
    
    private enum Sections {
        case xperts, loadingIndicator
    }
    
    private var _viewModel: XpertListViewModelType
    private let _sections: [Sections] = [.xperts, .loadingIndicator]
    
    init(viewModel: XpertListViewModelType) {
        _viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupTableView()
        setupViewModel()
        _viewModel.inputs.viewDidLoad()
    }
    
    private func setupTableView() {
        tableView.register(XpertCell.self)
        tableView.register(LoadingIndicatorTableCell.self)
        tableView.separatorStyle = .none
        view.backgroundColor = StyleSheet.defaultTheme.backgroundColor
        tableView.backgroundColor = StyleSheet.defaultTheme.backgroundColor
    }
    
    private func setupViewModel() {
        _viewModel.outputs.appendNextPage = { [weak self] indexPaths in
            guard let strongSelf = self else { return }
            strongSelf.tableView?.insertRows(at: indexPaths, with: .automatic)
            strongSelf.tableView?.reloadRows(at: [IndexPath(item: 0, section: 1)], with: .automatic)
        }
        _viewModel.outputs.nextPageFailed = { error in print("Error Loading the next page \(error.localizedDescription)")}
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return _sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch _sections[section] {
        case .xperts:
            return _viewModel.outputs.numberOfItems
        case .loadingIndicator:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       switch _sections[indexPath.section] {
        case .xperts:
            let cell: XpertCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            let xpert: Xpert? = _viewModel.outputs[indexPath.row]
            cell.xpert = xpert
            cell.selectionStyle = .none
            return cell
        case .loadingIndicator:
            let cell: LoadingIndicatorTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            if _viewModel.outputs.isLastPage{
                cell.stopAnimating()
            } else {
                cell.startAnimating()
                _viewModel.inputs.fetchNextPage()
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch _sections[indexPath.section] {
        case .xperts:
            return Dimension(traitCollection: traitCollection).xpertCellHeight
        case .loadingIndicator:
            return Dimension(traitCollection: traitCollection).loadCell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch _sections[indexPath.section] {
        case .xperts:
            let i: Xpert? = _viewModel.outputs[indexPath.row]
            guard let xpert = i else { return }
            _viewModel.inputs.selectedProfileFor(xpert: xpert)
        case .loadingIndicator:
            break
        }
    }
    
}
