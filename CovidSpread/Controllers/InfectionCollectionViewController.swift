//
//  InfectionCollectionViewController.swift
//  CovidSpread
//
//  Created by Alex Yatsenko on 07.06.2021.
//

import UIKit

class InfectionCollectionViewController: UICollectionViewController,
                                         UICollectionViewDelegateFlowLayout {
  
  var numberOfPersons = 100
  var infectionFactor = 3
  var period: TimeInterval = 1
  private lazy var persons = getPersons()
  private var sickPersons = Set<Int>()
  private var timer: Timer?
  private var itemsPerRow: CGFloat = 4
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.allowsMultipleSelection = true
    collectionView.allowsMultipleSelectionDuringEditing = true
    collectionView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(recognizer:))))
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    timer = Timer.scheduledTimer(withTimeInterval: period,
                                 repeats: true) { [weak self] _ in
      DispatchQueue.global(qos: .userInitiated).async {
        self?.infectPersons()
        DispatchQueue.main.async {
          self?.collectionView.reloadData()
        }
      }
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    timer?.invalidate()
  }
  
  override func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
    return persons.count
  }
  
  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "person", for: indexPath)
    (cell as? PersonCollectionViewCell)?.isSelected = sickPersons.contains(indexPath.row)
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView,
                               viewForSupplementaryElementOfKind kind: String,
                               at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
    let health = persons.filter({ !$0.isSick }).count
    let sick = persons.filter({ $0.isSick }).count
    (header as? InfectionHeader)?.configure(healthPersonsQuantity: health, sickPersonsQuantity: sick)
    return header
  }
  
  override func collectionView(_ collectionView: UICollectionView,
                               shouldDeselectItemAt indexPath: IndexPath) -> Bool {
    return false
  }
  
  override func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
    sickPersons.insert(indexPath.row)
    collectionView.cellForItem(at: indexPath)?.isSelected = sickPersons.contains(indexPath.row)
    persons[indexPath.row].isSick = sickPersons.contains(indexPath.row)
  }
  
  @IBAction private func refreshButtonPressed(_ sender: UIBarButtonItem) {
    persons = getPersons()
    sickPersons.removeAll()
    collectionView.reloadData()
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
    let clientWidth = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right
    let contentWidth = clientWidth - layout.sectionInset.left - layout.sectionInset.right
    let itemWidth = ((contentWidth - (itemsPerRow - 1) * layout.minimumInteritemSpacing) / itemsPerRow).rounded(.down)
    return CGSize(width: itemWidth, height: itemWidth)
  }
  
  private func getPersons() -> [Person] {
    guard numberOfPersons >= 0 else { return [] }
    return (1...numberOfPersons).map { _ in Person() }
  }
  
  private func infectPersons() {
    guard infectionFactor > 0 else { return }
    for (index, person) in persons.enumerated() {
      if person.isSick {
        let quantity = Int.random(in: (1...infectionFactor))
        for number in 1...quantity {
          persons[unsafe: index - number]?.isSick = true
          persons[unsafe: index + number]?.isSick = true
          sickPersons.insert(index - number)
          sickPersons.insert(index + number)
        }
      }
    }
  }
  
  @objc private func handlePinch(recognizer: UIPinchGestureRecognizer) {
    if recognizer.state == .changed || recognizer.state == .ended {
      itemsPerRow = recognizer.scale.rounded(.up)
      UIView.animate(withDuration: 0.5) {
        self.collectionView.collectionViewLayout.invalidateLayout()
      }
    }
  }
}
