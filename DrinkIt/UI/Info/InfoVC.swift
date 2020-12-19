//
//  InfoVC.swift
//  DrinkIt
//
//  Created by Riccardo Cipolleschi on 17/12/2020.
//

import Foundation
import SwiftUI

class InfoVC: UIHostingController<InfoView> {


  init() {
    let model = InfoVM()
    let view = InfoView(model: model)
    super.init(rootView: view)
    self.setupInteractions()
  }
  
  @objc required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupInteractions() {
    self.rootView.model.dismiss = { [unowned self] in
      self.dismiss(animated: true, completion: nil)
    }

    self.rootView.model.supportApp = { [unowned self] in
      self.rootView.model.supportingPeople = self.rootView.model.supportingPeople + 1
    }
  }
}

class InfoVM: ObservableObject {
  var dismiss: (() -> ())? = nil
  var supportApp: (() -> ())? = nil

  var waterFacts: [WaterFact] = []
  @Published var supportingPeople: Int

  init() {
    self.waterFacts = [
      .init(text: "Balance Water Fluids", color: .black),
      .init(text: "Controls Calories", color: .black),
      .init(text: "Energize Muscles", color: .white),
      .init(text: "Improve Skin Looking", color: .white),
      .init(text: "Helps Your Kidneys", color: .white)
    ]
    self.supportingPeople = 1000

  }

  struct WaterFact: Identifiable {
    var id: String {
      return text
    }

    let text: String
    let color: Color
  }
}
