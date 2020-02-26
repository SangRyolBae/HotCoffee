//
//  OrderViewModel.swift
//  HotCoffee
//
//  Created by 배상렬 on 2020/02/26.
//  Copyright © 2020 배상렬. All rights reserved.
//

import Foundation

class OrderListViewModel
{
    
    var ordersViewModel: [OrderViewModel]
    
    init()
    {
        self.ordersViewModel = [OrderViewModel]();
        
    }
    
    func orderViewModel(at index: Int) -> OrderViewModel
    {
        return self.ordersViewModel[index];
    }
    
    
}



struct OrderViewModel
{
    
    let order:Order
    
}

extension OrderViewModel
{
    var name: String
    {
        return self.order.name;
    }
    
    var email: String
    {
        return self.order.email;
    }
    
    var type: String
    {
        return self.order.type.rawValue.capitalized;
    }
    
    var size: String
    {
        return self.order.size.rawValue.capitalized;
    }
}
