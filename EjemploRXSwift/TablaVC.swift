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
        
        colores = ["Rojo Sangre","Azul Cielo","Verde Naturaleza","Negro Muerte","Gris Ni Blanco ni Negro","Amarillo Sol", "Rojo Pasión", "Azul Mar", "Verde moco", "Negro Oscuridad", "Amarillo enfermo"]
        coloresMostrados = colores
        
        // Hacemos observable la variable del searchBar
        let textoBarraRx = self.searchBar.rx.text
        
        textoBarraRx
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe { (evento) in
                
                if let miEvento = evento.element as? String, !miEvento.isEmpty {
                    self.coloresMostrados = self.colores.filter({ $0.uppercased().hasPrefix(miEvento.uppercased()) })
                } else {
                    self.coloresMostrados = self.colores
                }
                self.tabla.reloadData()
            }
            .disposed(by: disposeBag)
        
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
