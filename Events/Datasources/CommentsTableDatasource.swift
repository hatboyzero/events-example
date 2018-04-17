//
// Created by Matthew Gray on 4/17/18.
//

import Foundation
import UIKit

final class CommentsTableDatasource: NSObject, ItemsTableViewDatasource {

    var items: [Comment] = []
    weak var tableView: UITableView?
    weak var delegate: UITableViewDelegate?

    required init(items: [Comment], tableView: UITableView, delegate: UITableViewDelegate) {
        self.items = items
        self.tableView = tableView
        self.delegate = delegate

        super.init()

        tableView.register(cellType: CommentTableCell.self)

        self.setupTableView()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CommentTableCell.self)
        let item = self.items[indexPath.row]
        cell.setup(item: item)
        return cell
    }
}

protocol CommentsDelegate {
    func didSelectComment(at index: IndexPath)
}

class CommentsTableDelegate: NSObject, UITableViewDelegate {

    let delegate: CommentsDelegate

    init(_ delegate: CommentsDelegate) {
        self.delegate = delegate
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.didSelectComment(at: indexPath)
    }
}