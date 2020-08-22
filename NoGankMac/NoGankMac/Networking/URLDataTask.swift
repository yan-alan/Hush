//
//  URLDataTask.swift
//  UniMeet
//
//  Created by Alan Yan on 2020-07-26.
//

import Foundation

struct URLDataTask {
    typealias genericCompletion<U:Codable> = ((UniMeetError?, U?) -> Void)
    typealias genericNonCodableCompletion<H> = ((UniMeetError?, H?) -> Void)

    ///Creates a data task with a body and a response
    static func completeDataTask<T: Codable, U:Codable> (req: URLRequest, body: T, retType: U.Type,completion: @escaping genericCompletion<U>) {
        var newReq = req
        guard let encodedData = try? JSONEncoder().encode(body) else {
            completion(UniMeetError(title: "Encoding Error", failureType: .encodingError), nil)
            return
        }
        newReq.httpBody = encodedData
        
        
        let datatask = URLSession.shared.dataTask(with: newReq) { (data, response, error) in
            guard error == nil else {
                completion(UniMeetError(title: "Failed to connect to server \(error!)", failureType: .networkError), nil)
                return
            }
            if let response = response {
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode >= 400 {
                    completion(UniMeetError(title: "Status code error", failureType: .statusCodeError(code: httpResponse.statusCode)), nil)
                    return
                }
            }
            
            if let data = data {
                guard let decodedObject = try? JSONDecoder().decode(U.self, from: data) else {
                    print("DECODE FAILED")
                    if let dict = try? JSONSerialization.jsonObject(with: data, options: []) {
                        print(dict)
                    }
                    completion(UniMeetError(title: "Decoding Error", failureType: .decodingError), nil)
                    return
                }
                completion(nil, decodedObject)
            }
        }
        datatask.resume()
    }
    ///Creates a data task with no body but a response
    static func completeDataTask<U:Codable> (req: URLRequest, retType: U.Type,completion: @escaping genericCompletion<U>) {
        let datatask = URLSession.shared.dataTask(with: req) { (data, response, error) in
            guard error == nil else {
                completion(UniMeetError(title: "Failed to connect to server \(error!)", failureType: .networkError), nil)
                return
            }
            if let response = response {
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode >= 400 {
                    completion(UniMeetError(title: "Status code error", failureType: .statusCodeError(code: httpResponse.statusCode)), nil)
                    return
                }
            }
            
            if let data = data {
                guard let decodedObject = try? JSONDecoder().decode(U.self, from: data) else {
                    print("DECODE FAILED")
                    if let dict = try? JSONSerialization.jsonObject(with: data, options: []) {
                        print(dict)
                    }
                    completion(UniMeetError(title: "Decoding Error", failureType: .decodingError), nil)
                    return
                }
                completion(nil, decodedObject)
            }
        }
        datatask.resume()
    }
    
    ///Makes a data task with just a body, doesn't return response
    static func completeDataTask<T:Codable> (req: URLRequest, body: T,completion: @escaping (UniMeetError?) -> Void) {
        var newReq = req
        guard let encodedData = try? JSONEncoder().encode(body) else {
            completion(UniMeetError(title: "Encoding Error", failureType: .encodingError))
            return
        }
        newReq.httpBody = encodedData
        let datatask = URLSession.shared.dataTask(with: newReq) { (data, response, error) in
            guard error == nil else {
                completion(UniMeetError(title: "Failed to connect to server \(error!)", failureType: .networkError))
                return
            }
            if let response = response {
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode >= 400 {
                    completion(UniMeetError(title: "Status code error", failureType: .statusCodeError(code: httpResponse.statusCode)))
                    return
                }
            }
            completion(nil)
        }
        datatask.resume()
    }
    
    ///Makes a data task with no body and no response
    static func completeDataTask(req: URLRequest, completion: @escaping (UniMeetError?) -> Void) {
        let datatask = URLSession.shared.dataTask(with: req) { (data, response, error) in
            guard error == nil else {
                completion(UniMeetError(title: "Failed to connect to server \(error!)", failureType: .networkError))
                return
            }
            if let response = response {
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode >= 400 {
                    completion(UniMeetError(title: "Status code error", failureType: .statusCodeError(code: httpResponse.statusCode)))
                    return
                }
            }
            completion(nil)
        }
        datatask.resume()
    }
    
