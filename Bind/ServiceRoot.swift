//
//  ServiceRoot.swift
//  Bind
//
//  Created by Albert Q Park on 1/16/22.
//

import UIKit
import Alamofire

class ServiceRoot {
    struct OAuthResponse: Decodable{
        var access_token: String?
    }
    
    let baseURL = "https://api.petfinder.com/v2"
    var oauthBearerToken: String?
    
    private static let oauthBearerTokenKey = "oauthBearerTokenKey"
    
    init() {
        oauthBearerToken = UserDefaults.standard.object(forKey: ServiceRoot.oauthBearerTokenKey) as? String
    }

    func oAuthNew(_  completion :@escaping (Any?)->()) {
        AF.request( baseURL.appending("/oauth2/token"),
                    method: .post,
                    parameters:["grant_type": "client_credentials",
                                "client_id": "g7oFvMiyusBbGl6PskxIKM3gMCGu9XjqA5MVvA02DpsgjNhuDX",
                                "client_secret": "Cw6FdfiAMI41B3TJXw2T94PA9dGi5m3sLOWCZjjw",
                               ],
                    headers: ["Accept": "application/json",
                             ]
        )
            .responseDecodable(of:OAuthResponse.self){ (a) in
                let token = a.value?.access_token
                self.oauthBearerToken = token
                UserDefaults.standard.set(token, forKey: ServiceRoot.oauthBearerTokenKey)
                completion(a.value)
            }

    }
    
    func oAuth(_  completion :@escaping (Any?)->()) {
        //TODO: some more things todo like expiration comming... but thats mroe then 2 hour task :D
        guard oauthBearerToken == nil else {
            completion(nil)
            return
        }
        oAuthNew { a in
            completion(a)
        }
    }
    
    func findPet(_  completion :@escaping (Any?)->()) {
        oAuth { _ in
            AF.request( self.baseURL.appending("/animals")
                        , headers: ["Authorization": "Bearer \(self.oauthBearerToken ?? "" )"]
            )
                .responseDecodable(of: Animals.self) { (r: DataResponse<Animals, AFError>) in
                    completion(r)
                }
        }
    }
}
