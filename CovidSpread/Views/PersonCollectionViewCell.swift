//
//  PersonCollectionViewCell.swift
//  CovidSpread
//
//  Created by Alex Yatsenko on 07.06.2021.
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell {

  override var isHighlighted: Bool { didSet { setSelected() } }
  override var isSelected: Bool {
    didSet {
      contentView.backgroundColor = isSelected ? .systemRed : .systemGreen
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = bounds.width / 2
  }
  
  private func setSelected() {
    let animator = UIViewPropertyAnimator(duration: 0.7, dampingRatio: 0.4) {
      self.transform = self.isHighlighted ? .init(scaleX: 0.9, y: 0.9) : .identity
    }
    animator.startAnimation()
  }
}
