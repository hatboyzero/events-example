//
// Created by Matthew Gray on 4/17/18.
//

import Foundation
import Moya
import Dollar
import Alamofire
import ObjectMapper

enum EventsApi {
    case list_events
    case get_media(Event, Medium)
    case get_event_status(Event, String)
    case set_event_status(Event, String, Status)
}

extension EventsApi: TargetType {
    var baseURL: URL {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {

            if let dic = NSDictionary(contentsOfFile: path) as? [String: Any] {
                if let appAttrs = dic["ApplicationAttributes"] as? [String: Any] {
                    if let baseUrl = appAttrs["BaseUrl"] as? String {
                        return URL(string: baseUrl)!
                    }
                }
            }
        }

        return URL(string: "http://dev.dragonflyathletics.com:1337/api/dfkey/")!
    }

    var path: String {
        switch self {
            case .list_events:
                return "/events"

            case .get_media(let event, let medium):
                return "/events/\(event.id)/media/\(medium.id)"

            case .get_event_status(let event, let username):
                return "/events/\(event.id)/status/\(username)"

            case .set_event_status(let event, let username, _):
                return "/events/\(event.id)/status/\(username)"
        }
    }

    var method: Moya.Method {
        switch self {
            case .list_events:
                return .get

            case .get_media:
                return .get

            case .get_event_status:
                return .get

            case .set_event_status:
                return .put
        }
    }

    var task: Task {
        switch self {
            case .list_events:
                return .requestPlain

            case .get_media:
                return .requestPlain

            case .get_event_status:
                return .requestPlain

            case .set_event_status(_, _, let status):
                return .requestData(status.toJSONString()!.data(using: String.Encoding.utf8)!)
        }
    }

    var sampleData: Data {
        switch self {
            default:
                return Data()
        }
    }

    var headers: [String: String]? {
        return nil
    }
}

