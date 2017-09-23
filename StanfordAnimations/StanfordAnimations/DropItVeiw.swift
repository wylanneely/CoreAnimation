//
//  DropItVeiw.swift
//  StanfordAnimations
//
//  Created by ALIA M NEELY on 9/12/17.
//  Copyright © 2017 Wylan. All rights reserved.
//

import UIKit
import CoreMotion

class DropItVeiw: UIView, UIDynamicAnimatorDelegate {
    
    private lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self)
        animator.delegate = self
        return animator
    }()
    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        removeCompletedRow()
    }
    
    var animating: Bool = false {
        didSet {
            if animating {
                animator.addBehavior(dropBehavior)
            } else {
                animator.removeBehavior(dropBehavior)
            }
        }
    }
    
    private let dropBehavior = FallingItemBehavior()
private let motionManager = CMMotionManager()
            //MARK: - Gravity
    
    var realGravity: Bool = false {
        didSet {
            updateRealGravity()
        }
    }
    
    private func updateRealGravity(){
        if realGravity {
            if motionManager.isAccelerometerAvailable && !motionManager.isAccelerometerActive {
                motionManager.accelerometerUpdateInterval = 0.25
                motionManager.startAccelerometerUpdates(to: OperationQueue.main, withHandler: { [unowned self] (data, error) in
                    if let dx = data?.acceleration.x, let dy = data?.acceleration.y {
                        self.dropBehavior.gravity.gravityDirection = CGVector(dx: dx, dy: dy)
                    }
                })
            }
        }
        else  { motionManager.stopAccelerometerUpdates()
        }
    
    }
    
    
    
    private var attachment: UIAttachmentBehavior? {
        willSet {
            if attachment != nil {
                animator.removeBehavior(attachment!)
            }
        }
        
        didSet {
            if attachment != nil {
                animator.addBehavior(attachment!)
            }
        }
    }

    private let dropsPerRow = 10
    
    private var dropSize: CGSize {
        let size = bounds.size.width / CGFloat(dropsPerRow)
        return CGSize(width: size, height: size)
    }
    
    private struct PathNames {
        static let MiddleBarrier = "Middle Barrier"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

  //      let path = UIBezierPath(ovalIn: CGRect(center: bounds.mid, size: dropSize))
//        dropBehavior.addBarrier(path: path, named: PathNames.MiddleBarrier)
    }
    
    func grabDrop(recognizer: UIPanGestureRecognizer) {
        let gesturePoint = recognizer.location(in: self)
        switch recognizer.state {
        case .began: if let dropToAttatchTo = lastDrop, dropToAttatchTo.superview != nil {
            
            attachment = UIAttachmentBehavior(item: dropToAttatchTo, attachedToAnchor: gesturePoint)
            
            }
           // lastDrop = nil
            
        case .changed: attachment?.anchorPoint = gesturePoint
            
        default: attachment = nil
        }
        
    }
    
    
    func removeCompletedRow() {
        var dropsInCompleteRow = [UIView]()
        var dropsToDelete = [UIView]()
        var previousDropInRowColor: UIColor? = nil
        
        var hitTestRect = CGRect(origin: bounds.lowerLeft, size: dropSize)
        repeat {
            hitTestRect.origin.x = bounds.minX
            hitTestRect.origin.y -= dropSize.height
            var dropsTested = 0
            var dropsFound = [UIView]()
            while dropsTested < dropsPerRow {
                if let hitView = hitTest(p: hitTestRect.mid), hitView.superview == self {
                    dropsFound.append(hitView)
                } else {
                    break
                }
                hitTestRect.origin.x += dropSize.width
                dropsTested += 1
            }
            if dropsTested == dropsPerRow {
                dropsInCompleteRow += dropsFound
            }
        } while dropsInCompleteRow.count == 0 && hitTestRect.origin.y > bounds.minY
        
        for drop in dropsInCompleteRow {
    
            if drop.backgroundColor == previousDropInRowColor || previousDropInRowColor == nil {
                dropsToDelete.append(drop)
                    previousDropInRowColor = drop.backgroundColor
                    
                } else {
                
            }
        }
        
        if dropsToDelete.count == dropsPerRow {
            for drop in dropsToDelete {
                dropBehavior.removeItem(item: drop)
                drop.removeFromSuperview()
            }
        }
        
    }

    private var lastDrop: UIView?
    
    func addDrop() {
        var frame = CGRect(origin: CGPoint.zero, size: dropSize)
        frame.origin.x = CGFloat.random(max: dropsPerRow) * dropSize.width
        
        let drop = UIView(frame: frame)
        drop.backgroundColor = UIColor.green
        addSubview(drop)
        dropBehavior.addItem(item: drop)
        lastDrop = drop
    }
    
    func addBlueDrop() {
        var frame = CGRect(origin: CGPoint.zero, size: dropSize)
        frame.origin.x = CGFloat.random(max: dropsPerRow) * dropSize.width
        
        let drop = UIView(frame: frame)
        drop.backgroundColor = UIColor.blue
        addSubview(drop)
        dropBehavior.addItem(item: drop)
        lastDrop = drop
    }
    
    
    
    
}
