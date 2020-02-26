//
//  OrdersTableViewController.swift
//  HotCoffee
//
//  Created by 배상렬 on 2020/02/25.
//  Copyright © 2020 배상렬. All rights reserved.
//

import Foundation
import UIKit

class OrdersTableViewController: UITableViewController, AddCoffeeOrderDelegate
{
    
    var orderListViewModel = OrderListViewModel();
    
    // MARK: - init
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        populateOrders();
        //getNews();
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        guard let navC = segue.destination as? UINavigationController,
            let addCoffeeOrderVC = navC.viewControllers.first as? AddOrderNewController
            else {
                fatalError("Error performing seque");
        }
        
        addCoffeeOrderVC.delegate = self;
    }
    
    
    
    private func populateOrders()
    {
        
        Webservice().load(resource: Order.all) { [weak self](result) in
            
            switch result
            {
            case .success(let orders):
                
                print(orders);
                
                self?.orderListViewModel.ordersViewModel = orders.map(OrderViewModel.init);
                
                self?.tableView.reloadData();
                
            case .failure(let error):
                print(error);
            }
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.orderListViewModel.ordersViewModel.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let vm = self.orderListViewModel.orderViewModel(at: indexPath.row);
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath);
        
        cell.textLabel?.text = vm.type;
        cell.detailTextLabel?.text = vm.size;
        
        return cell;
    }
    
    
    // MARK: - delegate functions of AddCoffeeOrderDelegate
    func addCoffeeOrderViewControllerDidSave(order: Order, controller: UIViewController)
    {
        controller.dismiss(animated: true, completion: nil);
        
        let orderVM = OrderViewModel(order: order);
        
        self.orderListViewModel.ordersViewModel.append(orderVM);
        
        self.tableView.insertRows(at: [IndexPath.init(row: self.orderListViewModel.ordersViewModel.count - 1, section: 0)], with: .automatic);
        
    }
    
    func addCoffeeOrderViewControllerDidClose(controller: UIViewController)
    {
        controller.dismiss(animated: true, completion: nil);
    }
    
    
    
    
    // MARK: - TEST CODE
    
    private func getNews()
    {
        
        guard let bitcoinUrl = URL(string: "http://newsapi.org/v2/everything?q=bitcoin&from=2020-01-25&sortBy=publishedAt&apiKey=4d4f96941e7146548fb3be6a41a10804") else {
            fatalError("URL was incorrect");
        }
        
        let resource = Resource<ArticleList>(url: bitcoinUrl);
        
        Webservice().load(resource: resource) { (result) in
            
            switch result
            {
            case .success(let orders):
                print(orders);
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
}
