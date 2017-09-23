//
//  DropItViewController.swift
//  StanfordAnimations
//
//  Created by ALIA M NEELY on 9/12/17.
//  Copyright © 2017 Wylan. All rights reserved.
//

import UIKit

class DropItViewController: UIViewController {
    
    @IBOutlet weak var gameView: DropItVeiw! {
        didSet {
            gameView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addDrop(recognizer:))))
            gameView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(addBlueDrop(recognizer:))))
            gameView.realGravity = true
            gameView.addGestureRecognizer(UIPanGestureRecognizer(target: gameView, action: #selector(DropItVeiw.grabDrop(recognizer:))))
        }
    }
    
    func addBlueDrop(recognizer: UILongPressGestureRecognizer){
        if recognizer.state == .ended {
            
            gameView.addBlueDrop()
        }
    }
    
    func addDrop(recognizer: UITapGestureRecognizer){
        if recognizer.state == .ended {
            
            gameView.addDrop()
        }
        
        if recognizer.numberOfTouches == 2 {
            print("2")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameView.animating = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        gameView.animating = false
    }
}
