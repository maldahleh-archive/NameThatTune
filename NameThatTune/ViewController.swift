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
        button.setTitle("Play!", for: .normal)
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
    }
    
    @objc func startGame() {
        
    }
    
    func requestCapabailities() {
        
    }
    
    func showNoGameMessage(_ message: String) {
        
    }
}
