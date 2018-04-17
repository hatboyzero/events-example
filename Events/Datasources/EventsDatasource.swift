//
// Created by Matthew Gray on 4/17/18.
//

import Foundation
import UIKit

final class EventsTableDatasource: NSObject, ItemsTableViewDatasource {

    var items: [Event] = []
    weak var tableView: UITableView?
    weak var delegate: UITableViewDelegate?

    required init(items: [Event], tableView: UITableView, delegate: UITableViewDelegate) {
        self.items = items
        self.tableView = tableView
        self.delegate = delegate

        super.init()

        tableView.register(cellType: EventTableCell.self)

        self.setupTableView()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: EventTableCell.self)
        let item = self.items[indexPath.row]
        cell.setup(item: item)
        return cell
    }
}

protocol EventsDelegate {
    func didSelectEvent(at index: IndexPath)
}

class EventsTableDelegate: NSObject, UITableViewDelegate {

    let delegate: EventsDelegate

    init(_ delegate: EventsDelegate) {
        self.delegate = delegate
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return EventTableCell.height()
//    }
//
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.didSelectEvent(at: indexPath)
    }
}