//
//  Server.swift
//  Foodle
//
//  Created by 루딘 on 7/10/24.
//

import Foundation

func fetchUser(_ uid: String) -> User?{
    var result: User?
    var url = AppDelegate.url!
    url.append(path: "/api/users/profile")
    url.append(queryItems: [URLQueryItem(name: "uid", value: uid)])
    let session = URLSession.shared
    let task = session.dataTask(with: url) { data, response, error in
        if let error{
            print(error)
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else { return }
        
        guard httpResponse.statusCode == 200 else { return }
        
        guard let data else { return }
        
        do{
            let decoder = JSONDecoder()
            result = try decoder.decode(User.self, from: data)
        } catch {
            print(error)
        }
    }
    task.resume()
    
    return result
}

func fetchMeetings(_ uid: String) -> [Meeting]?{
    var result: [Meeting]?
    var url = AppDelegate.url!
    url.append(path: "/api/meetings/byUid")
    url.append(queryItems: [URLQueryItem(name: "uid", value: uid)])
    
    let session = URLSession.shared
    let task = session.dataTask(with: url) { data, response, error in
        if let error{
            print(error)
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else { return }
        
        guard httpResponse.statusCode == 200 else { return }
        
        guard let data else { return }
        
        do{
            let decoder = JSONDecoder()
            result = try decoder.decode([Meeting].self, from: data)
        } catch {
            print(error)
        }
    }
    task.resume()
    
    return result
}

func fetchFriends(_ uid: String) -> [Friend]?{
    var result: [Friend]?
    
    var url = AppDelegate.url!
    url.append(path: "/api/friends/byUid")
    url.append(queryItems: [URLQueryItem(name: "uid", value: uid)])
    let session = URLSession.shared
    let task = session.dataTask(with: url) { data, response, error in
        if let error{
            print(error)
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else { return }
        
        guard httpResponse.statusCode == 200 else { return }
        
        guard let data else { return }
        
        do{
            let decoder = JSONDecoder()
            result = try decoder.decode([Friend].self, from: data)
        } catch {
            print(error)
        }
    }
    task.resume()
    
    return result
}

func fetchPlaceLists(_ uid: String) -> [PlaceList]?{
    var result: [PlaceList]?
    var url = AppDelegate.url!
    url.append(path: "/api/placeList/byUid")
    url.append(queryItems: [URLQueryItem(name: "uid", value: uid)])
    
    let session = URLSession.shared
    let task = session.dataTask(with: url) { data, response, error in
        if let error{
            print(error)
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else { return }
        
        guard httpResponse.statusCode == 200 else { return }
        
        guard let data else { return }
        
        do{
            let decoder = JSONDecoder()
            result = try decoder.decode([PlaceList].self, from: data)
        } catch {
            print(error)
        }
    }
    task.resume()
    
    return result
}



