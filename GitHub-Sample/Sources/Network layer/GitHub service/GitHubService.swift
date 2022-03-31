//
//  GitHubService.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 28.03.2022.
//

import Foundation

final class GitHubService: GitHubServiceProtocol {
    
    // MARK: - Internal properties
    
    let baseURL: URL
    let session: URLSession
    let completionQueue: DispatchQueue
    
    // MARK: - Endpoints
    
    enum Endpoints: String {
        case searchUsers = "/search/users"
        case user = "users/%@"
    }
    
    // MARK: - Init
    
    init(baseURL: URL = APIConstants.gitHubBaseURL,
         session: URLSession = .shared,
         completionQueue: DispatchQueue = .main) {
        self.baseURL = baseURL
        self.session = session
        self.completionQueue = completionQueue
    }
    
    // MARK: - GitHubServiceProtocol
    
    func users(query: String,
               pageNumber: Int,
               sort: GitHubSearchParams.Sort,
               order: GitHubSearchParams.Order,
               completion: @escaping ItemClosure<Result<GitHubSearchUsersModel, ServiceError>>) -> Cancellable? {
        
        let url = self.baseURL.appendingPathComponent(Endpoints.searchUsers.rawValue)
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "page", value: "\(pageNumber)"),
            URLQueryItem(name: "sort", value: sort.rawValue),
            URLQueryItem(name: "order", value: order.rawValue)
        ]
        
        guard let resultURL = urlComponents?.url else {
            completion(.failure(.combineURL))
            return nil
        }
        
        let task = self.session.dataTask(with: resultURL) { [weak self] (data, response, error) in
            let result = ResponseParser.parse(type: GitHubSearchUsersModel.self,
                                              data: data,
                                              response: response,
                                              error: error)
            
            self?.completionQueue.async {
                completion(result)
            }
        }
        
        task.resume()
        return task
    }
    
    func user(userName: String, completion: @escaping ItemClosure<Result<GitHubSearchUserModel?, ServiceError>>) {
        
        let url = String(format: Endpoints.user.rawValue, arguments: [userName])
        let resultURL = self.baseURL.appendingPathComponent(url)
        
        let task = self.session.dataTask(with: resultURL) { [weak self] (data, response, error) in
            if let error = ResponseParser.parseError(response: response, error: error) {
                switch error {
                case .httpError(let code):
                    if code == 404 {
                        self?.completionQueue.async { completion(.success(nil)) }
                    } else {
                        fallthrough
                    }
                default:
                    self?.completionQueue.async { completion(.failure(error)) }
                }
                return
            }
            
            let result = ResponseParser.parseData(type: GitHubSearchUserModel.self, data: data)
            
            self?.completionQueue.async {
                switch result {
                case .success(let user):
                    completion(.success(user))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
}
