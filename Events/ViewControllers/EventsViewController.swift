//
// Created by Matthew Gray on 4/17/18.
//

import UIKit

final class EventsViewController: UIViewController {
    var apiManager: EventsApiCalls = EventsApiManager()

    var tableDatasource: EventsTableDatasource?
    var tableDelegate: EventsTableDelegate?

    var events: [Event] = []
    var fetchInProgress: Bool = false

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!

    var refreshControl: UIRefreshControl!
}

extension EventsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.addSubview(refreshControl)

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 350
        setupTableView(with: events)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refreshData()

        self.title = "Events"
    }
}

extension EventsViewController {
    @objc func refreshData() {
        self.events = []
        tableView.isHidden = true
        fetchData()
    }

    func fetchData() {
        if !fetchInProgress {
            fetchInProgress = true
            activityIndicator.startAnimating()
            apiManager.listEvents {
                items, error in
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
                if let items = items {
                    self.setupTableView(with: items)
                }

                self.fetchInProgress = false
            }
        }
    }

    func setupTableView(with data: [Event]) {
        self.events = data
        tableView.isHidden = false
        tableDelegate = EventsTableDelegate(self)
        tableDatasource = EventsTableDatasource(items: data, tableView: self.tableView, delegate: tableDelegate!)
    }
}

extension EventsViewController: EventsDelegate {
    func didSelectEvent(at index: IndexPath) {
        guard let nextController = StoryboardScene.Main.eventViewController.instantiate() as? EventViewController else {
            return
        }

        self.tableView.deselectRow(at: index, animated: true)
        let event = self.events[index.row]
        nextController.event = event
        self.navigationController?.pushViewController(nextController, animated: true)
    }
}