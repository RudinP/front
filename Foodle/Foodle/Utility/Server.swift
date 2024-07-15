//
//  Server.swift
//  Foodle
//
//  Created by 루딘 on 7/10/24.
//

import Foundation

func fetchUser(_ uid: String, completion: @escaping (User?) -> Void){
    
    var url = url!
    url.append(path: "/api/users/profile")
    url.append(queryItems: [URLQueryItem(name: "uid", value: uid)])

    let session = URLSession.shared
    let task = session.dataTask(with: url) { data, response, error in
        if error != nil{
            completion(nil)
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else
        {
            completion(nil)
            return
        }
        
        guard httpResponse.statusCode == 200 else
        {
            completion(nil)
            return
        }
        
        guard let data else
        {
            completion(nil)
            return
        }
        
        do{
            let decoder = JSONDecoder()
            let result = try decoder.decode(User.self, from: data)
            completion(result)
        } catch {
            print(error)
            completion(nil)
        }
    }
    task.resume()
}

func fetchMeeting(_ uid: String, completion: @escaping ([Meeting]?) -> Void){
    
    var url = url!
    url.append(path: "/api/meetings/byUid")
    url.append(queryItems: [URLQueryItem(name: "uid", value: uid)])
    
    let session = URLSession.shared
    let task = session.dataTask(with: url) { data, response, error in
        if error != nil{
            completion(nil)
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else
        {
            completion(nil)
            return
        }
        
        guard httpResponse.statusCode == 200 else
        {
            completion(nil)
            return
        }
        
        guard let data else
        {
            completion(nil)
            return
        }
        
        do{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(formatter)
            let result = try decoder.decode([Meeting].self, from: data)
            completion(result)
        } catch {
            print(error)
            completion(nil)
        }
    }
    task.resume()
}

func fetchFriends(_ uid: String, completion: @escaping ([Friend]?) -> Void){
    
    var url = url!
    url.append(path: "/api/friends/byUid")
    url.append(queryItems: [URLQueryItem(name: "uid", value: uid)])

    let session = URLSession.shared
    let task = session.dataTask(with: url) { data, response, error in
        if error != nil{
            completion(nil)
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else
        {
            completion(nil)
            return
        }
        
        guard httpResponse.statusCode == 200 else
        {
            completion(nil)
            return
        }
        
        guard let data else
        {
            completion(nil)
            return
        }
        
        do{
            let decoder = JSONDecoder()
            let result = try decoder.decode([Friend].self, from: data)
            completion(result)
        } catch {
            print(error)
            completion(nil)
        }
    }
    task.resume()
}

func fetchPlaceLists(_ uid: String, completion: @escaping ([PlaceList]?) -> Void){
    
    var url = url!
    url.append(path: "/api/placeList/byUid")
    url.append(queryItems: [URLQueryItem(name: "uid", value: uid)])

    let session = URLSession.shared
    let task = session.dataTask(with: url) { data, response, error in
        if error != nil{
            completion(nil)
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else
        {
            completion(nil)
            return
        }
        
        guard httpResponse.statusCode == 200 else
        {
            completion(nil)
            return
        }
        
        guard let data else
        {
            completion(nil)
            return
        }
        
        do{
            let decoder = JSONDecoder()
            let result = try decoder.decode([PlaceList].self, from: data)
            completion(result)
        } catch {
            print(error)
            completion(nil)
        }
    }
    task.resume()
}



