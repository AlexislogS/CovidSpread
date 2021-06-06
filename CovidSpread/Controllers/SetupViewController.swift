//
//  SetupViewController.swift
//  CovidSpread
//
//  Created by Alex Yatsenko on 07.06.2021.
//

import UIKit

class SetupViewController: UIViewController {

  @IBOutlet private weak var scrollView: UIScrollView!
  @IBOutlet private weak var groupSizeTextField: UITextField!
  @IBOutlet private weak var infectionFactorTextField: UITextField!
  @IBOutlet private weak var nextButton: UIButton! { didSet { configureButton(button: nextButton) } }
  @IBOutlet private weak var timeButton: UIButton! { didSet { configureButton(button: timeButton) } }
  
  private func configureButton(button: UIButton) {
    button.titleLabel?.adjustsFontSizeToFitWidth = true
    button.titleLabel?.minimumScaleFactor = 0.3
  }
  
  private var currentTime: (Int, Int) = (0,1)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleKeyboard(_:)),
      name: UITextField.keyboardDidShowNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleKeyboard(_:)),
      name: UITextField.keyboardDidHideNotification,
      object: nil
    )
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let picker = segue.destination as? TimePickerViewController {
      picker.popoverPresentationController?.delegate = self
      picker.minutes = currentTime.0
      picker.seconds = currentTime.1
      picker.handleInputDate = { [weak self] (minutes, seconds) in
        self?.currentTime = (minutes, seconds)
        self?.timeButton.setTitle("\(minutes) : \(seconds)", for: .normal)
      }
    }
    if let infectionVC = segue.destination as? InfectionCollectionViewController,
       let numberOfPersons = Int(groupSizeTextField.text ?? ""),
       let infectionFactor = Int(infectionFactorTextField.text ?? "") {
      infectionVC.numberOfPersons = numberOfPersons
      infectionVC.infectionFactor = infectionFactor
      infectionVC.period = TimeInterval(currentTime.0 * 60 + currentTime.1)
    }
  }
  
  @IBAction private func updateTextFields() {
    nextButton.isEnabled = isFilled(textField: groupSizeTextField) && isFilled(textField: infectionFactorTextField)
    nextButton.alpha = isFilled(textField: groupSizeTextField) && isFilled(textField: infectionFactorTextField) ? 1 : 0.5
  }
  
  private func isFilled(textField: UITextField) -> Bool {
    guard textField.hasText else { return false }
    if !(textField.text!.trimmingCharacters(in: .whitespaces)).isEmpty {
      return true
    }
    return false
  }
  
  func showAlert(title: String? = nil, message: String? = nil, completion: (() -> Void)? = nil) {
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
      completion?()
    }))
    present(alert, animated: true)
  }
  
  @objc private func handleKeyboard(_ note: Notification) {
    guard let frame = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
    guard let curve = UIView.AnimationCurve(rawValue: (note.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int ?? -1) & 3) else { return }
    guard let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
    let center = CGPoint(x: frame.midX, y: frame.midY)
    let opts: UIView.AnimationOptions
    switch curve {
    case .easeIn: opts = .curveEaseIn
    case .easeOut: opts = .curveEaseOut
    case .easeInOut: opts = .curveEaseInOut
    case .linear: opts = .curveLinear
    @unknown default: opts = .curveLinear
    }
    let inset: CGFloat
    if let window = scrollView.window, window.bounds.contains(center) {
      let bounds = window.convert(window.bounds, to: scrollView)
      let bottomSpace = bounds.maxY - scrollView.bounds.maxY
      inset = max(0, min(frame.width, frame.height) - bottomSpace)
    } else {
      inset = 0
    }
    UIView.animate(withDuration: duration, delay: 0, options: opts, animations: {
      self.scrollView.contentInset.bottom = inset
    }, completion: nil)
  }
}

extension SetupViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
    case groupSizeTextField:
      infectionFactorTextField.becomeFirstResponder()
    case infectionFactorTextField:
      infectionFactorTextField.resignFirstResponder()
    default:
      break
    }
    return true
  }
}

extension SetupViewController: UIPopoverPresentationControllerDelegate {
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
  }
}
