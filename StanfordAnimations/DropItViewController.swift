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
            gameView.addGestureRecognizer(UIPanGestureRecognizer(target: gameView, action: #selector(DropItVeiw.grabDrop(recognizer:))))
        }
    }
    
    func addDrop(recognizer: UITapGestureRecognizer){
        if recognizer.state == .ended {
            gameView.addDrop()
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
