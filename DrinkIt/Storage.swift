//
//  Storage.swift
//  DrinkIt
//
//  Created by Riccardo Cipolleschi on 12/12/2020.
//

import WidgetKit
import Foundation

class Storage {
  private static var drankWaterSemaphore = DispatchSemaphore(value: 1)
  private static var drankWaterKey = "drank_water_key"

  private(set) static var drankWater: Int {
    get {
      guard let userDefaults = UserDefaults(suiteName: "group.app.drinkit") else {
        fatalError("group not properly configured")
      }
      return userDefaults.integer(forKey: Self.drankWaterKey)
    }
    set {
      guard let userDefaults = UserDefaults(suiteName: "group.app.drinkit") else {
        fatalError("group not properly configured")
      }
      userDefaults.setValue(newValue, forKey: Self.drankWaterKey)
    }
  }

  private static func updateDrankWater(closure: @escaping (_ oldValue: Int) -> Int) {
    Self.drankWaterSemaphore.wait()
    let oldValue = Self.drankWater
    let newValue = closure(oldValue)
    self.drankWater = newValue
    WidgetCenter.shared.reloadAllTimelines()
    Self.drankWaterSemaphore.signal()
  }

  static func addWater(amount: Int) {
    Storage.updateDrankWater { return $0 + amount }
  }

  static func remWater(amount: Int) {
    Storage.updateDrankWater { return max($0 - amount, 0) }
  }
}
