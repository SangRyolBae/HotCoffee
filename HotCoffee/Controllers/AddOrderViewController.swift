//
//  AddOrderViewController.swift
//  HotCoffee
//
//  Created by 배상렬 on 2020/02/25.
//  Copyright © 2020 배상렬. All rights reserved.
//

import Foundation
import UIKit

protocol AddCoffeeOrderDelegate
{
    func addCoffeeOrderViewControllerDidSave(order: Order, controller: UIViewController)
    func addCoffeeOrderViewControllerDidClose(controller: UIViewController);
}

class AddOrderNewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!;
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    private var coffeeSizesSegmentedControl: UISegmentedControl!;
    private var vm = AddCoffeeOrderViewModel();
    var delegate: AddCoffeeOrderDelegate?;
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        setupUI();
    }
    
    private func setupUI()
    {
        self.coffeeSizesSegmentedControl = UISegmentedControl(items: self.vm.sizes);
        self.coffeeSizesSegmentedControl.translatesAutoresizingMaskIntoConstraints = false;
        
        self.view.addSubview(self.coffeeSizesSegmentedControl);
        
        self.coffeeSizesSegmentedControl.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 20).isActive = true;
        
        self.coffeeSizesSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.vm.types.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeTypeTableViewCell", for: indexPath);
        
        cell.textLabel?.text = self.vm.types[indexPath.row];
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .none;
    }
    
    
    // MARK: - Actions
    @IBAction func close()
    {
        if let delegate = self.delegate
        {
            delegate.addCoffeeOrderViewControllerDidClose(controller: self);
        }
    }
    
    @IBAction func save()
    {
        let name = self.nameTextField.text;
        let email = self.emailTextField.text;
        
        let selectedSize = self.coffeeSizesSegmentedControl.titleForSegment(at: self.coffeeSizesSegmentedControl.selectedSegmentIndex);
        
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            fatalError( "Error in selecting coffee!" );
        }
        
        self.vm.name = name;
        self.vm.email = email;
        
        self.vm.selectedSize = selectedSize;
        self.vm.selectedType = self.vm.types[indexPath.row];
        
        Webservice().load(resource: Order.create(vm: self.vm)) { (result) in
            
            switch result
            {
            case .success(let order):
                
                if let order = order, let delegate = self.delegate
                {
                    DispatchQueue.main.async {
                        
                        delegate.addCoffeeOrderViewControllerDidSave(order: order, controller: self);
                    }
                }
                
                
            case .failure(let error):
                print(error);
            }
        }
    }
}
