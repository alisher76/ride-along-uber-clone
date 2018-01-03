//
//  ContainerVC.swift
//  ride-along-development
//
//  Created by Alisher Abdukarimov on 1/2/18.
//  Copyright © 2018 Alisher Abdukarimov. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState {
    case collapsed
    case leftPannelExpanded
}

enum ShowWhichVC {
    case homeVC
}

var showVC: ShowWhichVC = .homeVC




class ContainerVC: UIViewController {
    
    var homeVC: HomeVC!
    var leftVC: LeftSidePannelVC!
    var centerController: UIViewController!
    var currentState: SlideOutState = .collapsed
    
    var isHidden = false
    let centerPannelExpandedOffset: CGFloat = 140
    
    var tap: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCenter(screen: showVC)
    }
 
    func initCenter(screen: ShowWhichVC) {
        var presentingController: UIViewController
        
        showVC = screen
        if homeVC == nil {
            homeVC = UIStoryboard.homeVC()
            homeVC.delegate = self
        }
        
        presentingController = homeVC
        
        if let con = centerController {
            con.view.removeFromSuperview()
            con.removeFromParentViewController()
        }
        
        centerController = presentingController
        
        view.addSubview(centerController.view)
        addChildViewController(centerController)
        centerController.didMove(toParentViewController: self)
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return isHidden
    }
    
}

extension ContainerVC: CenterVCDelegate {
    
    func toggleLeftPanel() {
        let notExpanded = (currentState != .leftPannelExpanded)
        
        if notExpanded {
            addLeftPanelVC()
        }
        animateLeftPanelVC(shouldExpand: notExpanded)
    }
    
    func addLeftPanelVC() {
        if leftVC == nil {
            leftVC = UIStoryboard.leftViewController()
            addChildPanelVC(leftVC)
        }
    }
    
    @objc func animateLeftPanelVC(shouldExpand: Bool) {
        if shouldExpand {
            isHidden = !isHidden
            animateStatusBar()

            setupWhiteCoverView()
            currentState = .leftPannelExpanded
            animateCenterPanelXPosition(targetPosition: centerController.view.frame.width - centerPannelExpandedOffset)
            
        } else {
            isHidden = !isHidden
            animateStatusBar()
            hideWhiteCoverView()
            animateCenterPanelXPosition(targetPosition: 0, completion: { (finished) in
                if finished {
                    self.currentState = .collapsed
                    self.leftVC = nil
                }
            })
        }
    }
    
    func addChildPanelVC(_ sidePanelVC: UIViewController) {
        view.insertSubview(sidePanelVC.view, at: 0)
        addChildViewController(sidePanelVC)
        sidePanelVC.didMove(toParentViewController: self)
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
            self.centerController.view.frame.origin.x = targetPosition
            
        }, completion: completion)
    }
    
    func animateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    func hideWhiteCoverView() {
        centerController.view.removeGestureRecognizer(tap)
        for subview in self.centerController.view.subviews {
            if subview.tag == 20 {
                UIView.animate(withDuration: 0.3, animations: {
                    subview.alpha = 0.0
                }, completion: { (finished) in
                    if finished {
                            subview.removeFromSuperview()
                    }
                })
            }
        }
    }
    
    func setupWhiteCoverView() {
        let whiteCoverView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        whiteCoverView.alpha = 0.0
        whiteCoverView.backgroundColor = UIColor.white
        whiteCoverView.tag = 20
        
        self.centerController.view.addSubview(whiteCoverView)
        UIView.animate(withDuration: 0.2) {
            whiteCoverView.alpha = 0.5
        }
        tap = UITapGestureRecognizer(target: self, action: #selector(self.animateLeftPanelVC(shouldExpand:)))
        tap.numberOfTapsRequired = 1
        self.centerController.view.addGestureRecognizer(tap)
    }
    
}

private extension UIStoryboard {
    
    class func mainStoryBoard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    class func leftViewController() -> LeftSidePannelVC? {
        return mainStoryBoard().instantiateViewController(withIdentifier: "LeftSidePannelVC") as? LeftSidePannelVC
    }
    
    class func homeVC() -> HomeVC? {
        return mainStoryBoard().instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
    }
}
