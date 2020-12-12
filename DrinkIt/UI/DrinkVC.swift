//
//  ViewController.swift
//  DrinkIt
//
//  Created by Riccardo Cipolleschi on 10/12/2020.
//

import UIKit

class DrinkVC: UIViewController {

  var rootView: DrinkView {
    return self.view as! DrinkView
  }

  override func loadView() {
    let view = DrinkView()
    view.vm = DrinkVM(waterDrank: Storage.drankWater)
    self.view = view
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    self.setupInteractions()
  }

  func setupInteractions() {
    self.rootView.userDidTapAddWater = { [unowned self] in
      Storage.addWater(amount: 250)
      let vm = DrinkVM(waterDrank: Storage.drankWater)
      self.rootView.vm = vm
    }
    
    self.rootView.userDidTapRemWater = { [unowned self] in
      Storage.remWater(amount: 250)
      let vm = DrinkVM(waterDrank: Storage.drankWater)
      self.rootView.vm = vm
    }

  }
}

