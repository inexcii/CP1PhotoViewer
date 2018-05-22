//
//  RCValues.swift
//  CP1PhotoViewer
//
//  Created by g.shu on 2018/05/22.
//  Copyright © 2018 Yuan Zhou. All rights reserved.
//

import Foundation
import Firebase

enum ValueKey: String {
    case flickrApiKey
    case imaggaAuthToken
}

/// This class is used to fetch remotely-defined values on Firebase by its RemoteConfig function.
class RCValues {
    
    static let sharedInstance = RCValues()
    
    private init() {
        loadDefaultValues()
        fetchCloudValues()
    }
    
    // MARK: - Internal
    
    func secretInfo(forKey key: ValueKey) -> String {
        return RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? "undefined"
    }
    
    // MARK: - FilePrivate
    
    fileprivate func loadDefaultValues() {
        let appDefaults: [String: Any?] = [
            ValueKey.flickrApiKey.rawValue : "c1a57bdc9b3bfecfa9a92183f7ee13a7",
            ValueKey.imaggaAuthToken.rawValue : "Basic YWNjXzY5NWUzOGE3YzdmZWNjODozMGFkNzc5OGMyNDM4NDI0MGJjMDZlOTU4NTVkNDdjYQ=="
        ]
        RemoteConfig.remoteConfig().setDefaults(appDefaults as? [String: NSObject])
    }
    
    fileprivate func fetchCloudValues() {
        
        // Specify to ensure that the cached data is never used
        // WARNING: This can only be used during development, don't actually do this in production!
        let fetchDuration: TimeInterval = 0
        activateDebugMode()
        
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: fetchDuration) { status, error in
            
            if let error = error {
                print("Got an error fetching remote values \(error)")
                return
            }
            
            RemoteConfig.remoteConfig().activateFetched()
        }
    }
    
    fileprivate func activateDebugMode() {
        RemoteConfig.remoteConfig().configSettings = RemoteConfigSettings(developerModeEnabled: true)
    }
}
