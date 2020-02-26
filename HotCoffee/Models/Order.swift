//
//  Order.swift
//  HotCoffee
//
//  Created by 배상렬 on 2020/02/25.
//  Copyright © 2020 배상렬. All rights reserved.
//

import Foundation

enum CoffeeType: String, Codable, CaseIterable
{
    case cappuccino
    case lattee
    case espressino
    case cortado
}

enum CoffeeSize: String, Codable, CaseIterable
{
    case small
    case medium
    case large
}

struct Order: Codable
{
    let name: String;
    let email: String;
    let type: CoffeeType;
    let size: CoffeeSize;
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case type
        case size
    }
    
    init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = (try? values.decode(String.self, forKey: .name)) ?? ""
        email = (try? values.decode(String.self, forKey: .email)) ?? ""
        
        
        //        let typeRawValue = (try? values.decode(String.self, forKey: .type)) ?? ""
        //        if typeRawValue != ""
        //        {
        //            print(typeRawValue);
        //            type = CoffeeType(rawValue: typeRawValue) ?? CoffeeType.cappuccino;
        //        }else
        //        {
        //            type = CoffeeType.cappuccino;
        //        }
        
        type = (try? values.decode(CoffeeType.self, forKey: .type)) ?? CoffeeType.cappuccino
        size = (try? values.decode(CoffeeSize.self, forKey: .size)) ?? CoffeeSize.small
    }
    
    init?(_ vm: AddCoffeeOrderViewModel)
    {
        guard   let name = vm.name,
            let email = vm.email,
            let selectedType = CoffeeType(rawValue: vm.selectedType!.lowercased()),
            let selectedSize = CoffeeSize(rawValue: vm.selectedSize!.lowercased()) else
        {
            return nil;
        }
        
        self.name = name;
        self.email = email;
        self.type = selectedType;
        self.size = selectedSize;
    }
    
    static var all: Resource<[Order]> = {
        
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
            fatalError("URL was incorrect!");
        }
        
        return Resource<[Order]>(url: url);
        
    }()
    
    static func create(vm: AddCoffeeOrderViewModel) -> Resource<Order?>
    {
        let order = Order(vm);
        
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
            fatalError("URL was incorrect!");
        }
        
        guard let data = try? JSONEncoder().encode(order) else
        {
            fatalError("Error encoding order!");
        }
        
        var resource = Resource<Order?>(url: url);
        resource.httpMethed = HttpMethod.post;
        resource.body = data
        
        return resource;
    }
}

