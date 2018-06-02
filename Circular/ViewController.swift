//
//  ViewController.swift
//  Circular
//
//  Created by Sasan Soroush on 3/12/1397 AP.
//  Copyright © 1397 AP Sasan Soroush. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let colors : [UIColor] = [
        UIColor(rgb: 0xFC31AB) ,
        UIColor(rgb: 0xFC0E2A) ,
        UIColor(rgb: 0xFEE551) ,
        UIColor(rgb: 0x1EA7E9) ,
        UIColor(rgb: 0x4BB328) ,
        UIColor(rgb: 0x2DBFFC) ,
        UIColor(rgb: 0x7E8082) ,
        UIColor(rgb: 0xFDB637)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        makeBallFall()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self.view)
        if location.x > view.frame.width/2 {
            rotateRight()
        } else {
            rotateLeft()
        }
    }
    
    // Properties UI
    
    let ball : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let wheel : UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        view.image = #imageLiteral(resourceName: "color-wheel")
        return view
    }()
    
    @objc private func rotateRight() {
        rotateView(targetView: wheel)
    }
    
    @objc private func rotateLeft() {
        rotateView(targetView: wheel, piDividedBy: -4)
    }
    
    private func rotateView(targetView: UIView, duration: Double = 0.1 , piDividedBy : Double = 4) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: CGFloat(Double.pi/piDividedBy))
        })
    }
    
    private func makeBallFall() {
        var _ = Timer.scheduledTimer(  timeInterval: 3,
                                       target: self,
                                       selector: #selector(ballFall),
                                       userInfo: nil,
                                       repeats: true  )
    }
    
    @objc private func ballFall() {
        makeBall()
        UIView.animate(withDuration: 2.5, animations: {
            
            self.ball.frame = CGRect(x: self.view.frame.width/2 - 12.5, y: self.wheel.center.y - 12.5, width: 25, height: 25)
            
        }) { (animated) in
            
            let originalTransform = self.ball.transform


            UIView.animate(withDuration: 0.2, animations: {
                let scaledTransform = originalTransform.scaledBy(x: 5, y: 5)
                self.ball.transform = scaledTransform
                self.ball.alpha = 0

            }, completion: { (animated) in
                self.ball.transform = originalTransform
                self.ball.removeFromSuperview()

            })
            
        }
    }
    
    private func makeBall() {
        view.addSubview(ball)
        ball.alpha = 1
        ball.frame = CGRect(x: view.frame.width/2 - 12.5, y: view.frame.height/16, width: 25, height: 25)
        ball.layer.cornerRadius = 12.5
        let randomNumber = arc4random_uniform(7)
//        UIView.animate(withDuration: 0.5) {
//            self.view.backgroundColor = self.colors[Int(randomNumber)]
//        }
        ball.backgroundColor = self.colors[Int(randomNumber)]
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.init(red: 40/255, green: 50/255, blue: 70/255, alpha: 1)
//        view.backgroundColor = .white
        view.addSubview(wheel)
        wheel.frame = CGRect(x: 0, y: view.frame.height/2, width: view.frame.width, height: view.frame.height/2)
        
        rotateView(targetView: wheel, duration: 0, piDividedBy: 8)
    }
}

