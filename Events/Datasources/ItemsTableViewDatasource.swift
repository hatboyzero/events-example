//
// Created by Matthew Gray on 4/17/18.
//

import UIKit

protocol ItemsTableViewDatasource: UITableViewDataSource {
    associatedtype T
    var items: [T] {get}
    var tableView: UITableView? {get}
    var delegate: UITableViewDelegate? {get}

    init(items: [T], tableView: UITableView, delegate: UITableViewDelegate)

    func setupTableView();
}

extension ItemsTableViewDatasource {
    func setupTableView() {
        self.tableView?.dataSource = self
        self.tableView?.delegate = self.delegate
        self.tableView?.reloadData()
    }
}