    ///Makes a data task with just a body, doesn't return response
    static func completeDataTask (req: URLRequest, body: [String: Any], completion: @escaping (UniMeetError?) -> Void) {
        var newReq = req
        guard let encodedData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            completion(UniMeetError(title: "Encoding Error", failureType: .encodingError))
            return
        }
        newReq.httpBody = encodedData
        let datatask = URLSession.shared.dataTask(with: newReq) { (data, response, error) in
            guard error == nil else {
                completion(UniMeetError(title: "Failed to connect to server \(error!)", failureType: .networkError))
                return
            }
            if let response = response {
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode >= 400 {
                    completion(UniMeetError(title: "Status code error", failureType: .statusCodeError(code: httpResponse.statusCode)))
                    return
                }
            }
            completion(nil)
        }
        datatask.resume()
    }
    
    ///Creates a data task with a body and a response
    static func completeDataTask<U:Codable> (req: URLRequest, body: [String: Any], retType: U.Type,completion: @escaping genericCompletion<U>) {
        var newReq = req
        guard let encodedData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            completion(UniMeetError(title: "Encoding Error", failureType: .encodingError), nil)
            return
        }
        newReq.httpBody = encodedData
        
        
        let datatask = URLSession.shared.dataTask(with: newReq) { (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(UniMeetError(title: "Failed to connect to server \(error!)", failureType: .networkError), nil)
                return
            }
            if let response = response {
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode >= 400 {
                    completion(UniMeetError(title: "Status code error \(httpResponse.statusCode)", failureType: .statusCodeError(code: httpResponse.statusCode)), nil)
                    return
                }
            }
            
            if let data = data {
                guard let decodedObject = try? JSONDecoder().decode(U.self, from: data) else {
                    print("DECODE FAILED")
                    if let dict = try? JSONSerialization.jsonObject(with: data, options: []) {
                        print(dict)
                    }
                    completion(UniMeetError(title: "Decoding Error", failureType: .decodingError), nil)
                    return
                }
                completion(nil, decodedObject)
            }
        }
        datatask.resume()
    }
    
    ///Creates a data task with a body and a response
    static func completeDictDataTask<U>(req: URLRequest, body: [String: Any]? = nil, retType: U.Type ,completion: @escaping genericNonCodableCompletion<U>) {
        var newReq = req
        
        if let body = body {
            guard let encodedData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
                completion(UniMeetError(title: "Encoding Error", failureType: .encodingError), nil)
                return
            }
            newReq.httpBody = encodedData
        }
        
        
        let datatask = URLSession.shared.dataTask(with: newReq) { (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(UniMeetError(title: "Failed to connect to server \(error!)", failureType: .networkError), nil)
                return
            }
            if let response = response {
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode >= 400 {
                    completion(UniMeetError(title: "Status code error \(httpResponse.statusCode)", failureType: .statusCodeError(code: httpResponse.statusCode)), nil)
                    return
                }
            }
            
            if let data = data {
                guard let decodedObject = try? JSONSerialization.jsonObject(with: data, options: []) as? U else {
                    print("DECODE FAILED")
                    print(String(data: data, encoding: .ascii) ?? "Failed to convert data to string")
                    completion(UniMeetError(title: "Decoding Error", failureType: .decodingError), nil)
                    return
                }
                completion(nil, decodedObject)
            }
        }
        datatask.resume()
    }
}

struct UniMeetError: LocalizedError {

    var title: String?
    var failureType: FailureType

    init(title: String?, failureType: FailureType) {
        self.title = title ?? "Error"
        self.failureType = failureType
    }
    
    enum FailureType {
        case encodingError
        case decodingError
        case statusCodeError(code: Int)
        case networkError
        case missingDataError
    }
}
