//
// Created by Matthew Gray on 4/17/18.
//

import UIKit
import Reusable

final class EventTableCell: UITableViewCell, NibReusable {
    var apiManager: EventsApiCalls = EventsApiManager()

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!

    func setup(item: Event) {
        self.name.text = item.name
        self.eventDescription.text = item.description
        self.location.text = item.location.name

        // TODO Display previously cached image for event.
        self.thumbnail.image = nil
        if let medium = item.images.first {
            apiManager.getMedia(event: item, medium: medium) {
                image, error in
                if let image = image {
                    self.thumbnail.image = image
                    return
                }

                // TODO Display previously cached or placeholder or error image.
                self.thumbnail.image = nil
            }
        } else {
            // TODO Display a previously cached or placeholder image.
            self.thumbnail.image = nil
        }
    }
}
