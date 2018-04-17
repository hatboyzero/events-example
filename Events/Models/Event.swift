//
// Created by Matthew Gray on 4/17/18.
//

import Foundation
import ObjectMapper

public struct Event {
    var id: String = ""
    var name: String = ""
    var description: String = ""
    var images: [Medium] = []
    var location: Location = Location()
    var date: Date = Date()
    var comments: [Comment] = []
}

extension Event: Mappable {
    public init?(map: Map) {

    }

    public mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        description <- map["description"]
        images <- map["images"]
        location <- map["location"]
        date <- (map["date"], ISO8601DateTransform())
        comments <- map["comments"]
    }
}
