//
//  BaseSearchArtistViewController.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/23/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation
import UIKit

class BaseSearchArtistViewController: UIViewController {


    // MARK: - Outlets

    @IBOutlet weak var artistsTableView: UITableView!
    @IBOutlet weak var artistSearchBar: UISearchBar!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    public var paginationIndicator: UIActivityIndicatorView?
    private var refreshControl: UIRefreshControl?
    private var hasPagination: Bool = false

    // MARK: - Base Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableDataSource()
        setupCellNibNames()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view

    func setupTableDataSource() -> Void {
        artistsTableView.delegate = self
        artistsTableView.dataSource = self
    }


    // MARK: Table view nib name

    public func setupCellNibNames() -> Void {
        // This methode will overridw at sub classes
    }

    func getCellHeight(indexPath: IndexPath) -> CGFloat {
        preconditionFailure("You have to Override getCellHeight Function first to be able to set cell height")
    }

    func getCellsCount(with section: Int) -> Int
    {
        preconditionFailure("You have to Override getCellsCount Function first to be able to set number of cells count")
    }

    func getSectionsCount() -> Int
    {
        preconditionFailure("You have to Override getSectionsCount Function first to be able to set number of sections count")
    }

    func handleSearchWith(searchText: String?) {
        // override this when you need to handle searchText
    }
    
    // MARK: Refresh cotrol
    func setupSwipeRefresh() -> Void {
        refreshControl = UIRefreshControl()

        refreshControl?.tintColor = UIColor.gray
        refreshControl?.addTarget(self, action: #selector(swipeRefreshTableView), for: .valueChanged)
        artistsTableView.addSubview(refreshControl!)
    }

    @objc func swipeRefreshTableView() {
        // override this when you need to refresh table data by swipe
    }

    func endRefreshTableView() -> Void {
        refreshControl?.endRefreshing()
    }
    
    func startRefreshTableView() {
        refreshControl?.beginRefreshing()
    }
    
    func checkRefreshControlState() -> Void {
        DispatchQueue.main.async {
            if (self.refreshControl?.isRefreshing)! {
                self.refreshControl?.endRefreshing()
            }
        }
    }

    //MARK: Pagination
    func setupPagination() -> Void {
        hasPagination = true
    }
    
    
    func handlePaginationRequest() {
        // override this when you need to handlePaginationRequest
    }

    func showLoadingMoreView() -> Void {
        paginationIndicator = UIActivityIndicatorView.init()
        paginationIndicator?.color = UIColor.gray
        paginationIndicator?.sizeToFit()
        paginationIndicator?.isAccessibilityElement = true
        paginationIndicator?.startAnimating()
        artistsTableView.tableFooterView = paginationIndicator
    }

    func removeLoadingMoreView() {
        if paginationIndicator != nil {
            if paginationIndicator!.isDescendant(of: self.view) {
                paginationIndicator?.removeFromSuperview()
                paginationIndicator = nil
            }
        }
    }

}

// MARK: - UITableViewDataSource

extension BaseSearchArtistViewController: UITableViewDataSource {

    // MARK: Height for cell

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getCellHeight(indexPath: indexPath)
    }

    // MARK: Number of Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.getSectionsCount()
    }

    // MARK: Number of rows

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getCellsCount(with: section)
    }


    // MARK: Cell for row

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return getCustomCell(tableView, cellForRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectCellAt(indexPath: indexPath)
    }


    @objc func getCustomCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return UITableViewCell.init()
    }

    @objc func didSelectCellAt(indexPath: IndexPath) {

    }

}

extension BaseSearchArtistViewController: UITableViewDelegate {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == artistsTableView {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
                if (self.hasPagination) {
                    self.handlePaginationRequest()
                }
            }
        }
    }
}
