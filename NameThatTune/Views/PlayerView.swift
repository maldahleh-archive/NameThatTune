//
//  PlayerView.swift
//  NameThatTune
//
//  Created by Mohammed Al-Dahleh on 2017-12-15.
//  Copyright © 2017 Mohammed Al-Dahleh. All rights reserved.
//

import UIKit

class PlayerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    weak var controller: PlayViewController?
    var picker = UIPickerView()
    var select = UIButton(type: .custom)
    var sortedSongs = [Song]()

    init(color: UIColor, songs: [Song], delegate: PlayViewController) {
        super.init(frame: .zero)
        
        picker.dataSource = self
        picker.delegate = self
        
        controller = delegate
        select.backgroundColor = color
        sortedSongs = songs.sorted()
        backgroundColor = .white
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        select.translatesAutoresizingMaskIntoConstraints = false
        addSubview(picker)
        addSubview(select)
        
        picker.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        picker.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        picker.topAnchor.constraint(equalTo: topAnchor).isActive = true
        picker.bottomAnchor.constraint(equalTo: select.topAnchor).isActive = true
        
        select.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        select.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        select.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        select.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        select.setTitle("Select Song", for: .normal)
        select.setTitleColor(.white, for: .normal)
        select.showsTouchWhenHighlighted = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortedSongs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortedSongs[row].attributes.name
    }
}
