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
    case descending = 1
}

enum SortType: Int {
    case title = 0
    case date = 1
}

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UIActionSheetDelegate {

    // MARK: - Outlets

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Private properties

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

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set view title
        self.title = "Posts"

        // Load JSON

        self.activityIndicator.startAnimating()
        self.tableView.isHidden = true

        self.refresh()

        // Create navigation bar buttons
        createNavBarItems()

        // Create search controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self

        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        } else {
            searchController.dimsBackgroundDuringPresentation = false
        }
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search content..."
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor(red: 127.0/255.0, green:
        127.0/255.0, blue: 127.0/255.0, alpha: 1.0)

        tableView.tableHeaderView = searchController.searchBar
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return self.contentFilteredArray.count
        } else {
            return self.contentArray.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: FeedTableViewCellIdentifier, for:indexPath) as? FeedTableViewCell {

            let content = (searchController.isActive && searchController.searchBar.text != "") ? contentFilteredArray[indexPath.row] : contentArray[indexPath.row]

            cell.contentTitleLabel?.text = content.title
            cell.contentBlurbLabel?.text = content.blurb
            cell.contentDateLabel?.text = content.dateFormatted
            cell.contentImage?.image = content.image

            return cell
        }

        return UITableViewCell()
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: ContentItemVCShowSegueIdentifier as String, sender: tableView)

        tableView.deselectRow(at: indexPath, animated: false)
    }

    // MARK: - UIActionSheetDelegate

    func actionSheet(_ actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex != 0 {
            sortType = SortType(rawValue: buttonIndex - 1)!

            // perform the actual sort
            sortTableView()
        }
    }

    // MARK: - Event handlers

    func didPressSortOrder(_ sender: AnyObject) {
        if (sender as? UISegmentedControl)?.selectedSegmentIndex == 0 {
            sortOrder = .ascending
        } else {
            sortOrder = .descending
        }

        // perform the actual sort
        sortTableView()
    }

    func didPressSortType(_ sender: AnyObject) {
        if (sender as? UISegmentedControl)?.selectedSegmentIndex == 0 {
            sortType = .title
        } else {
            sortType = .date
        }

        let actionSheet = UIActionSheet(title: "Sort content by", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Title", "Date Published")

        actionSheet.show(in: self.view)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ContentItemVCShowSegueIdentifier {
            if let vc = segue.destination as? ContentItemViewController, let indexPath = self.tableView.indexPathForSelectedRow {

                let content = (searchController.isActive && searchController.searchBar.text != "") ? contentFilteredArray[indexPath.row] : contentArray[indexPath.row]

                vc.title = content.title
                vc.urlString = content.url
            }
        }
    }

    // MARK: - Private methods

    func refresh() {
        let provider = DataProvider()
        let parser = JSONParser()

        provider.loadData { [unowned self] data in
            if let content = parser.contentItemsFromResponse(data) {
                self.contentArray = content
            }

            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.isHidden = false
                self.sortTableView()
            }
        }
    }

    fileprivate func createNavBarItems() {

        let items: Array = ["Asc", "Desc"]

        // create segmented control
        let segmentedControl = UISegmentedControl(items: items)
        // do not sort initially
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(FeedViewController.didPressSortOrder(_:)), for: UIControlEvents.valueChanged)

        // create items
        // asc/desc
        let directionItem: UIBarButtonItem = UIBarButtonItem(customView: segmentedControl)

        // sort
        let sortItem: UIBarButtonItem = UIBarButtonItem(title: "Sort", style: UIBarButtonItemStyle.plain, target: self, action: #selector(FeedViewController.didPressSortType(_:)))

        // add items to bar
        self.navigationItem.setLeftBarButton(directionItem, animated: false)
        self.navigationItem.setRightBarButton(sortItem, animated: false)
    }

    fileprivate func sortTableView() {
        // sort based on sort direction and type

        switch sortType {
        case .title:
            if sortOrder == .ascending {
                contentArray.sort {
                    $0.title < $1.title
                }
            } else {
                contentArray.sort {
                    $0.title > $1.title
                }
            }
            break

        case .date:
            if sortOrder == .descending {
                contentArray.sort {
                    $0.datePublished > $1.datePublished
                }
            } else {
                contentArray.sort {
                    $0.datePublished < $1.datePublished
                }
            }
            break
        }

        tableView.reloadData()
    }

    // MARK: - UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContentForSearchText(searchText)

            tableView.reloadData()
        }
    }

    // MARK: - Search

    fileprivate func filterContentForSearchText(_ searchText: String) {
        // Filter the array using the filter method
        contentFilteredArray = contentArray.filter({( contentItem: ContentItem) -> Bool in
            let titleMatch = contentItem.title.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            let blurbMatch = contentItem.blurb.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)

            return titleMatch != nil || blurbMatch != nil
        })
    }
}
