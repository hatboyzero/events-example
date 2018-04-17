//
// Created by Matthew Gray on 4/17/18.
//

import Foundation
import Moya
import RxSwift
import ObjectMapper
import Moya_ObjectMapper

extension Response {
    func removeAPIWrappers() -> Response {
        guard let json = try? self.mapJSON() as? [[String:AnyObject]],
              let newData = try? JSONSerialization.data(withJSONObject: json as Any, options: .prettyPrinted) else {
            return self
        }

        let newResponse = Response(
                statusCode: self.statusCode,
                data: newData,
                response: self.response)

        return newResponse
    }
}

struct EventsApiManager {
    let provider = MoyaProvider<EventsApi>(plugins: [CredentialsPlugin {
        _ -> URLCredential? in
        return URLCredential(user: "testuser", password: "evalpass", persistence: .none)
    }])

    let disposeBag = DisposeBag()

    init() {
    }
}

extension EventsApiManager {
    typealias AdditionalStepsAction = (() -> ())

    fileprivate func request(_ token: EventsApi,
                             completion: @escaping (Bool, Error?) -> Void,
                             additionalSteps: AdditionalStepsAction? = nil) {
        provider.rx.request(token)
                .debug()
                .subscribe { event -> Void in
                    switch event {
                        case .success(let response):
                            do {
                                try response.filterSuccessfulStatusCodes()
                                completion(true, nil)
                                additionalSteps?()
                            } catch {
                                if let error = error as? MoyaError {
                                    completion(false, error)
                                } else {
                                    completion(false, nil)
                                }
                            }

                        case .error(let error):
                            completion(false, error)

                        default:
                            break
                    }
                }.addDisposableTo(disposeBag)
    }

    fileprivate func requestObject<T: Mappable>(_ token: EventsApi,
                                                type: T.Type,
                                                completion: @escaping (T?, Error?) -> Void,
                                                additionalSteps: AdditionalStepsAction? = nil) {
        provider.rx.request(token)
                .debug()
                .subscribe { event -> Void in
                    switch event {
                        case .success(let response):
                            do {
                                try response.filterSuccessfulStatusCodes()
                                let parsedObject = try response.mapObject(T.self)
                                completion(parsedObject, nil)
                                additionalSteps?()
                            } catch {
                                if let error = error as? MoyaError {
                                    completion(nil, error)
                                }
                            }

                        case .error(let error):
                            completion(nil, error)

                        default:
                            break
                    }
                }.addDisposableTo(disposeBag)
    }

    fileprivate func requestArray<T: Mappable>(_ token: EventsApi,
                                               type: T.Type,
                                               completion: @escaping ([T]?, Error?) -> Void,
                                               additionalSteps: AdditionalStepsAction? = nil) {
        provider.rx.request(token)
                .debug()
                .subscribe { event -> Void in
                    switch event {
                        case .success(let response):
                            do {
                                try response.filterSuccessfulStatusCodes()
                                let items = try response.mapArray(T.self)
                                completion(items, nil)
                                additionalSteps?()
                            } catch {
                                if let error = error as? MoyaError {
                                    completion(nil, error)
                                }
                            }

                        case .error(let error):
                            completion(nil, error)

                        default:
                            break
                    }
                }.addDisposableTo(disposeBag)
    }

    fileprivate func requestImage(_ token: EventsApi,
                                  completion: @escaping (UIImage?, Error?) -> Void,
                                  additionalSteps: AdditionalStepsAction? = nil) {
        provider.rx.request(token)
                .debug()
                .subscribe { event -> Void in
                    switch event {
                        case .success(let response):
                            do {
                                try response.filterSuccessfulStatusCodes()
                                let image = UIImage(data: response.data)
                                completion(image, nil)
                                additionalSteps?()
                            } catch {
                                if let error = error as? MoyaError {
                                    completion(nil, error)
                                }
                            }

                        case .error(let error):
                            completion(nil, error)

                        default:
                            break
                    }
                }
    }
}

public protocol EventsApiCalls {
    func listEvents(completion: @escaping ([Event]?, Error?) -> Void)
    func getMedia(event: Event, medium: Medium, completion: @escaping (UIImage?, Error?) -> Void)
    func getEventStatus(event: Event, completion: @escaping (Status?, Error?) -> Void)
    func setEventStatus(event: Event, status: Status, completion: @escaping (Bool, Error?) -> Void)
}

extension EventsApiManager: EventsApiCalls {

    func listEvents(completion: @escaping ([Event]?, Error?) -> Void) {
        requestArray(
                .list_events,
                type: Event.self,
                completion: completion)
    }

    func getMedia(event: Event, medium: Medium, completion: @escaping (UIImage?, Error?) -> Void) {
        requestImage(
                .get_media(event, medium),
                completion: completion)
    }

    func getEventStatus(event: Event, completion: @escaping (Status?, Error?) -> Void) {
        requestObject(
                .get_event_status(event, "testuser"),
                type: Status.self,
                completion: completion)
    }

    func setEventStatus(event: Event, status: Status, completion: @escaping (Bool, Error?) -> Void) {
        request(
                .set_event_status(event, "testuser", status),
                completion: completion)
    }
}