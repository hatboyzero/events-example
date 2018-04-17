//
// Created by Matthew Gray on 4/17/18.
//

import ImageSlideshow

public class ApiImageSource: NSObject, InputSource {
    var apiManager: EventsApiCalls = EventsApiManager()

    public var event: Event
    public var medium: Medium
    public var placeholder: UIImage?

    public init(event: Event, medium: Medium, placeholder: UIImage? = nil) {
        self.event = event
        self.medium = medium
        self.placeholder = placeholder
        super.init()
    }

    @objc public func load(to imageView: UIImageView, with callback: @escaping (UIImage?) -> Void) {
        apiManager.getMedia(event: event, medium: self.medium) {
            image, error in
            imageView.image = image
            callback(image)
        }
    }
}
