//
//  ViewController.swift
//  Circular
//
//  Created by Sasan Soroush on 3/12/1397 AP.
//  Copyright © 1397 AP Sasan Soroush. All rights reserved.
//

/* IDEA : like these app but wheel on top
    and every block has a number that we have to shoot the ball to same color block then it goes into the circle and starts to destroy and decrese the number like ballZ game other wise it will bounce outside the circle and it will increase the numbers
 */

import UIKit

class ViewController: UIViewController {

    var timer = Timer()

    var topIndex : Int = 0
    var ballIndex : Int = 0
    var score : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        makeBallFall()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self.view)
        if location.x > view.frame.width/2 {
            changeIndex(increase: true)
            rotateRight()
        } else {
            changeIndex(increase: false)
            rotateLeft()
        }
    }
    
    private func changeIndex(increase : Bool) {
        if increase {
            if topIndex == 0 {
                topIndex = 7
            } else {
                topIndex -= 1
            }
        } else {
            if topIndex == 7 {
                topIndex = 0
            } else {
                topIndex += 1
            }
        }
    }
    
    // Properties UI
    
    let retryButton : UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("RETRY", for: UIControlState.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 35, weight: UIFont.Weight.light)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(retryBtnTapped), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    let scoreLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.init(rgb: 0x5A3D2B)
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.text = "0"
        return label
    }()
    
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
    
    private func rotateView(targetView: UIView, duration: Double = 0.085 , piDividedBy : Double = 4) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
            targetView.transform = targetView.transform.rotated(by: CGFloat(Double.pi/piDividedBy))
        })
    }
    
    private func makeBallFall() {
        ball.alpha = 1
        timer = Timer.scheduledTimer(  timeInterval: 3,
                                       target: self,
                                       selector: #selector(ballFall),
                                       userInfo: nil,
                                       repeats: true  )
    }
    
    @objc private func ballFall() {
        var Correct : Bool = false
        makeBall()
        UIView.animate(withDuration: 2.0, animations: {
            
            self.ball.frame = CGRect(x: self.view.frame.width/2 - 12.5, y: self.wheel.center.y - 12.5, width: 25, height: 25)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                if self.ballIndex == self.topIndex {
                    Correct = true
                } else {
                    Correct = false
                }
            }
        }) { (animated) in
            
            if Correct  {
                
                self.score += 1
                self.scoreLabel.text = String(self.score)
                
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
            else {
                self.score = 0
                self.scoreLabel.text = "0"
                UIView.animate(withDuration: 1, animations: {
                    self.ball.frame = CGRect(x: 50, y: self.view.frame.height/8, width: self.view.frame.width-100, height: self.view.frame.height/8)
                    self.ball.backgroundColor = UIColor.init(rgb: 0x75C8AE)
                    self.view.backgroundColor = UIColor.init(rgb: 0xe57364)
                    self.timer.invalidate()

                }, completion: { (animated) in
                    
                    self.view.addSubview(self.retryButton)
                    self.retryButton.frame = self.ball.frame
                    self.retryButton.layer.cornerRadius = 12.5
                    
                })
            }
        }
    }
    
    private func makeBall() {
        let randomNumber = arc4random_uniform(7)
        let colors = Constants.Colors.all
        view.addSubview(ball)
        ball.alpha = 1
        ball.frame = CGRect(x: view.frame.width/2 - 12.5, y: view.frame.height/16, width: 25, height: 25)
        ball.layer.cornerRadius = 12.5
        ballIndex = Int(randomNumber)
        ball.backgroundColor = colors[Int(randomNumber)]
    }
    
    @objc private func retryBtnTapped() {
        UIView.animate(withDuration: 0.5, animations: {
            
            self.retryButton.removeFromSuperview()
            self.ball.frame = CGRect(x: self.view.frame.width/2 - 12.5, y: self.view.frame.height/16, width: 25, height: 25)
            self.view.backgroundColor = UIColor.init(rgb: 0xffecb4)
            
        }) { (animated) in
            
            self.makeBallFall()
            
        }
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.init(rgb: 0xffecb4)
        
        view.addSubview(wheel)
        view.addSubview(scoreLabel)
        
        wheel.frame = CGRect(x: 0, y: view.frame.height/2, width: view.frame.width, height: view.frame.height/2)
        scoreLabel.frame = wheel.frame
        
        rotateView(targetView: wheel, duration: 0, piDividedBy: 8)
    }
}

