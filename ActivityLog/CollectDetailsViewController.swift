//
//  CollectDetailsViewController.swift
//  ActivityLog
//
//  Created by Shravan Sukumar on 01/06/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import UIKit

class CollectDetailsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var startTimeTextField: UITextField!
    @IBOutlet var endTimeTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    
    // MARK: - Variables
    var metaData = [String:Any]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchActiveState()
        navigationItem.title = "Enter Details"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: - Private Methods
    private func prepareSheet(with data: [String], _ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for data in data {
            actionSheet.addAction(UIAlertAction(title: data, style: .default, handler: { _ in
                sender.setTitle(data, for: .normal)
                if sender.tag == 0 {
                    self.metaData["name"] = data
                } else {
                    self.metaData["intensity"] = data
                }
                self.switchActiveState()
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func switchActiveState() {
        submitButton.isEnabled = (metaData["name"] != nil) && (metaData["intensity"] != nil) && (metaData["startTime"] != nil) && (metaData["endTime"] != nil)
    }
    
    // MARK: - IBActions
    @IBAction func activityNameButtonTapped(_ sender: UIButton) {
        prepareSheet(with: ["Running","Cycling","Jogging", "Swimming"], sender)
    }
    
    @IBAction func activityIntensityButtonTapped(_ sender: UIButton) {
        prepareSheet(with: ["Easy", "Medium", "Hard"], sender)
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: "\(metaData)", preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okayButton)
        self.resignFirstResponder()
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate
extension CollectDetailsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag {
        case 0:
            let startTime = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            metaData["startTime"] = (startTime?.count)! > 0 ? startTime : nil
            
        default:
            let endTime = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            metaData["endTime"] = (endTime?.count)! > 0 ? endTime : nil
        }
        switchActiveState()
        return true
    }
}
