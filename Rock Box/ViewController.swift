//
//  ViewController.swift
//  Rock Box
//
//  Created by Steve Sparks on 7/11/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addBox(CGRectMake(100, 100, 30, 30))
        createAnimatorStuff()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var box : UIView?

    func addBox(location: CGRect) {
        let newBox = UIView(frame: location)
        newBox.backgroundColor = UIColor.redColor()

        view.insertSubview(newBox, atIndex: 0)
        box = newBox
    }

    var animator:UIDynamicAnimator? = nil;
    let gravity = UIGravityBehavior()

    let collider = UICollisionBehavior()

    func createAnimatorStuff() {
        animator = UIDynamicAnimator(referenceView:self.view);

        gravity.gravityDirection = CGVectorMake(0, 0.8)
        gravity.addItem(box);
        animator?.addBehavior(gravity);

        collider.addItem(box)
        // We're bouncin' off the walls
        collider.translatesReferenceBoundsIntoBoundary = true
        animator?.addBehavior(collider)
    }


}

