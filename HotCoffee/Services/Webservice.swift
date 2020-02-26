//
//  Webservice.swift
//  HotCoffee
//
//  Created by 배상렬 on 2020/02/25.
//  Copyright © 2020 배상렬. All rights reserved.
//

import Foundation

enum NetworkError: Error
{
    case decodingError
    case domainError
    case urlError
}

enum HttpMethod: String
{
    case get = "GET"
    case post = "POST"
}
struct Resource<T: Codable>
{
    let url: URL
    var httpMethed: HttpMethod = .get
    var body: Data? = nil;
    
    init(url: URL)
    {
        self.url = url;
    }
    
}

class Webservice
{
    
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void)
    {
        
        let url = resource.url;
            
        var request = URLRequest(url: url);
        request.httpMethod = resource.httpMethed.rawValue;
        request.httpBody = resource.body;
        request.addValue("application/json", forHTTPHeaderField: "Content-Type");
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, error == nil else
            {
                completion(.failure(.domainError));
                return;
            }
            
  
            // Log
//            guard let html = String(data:data, encoding:.utf8)
//            else { return }
//            print(html);
            
            let result = try? JSONDecoder().decode(T.self, from: data)
            if let result = result
            {
                DispatchQueue.main.async {
                    completion(.success(result));
                }
            }else
            {
                completion(.failure(.decodingError));
            }
            
        }.resume();
        
    }
}
