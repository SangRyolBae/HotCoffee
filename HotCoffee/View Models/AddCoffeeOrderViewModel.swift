//
//  AddCoffeeOrderViewModel.swift
//  HotCoffee
//
//  Created by 배상렬 on 2020/02/26.
//  Copyright © 2020 배상렬. All rights reserved.
//

import Foundation

struct AddCoffeeOrderViewModel
{
    var name: String?
    var email: String?
    
    var selectedType: String?
    var selectedSize: String?
    
    var types: [String]
    {
        return CoffeeType.allCases.map { $0.rawValue.capitalized }
    }
    
    var sizes: [String]
    {
        return CoffeeSize.allCases.map { $0.rawValue.capitalized }
    }
}
