//
//  TablaVC.swift
//  EjemploRXSwift
//
//  Created by Marcos Suarez on 16/8/18.
//  Copyright © 2018 Marcos Suarez. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TablaVC:UIViewController {
    
    var colores = [String]()
    var coloresMostrados = [String]()
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colores = ["Rojo","Azul","Verde","Negro","Gris","Amarillo"]
        coloresMostrados = colores
    }
}


extension TablaVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coloresMostrados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        
        cell.textLabel?.text = coloresMostrados[indexPath.row]
        
        return cell
    }
    
    
}
