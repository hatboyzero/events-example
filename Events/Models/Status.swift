//
// Created by Matthew Gray on 4/17/18.
//

import Foundation
import ObjectMapper

public struct Status {
    var coming: Bool = false
}

extension Status: Mappable {
    public init?(map: Map) {

    }

    public mutating func mapping(map: Map) {
        coming <- map["coming"]
    }
}
