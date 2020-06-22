//
//  PopupShowable.swift
//  YouTubeAPI
//
//  Created by Shlykov Danylo on 6/16/20.
//  Copyright © 2020 Shlykov Danylo. All rights reserved.
//
import UIKit

protocol PopupShowable {
    func showPopup(with title: String?, text: String)
    func showErrorPopup(with text: String)
}

extension PopupShowable where Self: UIViewController {
    func showPopup(with title: String?, text: String) {
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    func showErrorPopup(with text: String) {
        showPopup(with: "Ошибка", text: text)
    }
 }
