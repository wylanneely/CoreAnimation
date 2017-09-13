//
//  DropItVeiw.swift
//  StanfordAnimations
//
//  Created by ALIA M NEELY on 9/12/17.
//  Copyright © 2017 Wylan. All rights reserved.
//

import UIKit

class DropItVeiw: UIView, UIDynamicAnimatorDelegate {
    
    private lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self)
        animator.delegate = self
        return animator
    }()
    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        removeCompletedRow()
    }
    
    private let dropBehavior = FallingItemBehavior()
    
    var animating: Bool = false {
        
        didSet {
            if animating {
                animator.addBehavior(dropBehavior)
            } else {
                animator.removeBehavior(dropBehavior)
            }
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
        let path = UIBezierPath(ovalIn: CGRect(center: bounds.mid, size: dropSize))
        dropBehavior.addBarrier(path: path, named: PathNames.MiddleBarrier)
    }
    
    func grabDrop(recognizer: UIPanGestureRecognizer) {
        let gesturePoint = recognizer.location(in: self)
        switch recognizer.state {
        case .began: if let dropToAttatchTo = lastDrop, dropToAttatchTo.superview != nil {
            attachment = UIAttachmentBehavior(item: dropToAttatchTo, attachedToAnchor: gesturePoint)
            }
            lastDrop = nil
            
        case .changed: attachment?.anchorPoint = gesturePoint
            
        default: attachment = nil
        }
        
    }
    
    
    func removeCompletedRow() {
        var dropsToRemove = [UIView]()
        
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
                dropsToRemove += dropsFound
            }
        } while dropsToRemove.count == 0 && hitTestRect.origin.y > bounds.minY
        
        for drop in dropsToRemove {
            dropBehavior.removeItem(item: drop)
            drop.removeFromSuperview()
        }
    }

    private var lastDrop: UIView?
    
    func addDrop() {
        var frame = CGRect(origin: CGPoint.zero, size: dropSize)
        frame.origin.x = CGFloat.random(max: dropsPerRow) * dropSize.width
        
        let drop = UIView(frame: frame)
        drop.backgroundColor = UIColor.random
        addSubview(drop)
        dropBehavior.addItem(item: drop)
        lastDrop = drop
    }
}
