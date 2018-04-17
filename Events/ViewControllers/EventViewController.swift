//
// Created by Matthew Gray on 4/17/18.
//

import UIKit
import ImageSlideshow

final class EventViewController: UIViewController {
    var apiManager: EventsApiCalls = EventsApiManager()

    var tableDatasource: CommentsTableDatasource?
    var tableDelegate: CommentsTableDelegate?

    var event: Event = Event()
    var fetchInProgress: Bool = false

    @IBOutlet weak var slideshow: ImageSlideshow!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var locationAddress: UILabel!
    @IBOutlet weak var locationCity: UILabel!
    @IBOutlet weak var locationState: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var goingButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var refreshControl: UIRefreshControl!
    
    @IBAction func goingButtonTapped(_ sender: Any) {
        self.goingButton.isSelected = !self.goingButton.isSelected
        let status = Status(coming: self.goingButton.isSelected)
        self.activityIndicator.startAnimating()
        apiManager.setEventStatus(event: event, status: status) {
            success, error in
            self.refreshData()
        }
    }
}

extension EventViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.scrollView.addSubview(refreshControl)

        self.name.text = self.event.name
        self.eventDescription.text = self.event.description
        self.locationName.text = self.event.location.name
        self.locationAddress.text = self.event.location.address
        self.locationCity.text = self.event.location.city
        self.locationState.text = self.event.location.state
        self.slideshow.setImageInputs((self.event.images).map { ApiImageSource(event: self.event, medium: $0) })

        setupCommentsTableView(with: self.event.comments)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.goingButton.isSelected = false
        refreshData()
        self.title = "Event"
    }
}

extension EventViewController {
    @objc func refreshData() {
        fetchData()
    }

    func fetchData() {
        if !fetchInProgress {
            fetchInProgress = true
            activityIndicator.startAnimating()
            apiManager.getEventStatus(event: self.event) {
                status, error in
                self.activityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
                self.fetchInProgress = false
                guard let status = status else {
                    self.goingButton.isSelected = false
                    return
                }

                self.goingButton.isSelected = status.coming
            }
        }
    }

    func setupCommentsTableView(with data: [Comment]) {
        commentsTableView.isHidden = false
        tableDelegate = CommentsTableDelegate(self)
        tableDatasource = CommentsTableDatasource(items: data, tableView: self.commentsTableView, delegate: tableDelegate!)
    }
}

extension EventViewController: CommentsDelegate {
    func didSelectComment(at index: IndexPath) {
        // TODO Handle comment selection.
    }
}
