//
//  FallingItemBehavior.swift
//  StanfordAnimations
//
//  Created by ALIA M NEELY on 9/12/17.
//  Copyright © 2017 Wylan. All rights reserved.
//

import UIKit

class FallingItemBehavior: UIDynamicBehavior {

    var gravity = UIGravityBehavior()
    private let collider: UICollisionBehavior = {
        let collider = UICollisionBehavior()
        collider.translatesReferenceBoundsIntoBoundary = true
        return collider
    }()
    private let itemBehavior: UIDynamicItemBehavior = {
        let dib = UIDynamicItemBehavior()
        dib.allowsRotation = false
        dib.elasticity = 0.6
        return dib
    }()
    
    func addBarrier(path: UIBezierPath, named name: String) {
        collider.removeBoundary(withIdentifier: name as NSCopying)
        collider.addBoundary(withIdentifier: name as NSCopying, for: path)
    }
    
    override init() {
         super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(itemBehavior)
    }
    
    func addItem(item: UIDynamicItem){
        gravity.addItem(item)
        collider.addItem(item)
        itemBehavior.addItem(item)
    }
    
    func removeItem(item: UIDynamicItem){
        gravity.removeItem(item)
        collider.removeItem(item)
        itemBehavior.removeItem(item)
    }
}
