//
//  NetworkService.swift
//  VK_GB
//
//  Created by Павел Шатунов on 15.08.2022.
//

import Foundation

class NetworkService {
    private let cliendId = "7997968"
    private let apiVer = "5.131"
    
    private var urlConstructor = URLComponents()
    private let configuration: URLSessionConfiguration!
    private let session: URLSession!
    
    init() {
        urlConstructor.scheme = "https"
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
    
    func loadImage (for ownerID: Int?, onComplete: @escaping([Photo]) -> Void, onError: @escaping(Error) -> Void) {
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/photos.getAll"
        
        guard let owner = ownerID else {return }
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "ownerID", value: String(owner)),
            URLQueryItem(name: "photo_sizes", value: "1"),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "count", value: "20"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: apiVer)
        ]
        
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            if  error != nil {
                onError(ServerError.errorTask)
            }
            
            guard let data = data else {
                onError(ServerError.noDataProvided)
                return
            }
            
            guard let photos = try? JSONDecoder().decode(Response<Photo>.self, from: data).response.items else {
                onError(ServerError.failedToDecode)
                return
            }
            DispatchQueue.main.async {
                onComplete(photos)
            }
        }
        task.resume()
    }
    
    func getURLDataCommunites() -> URL? {
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/groups.get"

        urlConstructor.queryItems = [
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "fields", value: "description"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: apiVer),
        ]
        return urlConstructor.url
    }
    
    func getUrlDataFriend() -> URL? {
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/friends.get"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "order", value: "name"),
            URLQueryItem(name: "fields", value: "sex,bdate,city,country,photo_100"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: apiVer)
        ]
        return urlConstructor.url
    }
    
    func getCommunity(onComplete: @escaping ([Group]) -> Void, onError: @escaping (Error) -> Void) {
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/groups.get"

        urlConstructor.queryItems = [
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "fields", value: "description"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: apiVer),
        ]
       
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in

            if error != nil {
                onError(ServerError.errorTask)
            }

            guard let data = data else {
                onError(ServerError.noDataProvided)
                return
            }
            guard let communities = try? JSONDecoder().decode(Response<Group>.self, from: data).response.items else {
                onError(ServerError.failedToDecode)
                return
            }
            onComplete(communities)
        }
        task.resume()
    }
}
