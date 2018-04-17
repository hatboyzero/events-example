//
// Created by Matthew Gray on 4/17/18.
//

import Foundation
import ObjectMapper

public struct Location {
    var name: String = ""
    var address: String = ""
    var city: String = ""
    var state: String = ""
}

extension Location: Mappable {
    public init?(map: Map) {

    }

    public mutating func mapping(map: Map) {
        name <- map["name"]
        address <- map["address"]
        city <- map["city"]
        state <- map["state"]
    }
}
