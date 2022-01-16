//
//  ServiceRoot.swift
//  Bind
//
//  Created by Albert Q Park on 1/16/22.
//

import UIKit
import Alamofire

protocol ServiceDelegate: AnyObject {
    func imageLoaded(index: Int)
}

class ServiceRoot {
    var isServiceDirty = true
    weak var delegate: ServiceDelegate?
    
    static let shared = ServiceRoot()
    
    
    
    struct OAuthResponse: Decodable{
        var access_token: String?
    }
    
    let baseURL = "https://api.petfinder.com/v2"
    var oauthBearerToken: String?
    
    private static let oauthBearerTokenKey = "oauthBearerTokenKey"
    
    var dataRoot = DataRoot()
    
    var imageServices = [Request]()
    var imageQueue = [AnimalData]()
    
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
    
    func findPet(depth: Int = 0,_  completion :@escaping (Any?)->()) {
        oAuth { _ in
            
            self.dataRoot.animals.removeAll()
            self.imageServices.removeAll()
            self.imageQueue.removeAll()
            
            AF.request( self.baseURL.appending("/animals")
                        , headers: ["Authorization": "Bearer \(self.oauthBearerToken ?? "" )"]
            )
                .responseString(completionHandler: { (r: AFDataResponse<String>) in
                    print(r)
                })
                .responseDecodable(of: Animals.self) { (r: DataResponse<Animals, AFError>) in
                    if r.response?.statusCode == 401,
                       depth < 2 {
                        self.oauthBearerToken = nil
                        self.findPet(depth:depth + 1, completion)
                        return
                    }
                    let animalDatas = r.value?.animals.map({ (animal:Animal) in
                        AnimalData(animal)
                    })
                    
                    self.dataRoot.animals.append(contentsOf: animalDatas ?? [] )
                    self.imageQueue.append(contentsOf: animalDatas?.reversed() ?? [])
                    self.loadMainImages()
                    completion(r)
                    
                }
        }
    }
    
    func loadMainImages() {
        let maxWindow = 5
        while imageServices.count < maxWindow,
              imageQueue.count > 0 {
            let animal = imageQueue.popLast()
            let imageURL = animal?.animal.photos.first?["small"] ?? animal?.animal.photos.first?.values.first
            if animal != nil,
               let imageURL = imageURL {
                let request = AF.request(imageURL)
                request.responseData { (imageData: AFDataResponse<Data>) in
                    self.imageServices.removeAll {
                        return $0 == request
                    }
                    self.loadMainImages()
                    
                    guard let data = imageData.value,
                          let image = UIImage(data: data) else {
                        return
                    }
                    animal?.mainImage = image.resizableImage(withCapInsets: UIEdgeInsets.zero)
                    if let index = self.dataRoot.animals.firstIndex(where: { $0 === animal }) {
                        self.delegate?.imageLoaded(index: index)
                    }
                }
                imageServices.append(request)
            }
        }
    }
    
    func getBigImage(_ animal: AnimalData, completion:@escaping ([UIImage])->() ) {
        var counter = animal.animal.photos.count
        var images = [UIImage]()
        for image in animal.animal.photos {
            let url = image["full"] ?? image.values.first
            if let url = url {
                AF.request(url).responseData { (data: AFDataResponse<Data>) in
                    counter = counter - 1
                    if let imageData = data.value,
                       let image = UIImage(data: imageData) {
                        images.append(image)
                        animal.morePhotos.append(image)
                    }
                    if counter == 0 {
                        completion(images)
                    }
                }
            }
        }
    }
}
