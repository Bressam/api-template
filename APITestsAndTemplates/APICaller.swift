//
//  APICaller.swift
//  APITestsAndTemplates
//
//  Created by Giovanne Bressam on 11/12/21.
//

import Foundation

class APICaller {
    
    static let shared = APICaller()
    
    func performAPICall<T:Codable>(url: String, expectedType: T.Type, completion: @escaping ((Result<T, APIError>) -> Void)) {
        guard let endpoint = URL(string: url) else { return }
        
        // creates URL data task
        let task = URLSession.shared.dataTask(with: endpoint, completionHandler: { resultData, urlResponse, error in
            
            // check for error
            guard let resultData = resultData, error == nil else {
                completion(.failure(.unknown))
                return
            }
            
            // Try parsing
            let decodedResult: T?
            do {
                decodedResult = try JSONDecoder().decode(T.self, from: resultData)
            } catch {
                decodedResult = nil
            }
            
            // check if was parsed correctly
            guard let decodedResult = decodedResult  else {
                completion(.failure(.badResponse))
                return
            }
            
            // return parsed object
            completion(.success(decodedResult))
        })
        
        // runs task
        task.resume()
    }
    
    
    // With parameters and query itens:
//    func getAllMembers(urlString: String) {
//
//        //URLComponents to the rescue!
//        var urlBuilder = URLComponents(string: urlString)
//        urlBuilder?.queryItems = [
//            URLQueryItem(name: "member", value: "John")
//        ]
//
//        guard let url = urlBuilder.url else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("Admin", forHTTPHeaderField: "Login")
//        request.setValue("Admin", forHTTPHeaderField: "Password")
//
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            print(response)
//            print(String(data: data, encoding: .utf8)) //Try this too!
//        }.resume()
//    }
}

struct User: Codable {
    var name: String
    var age: String
}

enum APIError: Error {
        case internalError
        case badRequest
        case badResponse
        case unknown
}

// For each error type return the appropriate description
extension APIError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .internalError:
            return "The provided password is not valid."
        case .badRequest:
            return "The specified item could not be found."
        case .badResponse:
            return "Internal server error"
        case .unknown:
            return "An unexpected error occurred."
        }
    }
}

//enum APIErrorType: Error {
//    case internalError
//    case badRequest
//    case badResponse
//    case unknown
//}

//struct APIError: LocalizedError {
//    var errorDescription: String?
//    var errorType: APIErrorType
//
//    init(type: APIErrorType) {
//        errorType = type
//        errorDescription = errorType.localizedDescription
//    }
//}
