//
//  ViewController.swift
//  First App
//
//  Created by Admin on 2017-10-03.
//  Copyright © 2017 Pujan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var sliderValueLabel: UILabel!
    @IBOutlet weak var numSlider: UISlider!
    @IBOutlet weak var switchOne: UISwitch!
    @IBOutlet weak var switchTwo: UISwitch!
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var doSomethingBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Handle inputs as delegate callbacks
        initialize()
        nameTextField.delegate = self
        numberTextField.delegate = self
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
    }
    func initialize(){
        numSlider.value = 0.5
        sliderValueLabel.text = "50"
        doSomethingBtn.isHidden = true
        

    }
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == numberTextField{
            let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
            return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
        }
        return true
    }

    @IBAction func numSlider(_ sender: Any) {
        sliderValueLabel.text = "\(Int(numSlider.value*100))"
    }
    @IBAction func setNumBth(_ sender: UIButton) {
        updateNumberLabel(numberTextField.text!)
    }

    private func updateNameLabel(_ input: String) {
        if input.count <= 0 {
            nameLabel.text = "The name has been cleared"
            return
        }
        else{
            nameLabel.text = "Hello, \(input)"
        }
    }
    
    private func updateNumberLabel(_ input: String) {
        if(input.isEmpty == true) {
            numberLabel.text = "The number has been cleared"
            return
        }
        else{
            numberLabel.text = "The number typed in is: \(input)"
        }
    }
    
    @IBAction func switchControl(_ sender: UISwitch) {
        switchOne.setOn(sender.isOn, animated: true)
        switchTwo.setOn(sender.isOn, animated: true)
    }
    
    @IBAction func doSomethingClicked(_ sender: Any) {
        let alertController = UIAlertController(title: "Something was done", message: "Everything's fine. You can breathe easy now and continue", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }

    
    @IBAction func segmentChanger(_ sender: UISegmentedControl) {
        if segControl.selectedSegmentIndex == 0 {
            doSomethingBtn.isHidden = true
            switchOne.isHidden = false
            switchTwo.isHidden = false
        }
        if segControl.selectedSegmentIndex == 1 {
            doSomethingBtn.isHidden = false
            switchOne.isHidden = true
            switchTwo.isHidden = true
        }
    }
    
    @IBAction func namePrimaryActionTriggered(_ sender: Any) {
        updateNameLabel(nameTextField.text!)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTextField {
            updateNameLabel(nameTextField.text!)
        }
        if textField == numberTextField {
            updateNumberLabel(numberTextField.text!)
        }
    }

}

