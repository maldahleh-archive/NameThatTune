//
//  ViewController.swift
//  NameThatTune
//
//  Created by Mohammed Al-Dahleh on 2017-12-15.
//  Copyright © 2017 Mohammed Al-Dahleh. All rights reserved.
//

import UIKit
import GameplayKit
import StoreKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addStartButton(to: self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController {
    func addStartButton(to view: UIView) {
        let button = UIButton()
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        
        button.setTitle("Play!", for: .normal)
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
    }
    
    @objc func startGame() {
        switch SKCloudServiceController.authorizationStatus() {
        case .authorized: requestCapabailities()
        case .notDetermined:
            SKCloudServiceController.requestAuthorization { [weak self] authorizationStatus in
                DispatchQueue.main.async {
                    self?.startGame()
                }
            }
        default: showNoGameMessage("We don't have permission to use your Apple Music library.")
        }
    }
    
    func requestCapabailities() {
        
    }
    
    func showNoGameMessage(_ message: String) {
        let alertController = UIAlertController(title: "Can't Play!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}
