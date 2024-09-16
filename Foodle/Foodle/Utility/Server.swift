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
            print(result)
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
struct SearchPlace: Encodable{
    var meeting: Meeting?
    var placeName: String?
}
func searchPlace(_ byName: String?, _ meeting: Meeting? = nil, completion: @escaping ([Place]?) -> Void){
    guard let byName else { return }
    var url = url!
    if meeting != nil {
        url.append(path:"/api/meetings/getPreferredPlacebyPlaceName")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = SearchPlace(meeting: meeting, placeName: byName)
        
        guard let meetingData = try? JSONEncoder().encode(data) else { return }
        
        let task = URLSession.shared.uploadTask(with: request, from: meetingData) { (data, response, error) in
            if let error = error {
                NSLog("An error has occurred: \(error.localizedDescription)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                NSLog("Server error: \(httpResponse.statusCode)")
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
    } else {
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


func updateMeeting(_ meeting: Meeting?, completion: @escaping () -> Void){
    var url = url!
    url.append(path: "/api/meetings/update")
    
    let encoder = JSONEncoder()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    encoder.dateEncodingStrategy = .formatted(dateFormatter)
    
    guard let data = try? encoder.encode(meeting) else { return }
    
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

func createUser(_ user: User?, completion: @escaping () -> Void){
    var url = url!
    url.append(path: "/api/users/create")
    
    guard let data = try? JSONEncoder().encode(user) else { return }
    
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

func updateUser(user: User, completion: @escaping () -> Void) {
    var url = url!
    url.append(path: "/api/users/update")

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
        let jsonData = try JSONEncoder().encode(user)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating user: \(error)")
                completion()
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    print("Update successful.")
                    completion()
                case 404:
                    print("Error: API endpoint not found (404).")
                default:
                    print("Server error: \(httpResponse.statusCode)")
                }
            } else {
                print("Unexpected response.")
            }
            
            completion()
        }
        
        task.resume()
    } catch {
        print("Error encoding user: \(error)")
        completion()
    }
}

func updateUserLikeWords(uid: String, likeWords: [String], completion: @escaping () -> Void) {
    var url = url!
    url.append(path: "/api/users/update/likeWord")
    
    let likeWordsString = likeWords.joined(separator: ",")
    
    let queryItems = [
        URLQueryItem(name: "uid", value: uid),
        URLQueryItem(name: "likeWord", value: likeWordsString)
    ]
    url.append(queryItems: queryItems)
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error updating user like words: \(error)")
            completion()
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 200:
                print("Like words update successful.")
            case 404:
                print("Error: API endpoint not found (404).")
            default:
                print("Server error: \(httpResponse.statusCode)")
            }
        } else {
            print("Unexpected response.")
        }
        
        completion()
    }
    
    task.resume()
}

func updateUserDislikeWords(uid: String, dislikeWords: [String], completion: @escaping () -> Void) {
    var url = url!
    url.append(path: "/api/users/update/dislikeWord")
    
    let dislikeWordsString = dislikeWords.joined(separator: ",")
    
    let queryItems = [
        URLQueryItem(name: "uid", value: uid),
        URLQueryItem(name: "dislikeWord", value: dislikeWordsString)
    ]
    url.append(queryItems: queryItems)
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error updating user dislike words: \(error)")
            completion()
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 200:
                print("Dislike words update successful.")
            case 404:
                print("Error: API endpoint not found (404).")
            default:
                print("Server error: \(httpResponse.statusCode)")
            }
        } else {
            print("Unexpected response.")
        }
        
        completion()
    }
    
    task.resume()
}
