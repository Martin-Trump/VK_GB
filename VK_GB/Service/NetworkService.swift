//
//  NetworkService.swift
//  VK_GB
//
//  Created by Павел Шатунов on 15.08.2022.
//

import Foundation
import Alamofire
import RealmSwift

class NetworkService {
    private let cliendId = "51446605"
    private let apiVer: String = "5.131"
    
    private var urlConstructor = URLComponents()
    private let configuration: URLSessionConfiguration!
    private let session: URLSession!
    
    init() {
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)
        
    }
    
    func authorize () -> URLRequest? {
        urlConstructor.host = "oauth.vk.com"
        urlConstructor.path = "/authorize"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "client_id", value: cliendId),
            URLQueryItem(name: "scope", value: "friends,groups,photos,wall"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: apiVer)
           ]
            guard let url = urlConstructor.url else {return nil}
            let request = URLRequest(url: url)
            return request
    }
    

    func loadImage(url: String, onComplete: @escaping (_ image: UIImage?, _ error: Error?) -> Void ) {
        AF.request(url, method: .get).responseData { dataResponse in
            guard let imageData = dataResponse.data else {
                print(dataResponse.error!.localizedDescription)
                return
            }
            let image = UIImage(data: imageData, scale: 1.0)
            onComplete(image, nil)
        }
    }
    
    
    func getCommunities(completion: @escaping (([Group])-> Void)) -> Void {
        urlConstructor.path = "/method/groups.get"
        let parameters: Parameters = [
            "extended" : "1",
            "fields" :"description",
            "access_token" : Session.shared.token!,
            "v" : apiVer
        ]
        AF.request(urlConstructor.url!, method: .get, parameters: parameters).responseData { response in
            guard let data = response.data else {
                print(response.error!.localizedDescription)
                return
            }
            guard let communities = try! JSONDecoder().decode(Response<Group>?.self, from: data)?.response.items else {
                print("response.error?.localizedDescription")
                return
            }
            DispatchQueue.main.async {
                completion(communities)
            }
        }
    }

    func getFriends(completion: @escaping ([Friend]) -> Void) -> Void {
        urlConstructor.path = "/method/friends.get"
        let parameters: Parameters = [
            "order" : "hints",
            "fields" :"sex, bdate, city, country, photo_100, photo_200_orig",
            "access_token" : Session.shared.token!,
            "v" : apiVer
        ]

        AF.request(urlConstructor.url!, method: .get, parameters: parameters).responseData { response in
            guard let data = response.data else {
                print(response.error!.localizedDescription)
                return
            }
            guard let friends = try! JSONDecoder().decode(Response<Friend>?.self, from: data)?.response.items else {
                print("fuck")
                return
            }
            DispatchQueue.main.async {
                completion(friends)
            }
        }
    }
    
}



