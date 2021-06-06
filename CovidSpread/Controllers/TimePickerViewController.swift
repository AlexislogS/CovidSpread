//
//  TimePickerViewController.swift
//  CovidSpread
//
//  Created by Alex Yatsenko on 07.06.2021.
//

import UIKit

class TimePickerViewController: UIViewController {
  
  @IBOutlet private weak var picker: UIPickerView!
  
  var minutes: Int = 0
  var seconds: Int = 1
  var handleInputDate: ((Int, Int) -> Void)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    picker.selectRow(minutes, inComponent: 0, animated: false)
    picker.selectRow(seconds, inComponent: 1, animated: false)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    handleInputDate?(minutes, seconds)
  }
}

extension TimePickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 2
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return 60
  }
  
  func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
    return pickerView.frame.size.width/2
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    switch component {
    case 0:
      return "\(row) минут"
    case 1:
      return "\(row) секунд"
    default:
      return ""
    }
  }
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    switch component {
    case 0:
      minutes = row
    case 1:
      seconds = row
    default:
      break
    }
  }
}
