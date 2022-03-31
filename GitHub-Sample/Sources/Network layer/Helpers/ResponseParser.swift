//
//  ResponseParser.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 28.03.2022.
//

import Foundation

final class ResponseParser {
    
    static func parseError(response: URLResponse?, error: Error?) -> ServiceError? {
        if let error = error as NSError? {
            if error.domain == "NSURLErrorDomain", error.code == -1009 {
                return .connection
            }
            return .unknown
        }
        
        if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
            return .httpError(code: response.statusCode)
        }
        
        return nil
    }
    
    static func parseData<T>(
        type: T.Type,
        data: Data?,
        strategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase
    ) -> Result<T, ServiceError> where T: Decodable {
        if type == Void.self {
            let t = () as! T
            return .success(t)
        }
        
        guard let data = data else {
            return .failure(.parsing)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = strategy
            
            let result = try decoder.decode(T.self, from: data)
            
            return .success(result)
        } catch {
            debugPrint("JSON error: \(error.localizedDescription)")
            return .failure(.parsing)
        }
    }
    
    static func parse<T>(
        type: T.Type,
        data: Data?,
        strategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
        response: URLResponse?,
        error: Error?
    ) -> Result<T, ServiceError> where T: Decodable {
        if let serverError = Self.parseError(response: response, error: error) {
            return .failure(serverError)
        }
        
        return Self.parseData(type: type, data: data, strategy: strategy)
    }
    
}
