//
//  ViewController.swift
//  MenuDisplayAnimated
//
//  Created by James Rochabrun on 7/16/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK Util
    var isMenuOpen = false
    static let centerYLabelIdentifier = "TitleCenterY"
    
    //MARK UI
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ghostImageView: UIImageView!
    

    //MARK Constraints to modify
    @IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingSpaceButtonConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //printConstraintsOf(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    @IBAction func actionToggleMenu(_ sender: Any) {
        isMenuOpen = !isMenuOpen
        changeLabelText()
        animateConstraFromIdentifier(identifier: ViewController.centerYLabelIdentifier, in: titleLabel)
        findSpecificContraintToAnimate(in: titleLabel)
        animateMenuDisplay()
    }
    
    //MARK: text changes the intrinsiccontentsize of labels
    private func changeLabelText() {
        titleLabel.text = isMenuOpen ? "Select item!!!" : "Show items"
        view.layoutIfNeeded()
    }
    
    private func animateMenuDisplay() {
        
        //MARK: Animating constraints by changing its constants
        menuHeightConstraint.constant = isMenuOpen ? 200.0 : 60.0
        trailingSpaceButtonConstraint.constant = isMenuOpen ? 16.0 : 8.0
        
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       usingSpringWithDamping: 0.4, //less is more bouncing 0 to 1
                       initialSpringVelocity: 10.0, //speed of animation 
                       options: [],//.curveEaseIn, not needed on damping
                       animations: {
                        self.animateButton()
                        self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func animateButton() {
        let angle: CGFloat = self.isMenuOpen
            ? .pi / 4
            : 0.0
        self.plusButton.transform = CGAffineTransform(rotationAngle: angle)
    }
    
    //MARK: finding specific constraint to animate
    private func findSpecificContraintToAnimate(in view: UIView) {
        
        if view.superview == nil { return }
        view.superview?.constraints.forEach({ (constraint) in
            
            if constraint.firstItem as! NSObject == titleLabel &&
                constraint.firstAttribute == .centerX {
                print("-> \(constraint.description)/n")
                constraint.constant = isMenuOpen ? -100.0 : 0.0
                return
            }
        })
    }
    
    //MARK: find specific constraint based on its identifier
    //step 1 go to the specifi constraint in IB and add an identifier
    private func animateConstraFromIdentifier(identifier: String, in view: UIView) {
        
        if view.superview == nil { return }
        view.superview?.constraints.forEach({ (constraint) in
            
            if constraint.identifier == identifier {
                constraint.isActive = false
         
                //MARK: animate constraint from multipliers
                //remember multipliers are get only properties thats why we need to create a new one
                let newConstraint = NSLayoutConstraint(item: view,
                                                       attribute: .centerY,
                                                       relatedBy: .equal,
                                                       toItem: view.superview,
                                                       attribute: .centerY,
                                                       multiplier: isMenuOpen ? 0.67 : 1.0,
                                                       constant: 5.0)
                newConstraint.identifier = identifier
                newConstraint.isActive = true
            }
        })
    }
    
    //MARK: Priting constraints of view in superview DEBUG
    private func printConstraintsOf(_ view: UIView) {
        
        if view.superview == nil { return }
        view.superview?.constraints.forEach({ (constraint) in
            print(" -> \(constraint.description)\n")
        })
    }
    
    //MARK: Animate with transitions
    @IBAction func animateWithTransition(_ sender: Any) {
        
        delay(seconds: 1.0) {
            UIView.transition(with: self.ghostImageView,
                              duration: 1.0,
                              options: [.transitionFlipFromBottom,
                                        .curveEaseIn],
                              animations: {
                                self.ghostImageView.isHidden = true
                                
            }, completion: { (_) in
                self.ghostImageView.removeFromSuperview()
            })
        }
    }
    
    //MARK: helper method for delay constructor
    func delay(seconds: Double, completion: @escaping ()-> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
    }

    
}






