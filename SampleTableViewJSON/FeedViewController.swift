//
//  FeedViewController.swift
//  SampleTableViewJSON
//
//  Created by Olga Pudrovska on 3/28/15.
//  Copyright (c) 2016 Olga Pudrovska. All rights reserved.
//

import UIKit

let ContentItemVCShowSegueIdentifier = "ShowContentItem"

enum SortOrder: Int {
    case ascending = 0
    case descending
}

enum SortType: Int {
    case title = 0
    case date
}

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    static let tableViewRowHeight = CGFloat(120)

    // MARK: - Outlets

    @IBOutlet var activityIndicator: UIActivityIndicatorView?
    @IBOutlet var tableView: UITableView?

    // MARK: - Properties

    var viewData: FeedViewData?

    fileprivate var searchController: UISearchController!

    // MARK: - Initializer

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Show that data is loading
        self.activityIndicator?.startAnimating()
        self.tableView?.isHidden = true
 
        // Load JSON
        self.refresh()

        // Create navigation bar buttons
        self.createNavBarItems()

        // Create search controller
        self.definesPresentationContext = true

        self.searchController = self.createSearchController()
        self.tableView?.tableHeaderView = self.searchController.searchBar
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewData = self.viewData else { return 0 }
        return self.searchController.isActive && self.searchController.searchBar.text != "" ? viewData.filteredContent.count : viewData.content.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView?.dequeueReusableCell(withIdentifier: FeedTableViewCellIdentifier, for:indexPath) as? FeedTableViewCell else { return UITableViewCell() }

        guard let viewData = self.viewData else { return cell }

        let content = (self.searchController.isActive && self.searchController.searchBar.text != "") ? viewData.filteredContent[indexPath.row] : viewData.content[indexPath.row]

        cell.contentTitleLabel?.text = content.title
        cell.contentBlurbLabel?.text = content.blurb
        cell.contentDateLabel?.text = content.dateFormatted
        cell.contentImage?.image = content.image

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FeedViewController.tableViewRowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: ContentItemVCShowSegueIdentifier as String, sender: tableView)

        tableView.deselectRow(at: indexPath, animated: false)
    }

    // MARK: - Event Handlers

    func didPressSortOrder(_ sender: AnyObject) {
        guard var viewData = self.viewData else { return }

        viewData.updateSortOrder(sortOrder: (sender as? UISegmentedControl)?.selectedSegmentIndex == 0 ? .ascending : .descending)

        self.sortTableView(sortType: viewData.sortType, sortOrder: viewData.sortOrder)
    }

    func didPressSortType(_ sender: AnyObject) {
        guard let viewData = self.viewData else { return }

        let alertController = UIAlertController(title: FeedLocalizationKey.sortContentBy.localizedString(), message: nil, preferredStyle: .actionSheet)

        for action in self.sortActions(currentSortType: viewData.sortType) {
            alertController.addAction(action)
        }

        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ContentItemVCShowSegueIdentifier {
            guard let viewData = self.viewData, let vc = segue.destination as? ContentItemViewController, let indexPath = self.tableView?.indexPathForSelectedRow else { return }

            let contentItem = (searchController.isActive && searchController.searchBar.text != "") ? viewData.filteredContent[indexPath.row] : viewData.content[indexPath.row]
            let destinationViewData = ContentItemViewData(content: contentItem)
            vc.viewData = destinationViewData
        }
    }

    // MARK: - UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            self.filterContentForSearchText(searchText)

            self.tableView?.reloadData()
        }
    }

    // MARK: - Search

    fileprivate func filterContentForSearchText(_ searchText: String) {
        self.viewData?.findText(searchText: searchText)
    }

    // MARK: - Private

    func updateWithViewData(viewData: FeedViewData) {
        // Set view title
        self.title = self.viewData?.title ?? ""
    }

    fileprivate func refresh() {
        let provider = DataProvider()
        let parser = JSONParser()

        provider.loadData { [unowned self] data in
            if let content = parser.contentItemsFromResponse(data) {
                self.viewData?.updateContent(content: content)
            }

            DispatchQueue.main.async {
                self.activityIndicator?.stopAnimating()
                self.tableView?.isHidden = false
                if let viewData = self.viewData {
                    self.sortTableView(sortType: viewData.sortType, sortOrder: viewData.sortOrder)
                }
            }
        }
    }

    fileprivate func createNavBarItems() {
        let items = [FeedLocalizationKey.sortOrderAscending.localizedString(), FeedLocalizationKey.sortOrderDescending.localizedString()]

        // create segmented control
        let segmentedControl = UISegmentedControl(items: items)
        // do not sort initially
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(FeedViewController.didPressSortOrder(_:)), for: UIControlEvents.valueChanged)

        // create items
        // asc/desc
        let directionItem: UIBarButtonItem = UIBarButtonItem(customView: segmentedControl)

        // sort
        let sortItem: UIBarButtonItem = UIBarButtonItem(title: FeedLocalizationKey.sort.localizedString(), style: UIBarButtonItemStyle.plain, target: self, action: #selector(FeedViewController.didPressSortType(_:)))

        // add items to bar
        self.navigationItem.setLeftBarButton(directionItem, animated: false)
        self.navigationItem.setRightBarButton(sortItem, animated: false)
    }

    fileprivate func createSearchController() -> UISearchController {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self

        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        } else {
            searchController.dimsBackgroundDuringPresentation = false
        }
        searchController.searchBar.placeholder = FeedLocalizationKey.searchPlaceholder.localizedString()
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor(red: 127.0/255.0, green: 127.0/255.0, blue: 127.0/255.0, alpha: 1.0)
        return searchController
    }

    fileprivate func sortActions(currentSortType: SortType) -> [UIAlertAction] {
        let cancelAction = UIAlertAction(title: FeedLocalizationKey.sortCancelAction.localizedString(), style: .cancel, handler: nil)
        let checkmarkString = " ✔︎"
        let sortByTitleAction = UIAlertAction(title: "\(FeedLocalizationKey.sortTypeByTitle.localizedString())\(currentSortType == .title ? checkmarkString : "")", style: .default) { action in
            self.viewData?.updateSortType(sortType: .title)
            if let viewData = self.viewData {
                self.sortTableView(sortType: viewData.sortType, sortOrder: viewData.sortOrder)
            }
        }

        let sortByDateAction = UIAlertAction(title: "\(FeedLocalizationKey.sortTypeByDatePublished.localizedString())\(currentSortType == .date ? checkmarkString : "")", style: .default) { action in
            if var viewData = self.viewData {
                viewData.updateSortType(sortType: .date)
                self.sortTableView(sortType: viewData.sortType, sortOrder: viewData.sortOrder)
            }
        }

        return [cancelAction, sortByTitleAction, sortByDateAction]
    }

    // Sorts content based on sort type and direction and reloads data
    fileprivate func sortTableView(sortType: SortType, sortOrder: SortOrder) {
        self.viewData?.sortContent(sortType: sortType, sortOrder: sortOrder)
        
        self.tableView?.reloadData()
    }
}
