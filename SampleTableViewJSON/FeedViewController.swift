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
    case Ascending = 0
    case Descending = 1
}

enum SortType: Int {
    case Title = 0
    case Date = 1
}

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UIActionSheetDelegate {

    // MARK: - Outlets

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Private properties

    private var contentArray: [ContentItem]
    private var contentFilteredArray: [ContentItem]
    private var sortOrder: SortOrder
    private var sortType: SortType
    private var searchController: UISearchController!

    // MARK: - Initializer

    required init?(coder aDecoder: NSCoder) {
        self.contentArray = [ContentItem]()
        self.contentFilteredArray = [ContentItem]()
        self.sortOrder = .Ascending
        self.sortType = .Title

        super.init(coder: aDecoder)
    }

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set view title
        self.title = "Posts"

        // Load JSON

        loadData()

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
        searchController.searchBar.tintColor = UIColor.whiteColor()
        searchController.searchBar.barTintColor = UIColor(red: 127.0/255.0, green:
        127.0/255.0, blue: 127.0/255.0, alpha: 1.0)

        tableView.tableHeaderView = searchController.searchBar
    }

    // MARK: - UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return self.contentFilteredArray.count
        } else {
            return self.contentArray.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCellWithIdentifier(FeedTableViewCellIdentifier, forIndexPath:indexPath) as? FeedTableViewCell {

            let content = (searchController.active && searchController.searchBar.text != "") ? contentFilteredArray[indexPath.row] : contentArray[indexPath.row]

            cell.contentTitleLabel.text = content.title
            cell.contentBlurbLabel.text = content.blurb
            cell.contentDateLabel.text = content.dateFormatted
            cell.contentImage.image = content.image

            return cell
        }

        return UITableViewCell()
    }

    // MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(ContentItemVCShowSegueIdentifier as String, sender: tableView)

        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }

    // MARK: - UIActionSheetDelegate

    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex != 0 {
            sortType = SortType(rawValue: buttonIndex - 1)!

            // perform the actual sort
            sortTableView()
        }
    }

    // MARK: - Event handlers

    func didPressSortOrder(sender: AnyObject) {
        if (sender as? UISegmentedControl)?.selectedSegmentIndex == 0 {
            sortOrder = .Ascending
        } else {
            sortOrder = .Descending
        }

        // perform the actual sort
        sortTableView()
    }

    func didPressSortType(sender: AnyObject) {
        if (sender as? UISegmentedControl)?.selectedSegmentIndex == 0 {
            sortType = .Title
        } else {
            sortType = .Date
        }

        let actionSheet = UIActionSheet(title: "Sort content by", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Title", "Date Posted")

        actionSheet.showInView(self.view)
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ContentItemVCShowSegueIdentifier {
            if let vc = segue.destinationViewController as? ContentItemViewController, indexPath = self.tableView.indexPathForSelectedRow {

                let content = (searchController.active && searchController.searchBar.text != "") ? contentFilteredArray[indexPath.row] : contentArray[indexPath.row]

                vc.title = content.title
                vc.urlString = content.url
            }
        }
    }

    // MARK: - Private methods

    private func loadData() {
        let url = NSURL(string: "http://olgapudrovska.com:8091/sampledata/posts")!
        let request = NSURLRequest(URL: url)
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in

            if let error = error {
                print(error)
                return
            }

            // If data is loaded successfully, parse it
            do {
                // Parse data
                if let tempContent = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? [NSDictionary] {
                    for item in tempContent {
                        self.contentArray.append(ContentItem(json: item as NSDictionary))
                    }

                    // Sort tableView initially
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.activityIndicator.stopAnimating()
                        self.tableView.hidden = false
                        self.sortTableView()
                    })
                }
            } catch {
                print(error)
            }
        })

        task.resume()
    }

    private func createNavBarItems() {

        let items: Array = ["Asc", "Desc"]

        // create segmented control
        let segmentedControl = UISegmentedControl(items: items)
        // do not sort initially
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: "didPressSortOrder:", forControlEvents: UIControlEvents.ValueChanged)

        // create items
        // asc/desc
        let directionItem: UIBarButtonItem = UIBarButtonItem(customView: segmentedControl)

        // sort
        let sortItem: UIBarButtonItem = UIBarButtonItem(title: "Sort", style: UIBarButtonItemStyle.Plain, target: self, action: "didPressSortType:")

        // add items to bar
        self.navigationItem.setLeftBarButtonItem(directionItem, animated: false)
        self.navigationItem.setRightBarButtonItem(sortItem, animated: false)
    }

    private func sortTableView() {
        // sort based on sort direction and type

        switch sortType {
        case .Title:
            if sortOrder == .Ascending {
                contentArray.sortInPlace {
                    $0.title < $1.title
                }
            } else {
                contentArray.sortInPlace {
                    $0.title > $1.title
                }
            }
            break

        case .Date:
            if sortOrder == .Descending {
                contentArray.sortInPlace {
                    $0.datePublished > $1.datePublished
                }
            } else {
                contentArray.sortInPlace {
                    $0.datePublished < $1.datePublished
                }
            }
            break
        }

        tableView.reloadData()
    }

    // MARK: - UISearchResultsUpdating

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContentForSearchText(searchText)

            tableView.reloadData()
        }
    }

    // MARK: - Search

    private func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        contentFilteredArray = contentArray.filter({( contentItem: ContentItem) -> Bool in
            let titleMatch = contentItem.title?.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            let blurbMatch = contentItem.blurb?.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)

            return titleMatch != nil || blurbMatch != nil
        })
    }
}
