//
//  ViewController.swift
//  Rock Box
//
//  Created by Steve Sparks on 7/11/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    // Most conservative guess. We'll set them later.
    var maxX : CGFloat = 320;
    var maxY : CGFloat = 320;
    let boxSize : CGFloat = 30.0
    var boxes : Array<UIView> = []

    // For getting device motion updates
    let motionQueue = NSOperationQueue()
    let motionManager = CMMotionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        maxX = super.view.bounds.size.width - boxSize;
        maxY = super.view.bounds.size.height - boxSize;
        // Do any additional setup after loading the view, typically from a nib.
        createAnimatorStuff()
        generateBoxes()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("Starting gravity")
        motionManager.startDeviceMotionUpdatesToQueue(motionQueue, withHandler: gravityUpdated)
    }

    override func viewDidDisappear(animated: Bool)  {
        super.viewDidDisappear(animated)
        NSLog("Stopping gravity")
        motionManager.stopDeviceMotionUpdates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func randomColor() -> UIColor {
        let red = CGFloat(CGFloat(arc4random()%100000)/100000);
        let green = CGFloat(CGFloat(arc4random()%100000)/100000);
        let blue = CGFloat(CGFloat(arc4random()%100000)/100000);

        return UIColor(red: red, green: green, blue: blue, alpha: 0.85);
    }

    func doesNotCollide(testRect: CGRect) -> Bool {
        for box : UIView in boxes {
            var viewRect = box.frame;
            if(CGRectIntersectsRect(testRect, viewRect)) {
                return false
            }
        }
        return true
    }

    func randomFrame() -> CGRect {
        var guess = CGRectMake(9, 9, 9, 9)

        do {
            let guessX = CGFloat(arc4random()) % maxX
            let guessY = CGFloat(arc4random()) % maxY;
            guess = CGRectMake(guessX, guessY, boxSize, boxSize);
        } while(!doesNotCollide(guess))

        return guess
    }

    func addBox(location: CGRect, color: UIColor) -> UIView {
        let newBox = UIView(frame: location)
        newBox.backgroundColor = color

        view.addSubview(newBox)
        addBoxToBehaviors(newBox)
        boxes += newBox;
        return newBox
    }

    func generateBoxes() {
        for i in 0..10 {
            var frame = randomFrame()
            var color = randomColor()
            var newBox = addBox(frame, color: color);
        }
    }

    var animator:UIDynamicAnimator? = nil;
    let gravity = UIGravityBehavior()

    let collider = UICollisionBehavior()

    func createAnimatorStuff() {
        animator = UIDynamicAnimator(referenceView:self.view);

        gravity.gravityDirection = CGVectorMake(0, 0.8)
        animator?.addBehavior(gravity);

        // We're bouncin' off the walls
        collider.translatesReferenceBoundsIntoBoundary = true
        animator?.addBehavior(collider)
    }

    func addBoxToBehaviors(box: UIView) {
        gravity.addItem(box)
        collider.addItem(box)
    }

    //----------------- Core Motion
    func gravityUpdated(motion: CMDeviceMotion!, error: NSError!) {
        let grav : CMAcceleration = motion.gravity;

        let x = CGFloat(grav.x);
        let y = CGFloat(grav.y);
        var p = CGPointMake(x,y)

        if error {
            NSLog("\(error)")
        }

        // Have to correct for orientation.
        var orientation = UIApplication.sharedApplication().statusBarOrientation;

        if(orientation == UIInterfaceOrientation.LandscapeLeft) {
            var t = p.x
            p.x = 0 - p.y
            p.y = t
        } else if (orientation == UIInterfaceOrientation.LandscapeRight) {
            var t = p.x
            p.x = p.y
            p.y = 0 - t
        } else if (orientation == UIInterfaceOrientation.PortraitUpsideDown) {
            p.x *= -1
            p.y *= -1
        }
        
        var v = CGVectorMake(p.x, 0 - p.y);
        gravity.gravityDirection = v;
    }
}

