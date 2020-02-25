//
//  Order.swift
//  HotCoffee
//
//  Created by 배상렬 on 2020/02/25.
//  Copyright © 2020 배상렬. All rights reserved.
//

import Foundation

enum CoffeeType: String, Codable
{
        case cappuccino
    case latte
    case espressino
    case cortado
}

enum CoffeeSize: String, Codable
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
    
    
}