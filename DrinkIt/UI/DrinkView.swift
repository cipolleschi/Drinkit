//
//  DrinkView.swift
//  DrinkIt
//
//  Created by Riccardo Cipolleschi on 10/12/2020.
//

import Foundation
import UIKit

// MARK: - VM
struct DrinkVM {
  let waterDrank: Int
  let goal = 2000

  init(waterDrank: Int) {
    self.waterDrank = waterDrank
  }

  var goalMessage: String {
    if waterDrank >= goal {
      return "Goal Achieved! Water drank today: \(CGFloat(waterDrank) / 1000.0) L"
    }

    return "Water to the goal: \(CGFloat(self.goal - self.waterDrank) / 1000.0) L"
  }

  var ratio: CGFloat {
    return CGFloat(self.waterDrank) / CGFloat(self.goal)
  }

  func animationDuration(oldModel: DrinkVM?) -> TimeInterval {
    guard let oldModel = oldModel else {
      return 0.0
    }
    return self.waterDrank != oldModel.waterDrank ? 0.3 : 0.0
  }
}

// MARK: - View
class DrinkView: UIView {
  var vm: DrinkVM? {
    didSet {
      self.update(oldModel: oldValue)
    }
  }

  fileprivate let targetLabel = UILabel()
  fileprivate let addButton = UIButton()
  fileprivate let remButton = UIButton()
  fileprivate let backgroundRect = UIView()
  fileprivate let foregroundRect = UIView()
  fileprivate let infoButton = UIButton()

  var userDidTapAddWater: (() -> ())?
  var userDidTapRemWater: (() -> ())?
  var userDidTapInfo: (() -> ())?

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
    self.style()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup() {
    self.addSubview(self.targetLabel)
    self.addSubview(self.addButton)
    self.addSubview(self.remButton)
    self.addSubview(self.backgroundRect)
    self.backgroundRect.addSubview(self.foregroundRect)
    self.addSubview(self.infoButton)

    self.addButton.addTarget(self, action: #selector(self.addButtontapped), for: .touchUpInside)
    self.remButton.addTarget(self, action: #selector(self.remButtontapped), for: .touchUpInside)
    self.infoButton.addTarget(self, action: #selector(self.infoButtonTapped), for: .touchUpInside)

  }

  @objc func addButtontapped(_ sender: UIButton) {
    self.userDidTapAddWater?()
  }

  @objc func remButtontapped(_ sender: UIButton) {
    self.userDidTapRemWater?()
  }

  @objc func infoButtonTapped(_ sender: UIButton) {
    self.userDidTapInfo?()
  }

  func style() {
    self.backgroundColor = .white
    self.addButton.setTitle("+", for: .normal)
    self.addButton.setTitleColor(.systemBlue, for: .normal)

    self.remButton.setTitle("-", for: .normal)
    self.remButton.setTitleColor(.systemBlue, for: .normal)

    self.backgroundRect.layer.borderWidth = 2
    self.backgroundRect.layer.borderColor = UIColor.black.cgColor
    self.backgroundRect.backgroundColor = .clear

    self.foregroundRect.backgroundColor = .systemBlue

    self.infoButton.setImage(UIImage(systemName: "info"), for: .normal)
    self.infoButton.tintColor = .systemBlue

  }

  func update(oldModel: DrinkVM?) {
    guard let model = self.vm else {
      return
    }

    self.targetLabel.text = model.goalMessage
    self.targetLabel.textColor = .systemBlue

    self.setNeedsLayout()
    UIView.animate(
      withDuration: model.animationDuration(oldModel: oldModel),
      delay: 0,
      options: [.curveEaseInOut]
    ){ [unowned self] in
      self.layoutIfNeeded()
    } completion: { _ in }
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    self.infoButton.frame = .init(
      x: self.bounds.width - 20 - 44,
      y: self.safeAreaInsets.top + 20,
      width: 44,
      height: 44
    )

    self.targetLabel.frame = .zero
    self.targetLabel.sizeToFit()
    self.targetLabel.frame = CGRect(
      x: (self.bounds.width - self.targetLabel.frame.size.width) / 2 ,
      y: 100,
      width: self.targetLabel.frame.size.width,
      height: self.targetLabel.frame.size.height
    )

    let buttonSide: CGFloat = 80

    self.addButton.frame = CGRect(
      x: self.bounds.width / 2 + buttonSide / 4,
      y: self.bounds.height - buttonSide - 100,
      width: buttonSide,
      height: buttonSide
    )

    self.remButton.frame = CGRect(
      x: self.bounds.width / 2 - buttonSide / 4 - buttonSide,
      y: self.addButton.frame.minY,
      width: buttonSide,
      height: buttonSide
    )

    self.backgroundRect.frame = CGRect(
      x: self.bounds.width / 2 - 101,
      y: self.targetLabel.frame.maxY + 19,
      width: 202,
      height: self.addButton.frame.minY - self.targetLabel.frame.maxY - 42
    )

    guard let model = self.vm else {
      self.foregroundRect.frame = CGRect(
        x: 1,
        y: self.backgroundRect.frame.height - 1,
        width: 200,
        height: 0
      )
      return
    }

    let rectHeight = min(self.backgroundRect.frame.height * model.ratio, self.backgroundRect.frame.height - 2)
    self.foregroundRect.frame = CGRect(
      x: 1,
      y: self.backgroundRect.frame.height - 1 - rectHeight,
      width: 200,
      height: rectHeight
    )
  }
}
