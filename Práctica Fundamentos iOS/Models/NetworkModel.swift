//
//  NetworkModel.swift
//  Práctica Fundamentos iOS
//
//  Created by Juan Cruz Guidi on 19/6/22.
//

import Foundation

enum NetworkError: Error, Equatable {
    case malformedURL
    case dataFormatting
    case other
    case noData
    case errorCode(Int?)
    case decoding
    case token
}

final class NetworkModel {
  
  var session: URLSession
    
  var token: String?
  
    init(session: URLSession = .shared, token: String? = nil) {
    self.token = token
    self.session = session
  }
  
  func login(user: String, password: String, completion: @escaping (String?, NetworkError?) -> Void) {
    guard let url = URL(string: "https://vapor2022.herokuapp.com/api/auth/login") else {
      completion(nil, NetworkError.malformedURL)
      return
    }
    
    let loginString = String(format: "%@:%@", user, password)
    let loginData = loginString.data(using: String.Encoding.utf8)!
    let base64LoginString = loginData.base64EncodedString()
    
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "POST"
    urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
    
    let task = session.dataTask(with: urlRequest) { (data, response, error) in
      guard error == nil else {
        completion(nil, NetworkError.other)
        return
      }
      
      guard let data = data else {
        completion(nil, NetworkError.noData)
        return
      }
      
      guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        completion(nil, NetworkError.errorCode((response as? HTTPURLResponse)?.statusCode))
        return
      }
      
      guard let response = String(data: data, encoding: .utf8) else {
        completion(nil, NetworkError.decoding)
        return
      }
      
      self.token = response
      completion(response, nil)
    }
    
    task.resume()
  }
  
  func getHeroes(completion: @escaping ([Hero], NetworkError?) -> Void) {
      
      struct Body: Encodable {
          let name: String
      }
      
      guard let token else {
          fatalError("No token")
      }
      
      performAuthenticatedNetworkRequest(
        "https://vapor2022.herokuapp.com/api/heros/all",
        httpMethod: .post,
        httpBody: Body(name: ""),
        requestToken: token)
      { (result: Result<[Hero], NetworkError>) in
          switch result {
          case .success(let success):
              completion(success, nil)
          case .failure(let failure):
              completion([], failure)
          }
      }
  }
  
  func getTransformations(for hero: Hero, completion: @escaping ([Transformation], NetworkError?) -> Void) {
      
      let urlString = "https://vapor2022.herokuapp.com/api/heros/tranformations"
      
      struct Body: Encodable {
          let id: String
      }
      
      guard let token else {
          fatalError("No token")
      }
      
      performAuthenticatedNetworkRequest(
        urlString,
        httpMethod: .post,
        httpBody: Body(id: hero.id),
        requestToken: token)
      { (result: Result<[Transformation], NetworkError>) in
          switch result {
          case .success(let success):
              completion(success, nil)
          case .failure(let failure):
              completion([], failure)
          }
      }
   }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

extension NetworkModel {
    func performAuthenticatedNetworkRequest<R: Decodable, B: Encodable>(
        _ urlString: String,
        httpMethod: HTTPMethod,
        httpBody: B?,
        requestToken: String,
        completion: @escaping (Result<R, NetworkError>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            // ANTES
            //completion([], NetworkError.malformedURL)
            // AHORA
            completion(.failure(.malformedURL))
          return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.setValue("Bearer \(requestToken)", forHTTPHeaderField: "Authorization")
        
        if let httpBody {
            urlRequest.setValue("Application/Json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try? JSONEncoder().encode(httpBody)
        }
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
          guard error == nil else {
              completion(.failure(.other))
            return
          }
          
          guard let data = data else {
              completion(.failure(.noData))
            return
          }
          
          guard let response = try? JSONDecoder().decode(R.self, from: data) else {
              completion(.failure(.decoding))
            return
          }
            completion(.success(response))
        }
        
        task.resume()
        
    }
}
