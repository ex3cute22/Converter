//
//  ConverterController.swift
//  Converter
//
//  Created by Илья Викторов on 24.09.2021.
//

import UIKit

class ConverterController: UIViewController{
    
    @IBOutlet weak var labelFromCoursesForDate: UILabel!
    
    @IBOutlet weak var buttonFrom: UIButton!
    @IBOutlet weak var buttonTo: UIButton!
    
    @IBAction func pushFromAction(_ sender: Any) {
       let nc = storyboard?.instantiateViewController(identifier: "selectedCurrencyNSID") as! UINavigationController
        (nc.viewControllers[0] as! SelectCurrencyController).flagCurrency = .from
        nc.modalPresentationStyle = .fullScreen
        present(nc, animated: true, completion: nil)
    }
    
    @IBAction func pushToAction(_ sender: Any) {
        let nc = storyboard?.instantiateViewController(identifier: "selectedCurrencyNSID") as! UINavigationController
         (nc.viewControllers[0] as! SelectCurrencyController).flagCurrency = .to
        nc.modalPresentationStyle = .fullScreen
         present(nc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var textFrom: UITextField!
    @IBOutlet weak var textTo: UITextField!

    @IBAction func textFromEditingChanged(_ sender: Any) {
        
        let amount = Double(textFrom.text!)
        
        textTo.text
            = Model.shared.convert(amount: amount)

    }
    @IBOutlet weak var buttonDone: UIBarButtonItem!
    
    @IBAction func pushDone(_ sender: Any) {
        textFrom.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
    }
    
    @IBOutlet weak var btnSwipeCourses: UIButton!
    @IBAction func swipeCoursesAction(_ sender: Any) {
        
        UIView.animate(withDuration: 0.25, animations: { [self] in
            
            btnSwipeCourses.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            btnSwipeCourses.imageView?.transform = .identity
            //self.btnSwipeCourses.imageView?.transform.rotated(by: .pi)
        })
                
        (textFrom.text, textTo.text) = (textTo.text, textFrom.text)
        
        let temp = buttonFrom.titleLabel?.text
        buttonFrom.setTitle(buttonTo.titleLabel?.text, for: UIControl.State.normal)
        buttonTo.setTitle(temp, for: UIControl.State.normal)
        
        let temp_cur = Model.shared.fromCurrency
        Model.shared.fromCurrency = Model.shared.toCurrency
        Model.shared.toCurrency = temp_cur
        
        let amount = Double(textFrom.text!)
        textTo.text = Model.shared.convert(amount: amount)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFrom.delegate = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        refreshButtons()
        textFromEditingChanged(self)
        
    }

    func refreshButtons(){
        
        buttonFrom.setTitle(Model.shared.fromCurrency.CharCode, for: UIControl.State.normal)
        buttonTo.setTitle(Model.shared.toCurrency.CharCode, for: UIControl.State.normal)
    }
}

extension ConverterController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        navigationItem.rightBarButtonItem = buttonDone
        return true
    }
}
