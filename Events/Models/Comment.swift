//
// Created by Matthew Gray on 4/17/18.
//

import Foundation
import ObjectMapper

public struct Comment {
    var from: String = ""
    var text: String = ""
}

extension Comment: Mappable {
    public init?(map: Map) {

    }

    public mutating func mapping(map: Map) {
        from <- map["from"]
        text <- map["text"]
    }
}
