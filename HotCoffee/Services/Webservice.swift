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

struct Resource<T: Codable>
{
    let url: URL
    
}

class Webservice
{
    
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void)
    {
        
        let url = resource.url;
            
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data, error == nil else
            {
                completion(.failure(.domainError));
                return;
            }
            
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
