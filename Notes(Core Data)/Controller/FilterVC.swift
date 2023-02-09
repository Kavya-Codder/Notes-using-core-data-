//
//  FilterVC.swift
//  Notes(Core Data)
//
//  Created by Sunil Developer on 16/01/23.
//

import UIKit
protocol FilterData {
    func featchData(filterNotes: [Notes])
}

class FilterVC: UIViewController {

    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var txtStatus: UITextField!
    @IBOutlet weak var txtPriority: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var viewPriority: UIView!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblPriority: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    var dbobject: DBHelper = DBHelper()
    var noteData: [Notes] = []
    
    // pickerView variable
    var datePicker = UIDatePicker()
    var priorityPicker: UIPickerView!
    var statusPicker: UIPickerView!
    
    var statusArray = ["Pending", "In Progress", "Completed"]
    var priorityArray = ["Low", "Normal", "High", "Urgent"]
    var currentTextField = UITextField()
    
    // protocol delegate
    var featchDataDelegate: FilterData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       initialSetUp()
        
        //DatePickerView
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        }
        datePicker.backgroundColor = .lightGray
        datePicker.datePickerMode =  .date
       // datePicker.maximumDate = Date()
        
        //ToolBar
        let toolbar = UIToolbar()
        toolbar.barTintColor = UIColor(named: "colour-5")
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneDatePicker))
        doneButton.tintColor = .white
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        cancelButton.tintColor = .white
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        txtDate.inputAccessoryView = toolbar
        txtDate.inputView = datePicker
        
        // status pickerview
        statusPicker = UIPickerView()
        statusPicker.delegate = self
        statusPicker.dataSource = self
        
        txtStatus.inputView = statusPicker
        txtStatus.text = statusArray.first
        txtStatus.delegate = self
        
        // Priority pickerview
        priorityPicker = UIPickerView()
        priorityPicker.delegate = self
        priorityPicker.dataSource = self
        
        txtPriority.inputView = priorityPicker
        txtPriority.text = priorityArray.first
        txtPriority.delegate = self
    }
    
    // datePicker function
    @objc func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM YYYY 'at' HH:mm"
        txtDate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
    }
    @objc func cancelDatePicker() {
        self.view.endEditing(false)
    }
    
    @IBAction func onClickSearchBtn(_ sender: Any) {
        noteData = filterList()
        print("in filtervc", noteData.count)
        self.featchDataDelegate.featchData(filterNotes: noteData)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onClickCancleBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
// extension

extension FilterVC: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
        if textField == txtStatus {
            txtStatus.inputView = statusPicker
        } else {
            txtPriority.inputView = priorityPicker
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentTextField == txtStatus {
            return statusArray.count
        } else if currentTextField == txtPriority {
            return priorityArray.count
        }
        else {
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentTextField == txtStatus {
            return statusArray[row]
        } else if currentTextField == txtPriority {
            return priorityArray[row]
        }
        else {
            return "0"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentTextField == txtStatus {
            txtStatus.text = statusArray[row]
            self.view.endEditing(true)
        } else if currentTextField == txtPriority {
            txtPriority.text = priorityArray[row]
            self.view.endEditing(true)
        }
        
    }
    
     func filterList() -> [Notes] {
          if currentTextField == txtDate {
            return  dbobject.filter(text: txtDate.text ?? "")
          } else if currentTextField == txtPriority {
              return  dbobject.filter(text: txtPriority.text ?? "")
          } else {
              return  dbobject.filter(text: txtStatus.text ?? "")
          }
      }
     
    func initialSetUp() {
        viewContainer.clipsToBounds = true
        viewContainer.layer.cornerRadius = 20
        viewContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        btnSearch.clipsToBounds = true
        btnSearch.layer.cornerRadius = 15
    }
    
}
