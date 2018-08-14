//
//  ViewController.swift
//  EjemploRXSwift
//
//  Created by Marcos Suarez on 14/8/18.
//  Copyright © 2018 Marcos Suarez. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var btnPresionar: UIButton!
    
    @IBOutlet weak var labelBtnPresionar: UILabel!
    
    @IBOutlet weak var swicth: UISwitch!
    
    @IBOutlet weak var labelSwitch: UILabel!
    
    @IBOutlet weak var labelSlider: UILabel!
    
    @IBOutlet weak var slider: UISlider!
    
    // Control para evitar ciclos de retención
    // Todas la variables Rx deben estar registradas aquí.
    let disposeBag = DisposeBag()
    
    var labelSliderOffSetY:CGFloat = 0
    
    var monitor = ["inicio", "llegando al medio", "medio", "llegando al fin","fin"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupObservables()
    }

   
    
    func setupObservables() {
        
        let observarSliderValue = slider.rx.value
            .asObservable()
            .share()
        
        observarSliderValue
            .map{ Int($0) }
            .map({ (valor) -> String in
                self.labelSlider.frame.origin = CGPoint(x: self.labelSlider.frame.origin.x, y: self.labelSlider.frame.origin.y)
                return valor.description
            })
            .bind(to: labelSlider.rx.text)
            .disposed(by: disposeBag)
    
        let observarSwithState = swicth.rx.isOn
            .subscribe(onNext: { (isOn) in
                self.labelSwitch.text = isOn ? "El swicth esta en On" : "El swicth esta en Off"
            })
        
        
        
        
    } // end setupObservables

}

