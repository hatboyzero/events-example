//
// Created by Matthew Gray on 4/17/18.
//

import Foundation
import ObjectMapper

public struct Medium {
    var id: String = ""
    var caption: String = ""
}

extension Medium: Mappable {
    public init?(map: Map) {

    }

    public mutating func mapping(map: Map) {
        id <- map["id"]
        caption <- map["caption"]
    }
}
