//
//  YouTubeAPI.swift
//  YouTubeAPI
//
//  Created by Shlykov Danylo on 6/16/20.
//  Copyright © 2020 Shlykov Danylo. All rights reserved.
//

import Moya

typealias JSON = [String: Any]

enum BackendAPI {
    class BaseApi {
        typealias OnErrorCompletion = (_ errorMessage: String) -> Void
        
        var request: Cancellable?
        
        static func handleResult(_ result: Result<Response, MoyaError>,
                                 onSuccess: (JSON) -> Void,
                                 onError: OnErrorCompletion) {
            switch result {
            case let .success(moyaResponse):
                do {
                    _ = try moyaResponse.filterSuccessfulStatusCodes()
                    let jsonAny = try moyaResponse.mapJSON()
                    
                    if let json = jsonAny as? JSON {
                        onSuccess(json)
                    }
                } catch {
                    onError(error.localizedDescription)
                }
            case let .failure(error):
                print(error)
                onError(error.localizedDescription)
            }
        }
        
        static func mapResult<T: Decodable>(_ result: Result<Response, MoyaError>,
                                            intoItemOfType: T.Type,
                                            onSuccess: (T) -> Void,
                                            onError: OnErrorCompletion) {
            
            switch result {
            case let .success(moyaResponse):
                do {
                    print(moyaResponse.response?.url)
                    print(try moyaResponse.mapJSON())
                    _ = try moyaResponse.filterSuccessfulStatusCodes()
                    let data = moyaResponse.data
                    let jsonDecoder = JSONDecoder()
                    
                    jsonDecoder.dateDecodingStrategy = .custom { decoder in
                        let container = try decoder.singleValueContainer()
                        let dateString = try container.decode(String.self)
                        
                        if let date = DateFormatter.europeKyiwFull.date(from: dateString) {
                            return date
                        }
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        
                        if let date = formatter.date(from: dateString) {
                            return date
                        }
                    
                        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
                    }
                    
                    let result = try jsonDecoder.decode(T.self, from: data)
                    onSuccess(result)
                } catch {
                    print(error)
                    onError(error.localizedDescription)
                }
            case let .failure(error):
                print(error)
                onError(error.localizedDescription)
            }
        }
        
        deinit {
            request?.cancel()
        }
    }
    
    class BaseTokenApi: BaseApi {
        let token: String
        
        init(token: String) {
            self.token = token
        }
    }
    
}
