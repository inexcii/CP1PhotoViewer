//
//  FlickrRouter.swift
//  CP1PhotoViewer
//
//  Created by g.shu on 2018/05/19.
//  Copyright © 2018 Yuan Zhou. All rights reserved.
//

import Foundation
import Alamofire

/// An URLRequestConvertible class that is used by Alamofire when getting photos from Flickr in photo viewer.
public enum FlickrRouter: URLRequestConvertible {
    
    enum Constants {
        static let baseURLPath = "https://api.flickr.com/services"
        static let apiKey = "c1a57bdc9b3bfecfa9a92183f7ee13a7"
    }
    
    // REST reqeust format, append cases if other formats are needed(i.e. SOAP)
    case rest
    
    var method: HTTPMethod {
        switch self {
        case .rest:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .rest:
            return "/rest"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .rest:
            return ["method": "flickr.interestingness.getList",
                    "api_key": Constants.apiKey,
                    "format": "json",
                    "nojsoncallback": "1",
                    "extras": "url_q, url_z"
            ]
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseURLPath.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10 * 1000)
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
