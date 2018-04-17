//
// Created by Matthew Gray on 4/17/18.
//

import UIKit
import Reusable

final class CommentTableCell: UITableViewCell, NibReusable {
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var commentText: UILabel!

    func setup(item: Comment) {
        self.from.text = item.from
        self.commentText.text = item.text
    }
}
