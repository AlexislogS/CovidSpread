//
//  InfectionHeader.swift
//  CovidSpread
//
//  Created by Alex Yatsenko on 07.06.2021.
//

import UIKit

class InfectionHeader: UICollectionReusableView {
  
  @IBOutlet private weak var healthPeopleQuantityLabel: UILabel!
  @IBOutlet private weak var sickPeopleQuantityLabel: UILabel!
  
  func configure(healthPersonsQuantity: Int, sickPersonsQuantity: Int) {
    healthPeopleQuantityLabel.text = String(healthPersonsQuantity)
    sickPeopleQuantityLabel.text = String(sickPersonsQuantity)
  }
}
