//
//  SettingsController.swift
//  Converter
//
//  Created by Илья Викторов on 23.09.2021.
//

import UIKit

class SettingsController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!

    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showCourses(_ sender: Any) {
        
        Model.shared.loadXMLFile(date: datePicker.date)
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var btnShowCourses: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


}
