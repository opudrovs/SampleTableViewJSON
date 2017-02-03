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

    // MARK: - Private Properties

    fileprivate var contentArray: [ContentItem]
    fileprivate var contentFilteredArray: [ContentItem]
    fileprivate var sortOrder: SortOrder
    fileprivate var sortType: SortType
    fileprivate var searchController: UISearchController!

    // MARK: - Initializer

    required init?(coder aDecoder: NSCoder) {
        self.contentArray = [ContentItem]()
        self.contentFilteredArray = [ContentItem]()
        self.sortOrder = .ascending
        self.sortType = .title

        super.init(coder: aDecoder)
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set view title
        self.title = FeedLocalizationKey.posts.localizedString()

        // Show that data is loading
        self.activityIndicator?.startAnimating()
        self.tableView?.isHidden = true

        // Load JSON
        self.refresh()

        // Create navigation bar buttons
        self.createNavBarItems()

        // Create search controller
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self

        if #available(iOS 9.1, *) {
            self.searchController.obscuresBackgroundDuringPresentation = false
        } else {
            self.searchController.dimsBackgroundDuringPresentation = false
        }
        self.definesPresentationContext = true
        self.searchController.searchBar.placeholder = FeedLocalizationKey.searchPlaceholder.localizedString()
        self.searchController.searchBar.tintColor = UIColor.white
        self.searchController.searchBar.barTintColor = UIColor(red: 127.0/255.0, green: 127.0/255.0, blue: 127.0/255.0, alpha: 1.0)

        tableView?.tableHeaderView = self.searchController.searchBar
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchController.isActive && self.searchController.searchBar.text != "" ? self.contentFilteredArray.count : self.contentArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView?.dequeueReusableCell(withIdentifier: FeedTableViewCellIdentifier, for:indexPath) as? FeedTableViewCell else { return UITableViewCell() }

        let content = (self.searchController.isActive && self.searchController.searchBar.text != "") ? self.contentFilteredArray[indexPath.row] : self.contentArray[indexPath.row]

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
        self.sortOrder = (sender as? UISegmentedControl)?.selectedSegmentIndex == 0 ? .ascending : .descending

        self.sortTableView(sortType: self.sortType, sortOrder: self.sortOrder)
    }

    func didPressSortType(_ sender: AnyObject) {
        self.sortType = (sender as? UISegmentedControl)?.selectedSegmentIndex == 0 ? .title : .date

        let alertController = UIAlertController(title: FeedLocalizationKey.sortContentBy.localizedString(), message: nil, preferredStyle: .actionSheet)

        for action in self.sortActions() {
            alertController.addAction(action)
        }

        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ContentItemVCShowSegueIdentifier {
            guard let vc = segue.destination as? ContentItemViewController, let indexPath = self.tableView?.indexPathForSelectedRow else { return }

            let content = (searchController.isActive && searchController.searchBar.text != "") ? contentFilteredArray[indexPath.row] : contentArray[indexPath.row]

            vc.title = content.title
            vc.urlString = content.url
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
        self.contentFilteredArray = self.contentArray.filter { (contentItem: ContentItem) -> Bool in
            return contentItem.title.range(of: searchText, options: NSString.CompareOptions.caseInsensitive) == nil || contentItem.blurb.range(of: searchText, options: NSString.CompareOptions.caseInsensitive) != nil
        }
    }

    // MARK: - Private

    fileprivate func refresh() {
        let provider = DataProvider()
        let parser = JSONParser()

        provider.loadData { [unowned self] data in
            if let content = parser.contentItemsFromResponse(data) {
                self.contentArray = content
            }

            DispatchQueue.main.async {
                self.activityIndicator?.stopAnimating()
                self.tableView?.isHidden = false
                self.sortTableView(sortType: self.sortType, sortOrder: self.sortOrder)
            }
        }
    }

    fileprivate func createNavBarItems() {
        let items: Array = [FeedLocalizationKey.sortOrderAscending.localizedString(), FeedLocalizationKey.sortOrderDescending.localizedString()]

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

    fileprivate func sortActions() -> [UIAlertAction] {
        let cancelAction = UIAlertAction(title: FeedLocalizationKey.sortCancelAction.localizedString(), style: .cancel, handler: nil)

        let sortByTitleAction = UIAlertAction(title: FeedLocalizationKey.sortTypeByTitle.localizedString(), style: .default) { action in
            self.sortType = .title
            self.sortTableView(sortType: self.sortType, sortOrder: self.sortOrder)
        }

        let sortByDateAction = UIAlertAction(title: FeedLocalizationKey.sortTypeByDatePublished.localizedString(), style: .default) { action in
            self.sortType = .date
            self.sortTableView(sortType: self.sortType, sortOrder: self.sortOrder)
        }

        return [cancelAction, sortByTitleAction, sortByDateAction]
    }

    // Sorts content based on sort type and direction and reloads data
    fileprivate func sortTableView(sortType: SortType, sortOrder: SortOrder) {
        switch self.sortType {
        case .title:
            self.contentArray.sort { self.before(lhs: $0.title, rhs: $1.title, sortOrder: self.sortOrder) }
            break
        case .date:
            self.contentArray.sort { self.before(lhs: $0.datePublished, rhs: $1.datePublished, sortOrder: self.sortOrder) }
            break
        }
        
        self.tableView?.reloadData()
    }

    fileprivate func before<T: Comparable>(lhs: T, rhs: T, sortOrder: SortOrder) -> Bool {
        return sortOrder == .ascending ? lhs < rhs : lhs > rhs
    }
}
