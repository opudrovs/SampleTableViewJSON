# SampleTableViewJSON
A table view app which receives sample data via custom REST API from my simple Node.js backend.

## Installation

Open SampleTableViewJSON.xcodeproj in the latest release version of Xcode (tested in 7.2.1) and run the app in Simulator or on device.

## Usage

This app demonstrates how to

* load data from a custom REST API and parse it to populate table view cells with title, description, image preview, and publishing date of example blog posts.
* sort posts by title or date in ascending or descending order.
* search(filter) posts in a table view by letter combination in title or description.
* open a complete post in a UIWebView when a table view cell is tapped.
* make UI adjust to all screen sizes with the help of auto layout constraints.
* use best practices and style guides to create easily readable and well-documented code.

## To Do

* add lazy (progressive or on demand) loading of preview images.
* add third-party libraries to demonstrate usage of CocoaPods.
* move JSON parsing to a separate class with data validation.
* add tests (particularly for JSON parsing and data validation).

## History

2016/03/21 - Initial release of the updated sample app.

## Credits

&copy; 2016 Olga Pudrovska
