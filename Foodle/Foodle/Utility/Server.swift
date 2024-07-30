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

func searchPlace(_ byName: String?, completion: @escaping ([Place]?) -> Void){
    guard let byName else { return }
    
    var url = url!
    url.append(path: "/api/place/byPlaceName")
    url.append(queryItems: [URLQueryItem(name: "placeName", value: byName)])
    
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
            print(httpResponse.statusCode)
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
            let result = try decoder.decode([Place].self, from: data)
            completion(result)
        } catch {
            print(error)
            completion(nil)
        }
    }
    task.resume()
}

func createPlaceList(_ list: PlaceList, completion: @escaping () -> Void){
    var url = url!
    url.append(path: "/api/placeList/create")
    
    guard let uploadData = try? JSONEncoder().encode(list) else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.uploadTask(with: request, from: uploadData) { (data, response, error) in
        
        if let e = error {
            NSLog("An error has occured: \(e.localizedDescription)")
            return
        }
        completion()
    }
    
    task.resume()
}

func deletePlaceList(_ list: PlaceList, completion: @escaping () -> Void){
    var url = url!
    url.append(path: "/api/placeList/delete")
    
    guard let deleteData = try? JSONEncoder().encode(list) else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.uploadTask(with: request, from: deleteData) { (data, response, error) in
        if let error = error {
            NSLog("An error has occurred: \(error.localizedDescription)")
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            NSLog("Server error: \(httpResponse.statusCode)")
            return
        }
        completion()
    }
    
    task.resume()
}


func updatePlaceList(_ list: PlaceList?, completion: @escaping () -> Void){
    var url = url!
    url.append(path: "/api/placeList/update")

    let target = PlaceList(lid: list?.lid, places: list?.places)
    guard let data = try? JSONEncoder().encode(target) else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.uploadTask(with: request, from: data) { (data, response, error) in
        if let error = error {
            NSLog("An error has occurred: \(error.localizedDescription)")
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            NSLog("Server error: \(httpResponse.statusCode)")
            return
        }
        completion()
    }
    
    task.resume()
}

func addMeeting(_ meeting: Meeting?, completion: @escaping () -> Void){
    var url = url!
    url.append(path: "/api/meetings/create")
    
    let encoder = JSONEncoder()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    encoder.dateEncodingStrategy = .formatted(dateFormatter)
    
    guard let data = try? encoder.encode(meeting) else { return }
    
    print("JSON Data: \(String(data: data, encoding: .utf8) ?? "nil")")
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.uploadTask(with: request, from: data) { (data, response, error) in
        if let error = error {
            NSLog("An error has occurred: \(error.localizedDescription)")
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            NSLog("Server error: \(httpResponse.statusCode)")
            return
        }
        completion()
    }
    
    task.resume()
}

func updateFriendFavorite(_ friend: Friend?, completion: @escaping () -> Void){
    var url = url!
    url.append(path: "/api/friends/Update")
    
    guard let friend = friend, let uid = user?.uid else {
            return
        }
    
    url.append(queryItems: [URLQueryItem(name: "uid", value: uid)])
    url.append(queryItems: [URLQueryItem(name: "fid", value: friend.user.uid)])
    
    let target = Friend(user: friend.user, like: friend.like)
    guard let data = try? JSONEncoder().encode(target) else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    print("JSON Data: \(String(data: data, encoding: .utf8) ?? "nil")")
    
    let task = URLSession.shared.uploadTask(with: request, from: data) { (data, response, error) in
        if let error = error {
            NSLog("An error has occurred: \(error.localizedDescription)")
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            NSLog("Server error: \(httpResponse.statusCode)")
            return
        }
        completion()
    }
    
    task.resume()
}
