//
//  ImaggaRouter.swift
//  CP1PhotoViewer
//
//  Created by g.shu on 2018/05/19.
//  Copyright © 2018 Yuan Zhou. All rights reserved.
//

import Foundation
import Alamofire

/// An URLRequestConvertible class that is used by Alamofire when retrieving photo tags from Imagga in photo-tags scene.
public enum ImaggaRouter: URLRequestConvertible {
    
    enum Constants {
        static let baseURLPath = "http://api.imagga.com/v1"
        static let authenticationToken = RCValues.sharedInstance.secretInfo(forKey: .imaggaAuthToken)
    }
    
    // Append cases when other services of Imagga become necessary
    case content
    case tags(String)
    
    var method: HTTPMethod {
        switch self {
        case .content:
            return .post
        case .tags:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .content:
            return "/content"
        case .tags:
            return "/tagging"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .tags(let contentID):
            return ["content": contentID]
        default:
            return [:]
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseURLPath.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.setValue(Constants.authenticationToken, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = TimeInterval(10 * 1000)
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
}

