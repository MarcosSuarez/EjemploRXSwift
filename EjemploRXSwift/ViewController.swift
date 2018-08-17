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
    
    @IBOutlet weak var labelColorSeleccionado: UILabel!
    
    
    // Control para evitar ciclos de retención
    // Todas la variables Rx deben estar registradas aquí.
    let disposeBag = DisposeBag()
    
    var labelSliderOffSetY:CGFloat = 0
    
    var monitor = ["inicio", "llegando al medio", "medio", "llegando al fin","fin"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ejemplosBasicos()
        setupObservables()
    }


    func setupObservables() {
        
        let observarSliderValue = slider.rx.value
            .asObservable()
            .share()
        
        observarSliderValue
            .map{ Int($0) }
            .map({ (valor) -> String in
                return valor.description
            })
            .bind(to: labelSlider.rx.text)
            .disposed(by: disposeBag)
    
        
        let observarSwithState = swicth.rx.isOn
            .subscribe(onNext: { (isOn) in
                self.labelSwitch.text = isOn ? "El swicth esta en On" : "El swicth esta en Off"
            })
        
    } // end setupObservables
    
    
    
    
    @IBAction func irAtablaColores(_ sender: Any) {
        performSegue(withIdentifier: "irTablaColores", sender: self)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "irTablaColores" {
            
            let tablaVC = segue.destination as? TablaVC
            
            // RX
            tablaVC?.colorSeleccionado
                .subscribe(onNext: { [weak self] colorRecibido in
                    self?.labelColorSeleccionado.text = "Color Seleccionado: \(colorRecibido)"
                })
                .disposed(by: disposeBag)
        }
    }
    
    
    func ejemplosBasicos() {
        // https://medium.com/ios-os-x-development/learn-and-master-%EF%B8%8F-the-basics-of-rxswift-in-10-minutes-818ea6e0a05b
        
        /// SECUENCIAS OBSERVABLES.
        
        // En RxSwift un Event es un enumerable:
        // .next(value: T) -> valor actual de la secuencia.
        // .error(error: Error) -> envía el error y termina la secuencia.
        // .completed -> sucede cuando la secuencia termina.
        
        // 1.-
        let secuenciaHolaSring = Observable.just("Hola esto es Rx")
        let subscripcionString = secuenciaHolaSring.subscribe { (evento) in print(evento) }
        // Salida:
        // next(Hola esto es Rx)
        // completed
        
        // 2.-
        let secuenciaHolaArray = Observable.from(["H","o","l","a"])
        
        let subscripcionArray = secuenciaHolaArray.subscribe { evento in
            
            switch evento {
            case .next(let valor):
                print(valor)
            case .error(let error):
                print(error)
            case .completed:
                print("Terminado el evento")
            }
        }
        // Salida:
        // H
        // o
        // l
        // a
        // Terminado el evento
        
        // 3.-
        let observarString = Observable.just("Hola otra vez")
        let subscripcionEsto = observarString.subscribe { print($0)}
        subscripcionEsto.disposed(by: disposeBag)
        
        ///  SUBJECTS es una forma especial de secuencia observable a la cual se puede subscribirse dinámicamente.
        
        // Haa 4 formas de Subjects.
        // 1.- PublishSubject -> Recibe los eventos después de subscrito
        // 2.- BehaviourSubject -> Entrega el evento más reciente y te mantiene subscrito
        // 3.- ReplaySubject -> Puedes enviar a otros subscriptores los eventos anteriores que quieras.
        // 4.- Variable (decapred) ->Es solo una envoltura para BehaviourSubject
        
        // Ejemplo PublishSubject
        print("\n --- Ejemplo PublishSubject --- \n")
        var sujetoPublico = PublishSubject<String>()
        
        sujetoPublico.onNext("Hola")
        sujetoPublico.onNext("Como te va")
        
        let subscribir1 = sujetoPublico.subscribe(onNext: { print($0)} )
        sujetoPublico.onNext("Hola")
        sujetoPublico.onNext("No me oyes?")
        
        let subscribir2 = sujetoPublico.subscribe(onNext: { print(#line, $0)})
        sujetoPublico.onNext("Ambas subscripciones recibieron este mensaje")
        
        // MAP
        print("\n --- MAP ---")
        Observable<Int>.of(1,2,3,4)
            .map { value in return value * 10 }
            .subscribe(onNext:{ print($0) })
        
        // FLATMAP
        print("\n --- FLATMAP ---")
        let sequence1  = Observable<Int>.of(1,2)
        let sequence2  = Observable<Int>.of(1,2)
        let sequenceOfSequences = Observable.of(sequence1,sequence2)
        // Combina las secuencias en una sola
        sequenceOfSequences
            .flatMap{ return $0 }
            .subscribe(onNext:{ print($0) })
        
        // SCAN -> Se parece al reduce en Swift
        print("\n --- SCAN ---")
        Observable.of(1,2,3,4,5)
            .scan(0) { seed, value in return seed + value }
            .subscribe(onNext:{ print($0) })
        
        // BUFFER:
        print("\n --- BUFFER ---")
        //        SequenceThatEmitsWithDifferentIntervals
        //            .buffer(timeSpan: 150, count: 3, scheduler:s)
        //            .subscribe(onNext:{
        //                print($0)
        //            })
        
        // FILTER:
        print("\n --- FILTER ---")
        Observable.of(2,30,22,5,60,1).filter{$0 > 10}.subscribe(onNext:{ print($0) })
        
        // DistinctUntilChanged
        print("\n --- DistinctUntilChanged ---")
        Observable.of(1,2,2,1,3).distinctUntilChanged().subscribe(onNext:{ print($0) })
        
        // Debounce
        
        // TakeDuration
        
        // Skip
        
        
        // COMBINE
        print("\n --- COMBINE StartWith ---")
        Observable.of(2,3).startWith(1).subscribe(onNext:{ print($0) })
        print("\n --- COMBINE Merge ---")
        
        let publish1 = PublishSubject<Int>()
        let publish2 = PublishSubject<Int>()
        // combina multiples observables respetando en tiempo en que crean
        Observable.of(publish1,publish2).merge().subscribe(onNext:{ print($0) })
        publish1.onNext(20)
        publish1.onNext(40)
        publish1.onNext(60)
        publish2.onNext(1)
        publish1.onNext(80)
        publish2.onNext(2)
        publish1.onNext(100)
        
        print("\n --- COMBINE ZIP ---")
        let a = Observable.of(1,2,3,4,5)
        let b = Observable.of("a","b","c","d")
        Observable.zip(a,b){ return ($0,$1) }.subscribe { print($0) }
        
        // Concat
        
        // CombineLatest
        
        // SwitchLatests
        
        
        
        /// SIDE EFFECTS
        // Si deseas registrar callbacks que se ejecutarán por ciertos eventos, utiliza doOn. No modificará los elementos emitidos pero los pasará... do(onNext:) ... do(onError:) ... do(onCompleted:)
        print("\n --- SIDE EFFECTS ---")
        Observable.of(1,2,3,4,5)
            .do(onNext: { $0 * 10 // This has no effect on the actual subscription
            })
            .subscribe(onNext:{ print($0) })
        
    } // End Ejemplos básicos.
}

