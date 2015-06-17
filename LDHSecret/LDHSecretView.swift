//
//  LDHSecretView.swift
//  LDHSecret
//
//  Created by lidehua on 15/6/16.
//  Copyright (c) 2015年 李德华. All rights reserved.
//

import UIKit
protocol LDHSecretDelegate {
    func correctSecret()
    func wrongSecret()
}
class LDHSecretView: UIView {
    var viewArray = Array<LDHCircleView>();
    var pointArray = Array<CGPoint>();
    var circlePoint = CGPointZero;
    var fingerPoint = CGPointZero;
    var context : CGContextRef!;
    let blueColor = UIColor(red: 109/255.0, green: 175/255.0, blue: 243/255.0, alpha: 1);
    let redColor = UIColor(red: 191/255.0, green: 61/255.0, blue: 54/255.0, alpha: 1);
    let greenColor = UIColor(red: 124/255.0, green: 200/255.0, blue: 110/255.0, alpha: 1);
    let password = "12589";
    var bgWindow : UIWindow?;
    var inputPassword = String();
    var drawColor : UIColor;
    var delegate : LDHSecretDelegate?;
    init () {
        drawColor = blueColor;
//        super.init(frame: CGRect(x: 0, y: 0, width: 375, height: 667));
        super.init(frame: CGRect(x: 0, y: 0, width: 208, height: 208));
        self.backgroundColor = UIColor(red: 63/255.0, green: 63/255.0, blue: 67/255.0, alpha: 1);
        self.setupSubviews();
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupSubviews () {
        var tableView = UITableView();
        for var i = 0 ; i < 9 ; i++ {
            let row = i / 3;
            let line = i % 3;
            let circleView = LDHCircleView(number: i + 1, center: CGPoint(x: 80 * line , y: 80 * row));
            circleView.activeColor = blueColor;
            circleView.backgroundColor = UIColor.clearColor();
            self.addSubview(circleView);
            viewArray.append(circleView);
        }
        let pan = UIPanGestureRecognizer(target: self, action: Selector("viewPanAction:"));
        self.addGestureRecognizer(pan);
    }
    func viewPanAction(pan : UIPanGestureRecognizer) {
        let point = pan.locationInView(self);
        switch pan.state {
        case UIGestureRecognizerState.Began:
            for circleView in viewArray {
                if CGRectContainsPoint(circleView.frame, point) {
                    circlePoint = circleView.center;
                    pointArray.append(circleView.center);
                    circleView.active = true;
                    inputPassword += String(stringInterpolationSegment: circleView.num);
                    circleView.setNeedsDisplay();
                    break;
                }
            }
            break;
        case UIGestureRecognizerState.Cancelled:
            
            break;
        case UIGestureRecognizerState.Changed:
            fingerPoint = point;
            if pointArray.count == 0 {
                return;
            }
            if pointArray.count > 1 {
                pointArray.removeLast();
            }
            pointArray.append(point);
            for circleView in viewArray {
                if CGRectContainsPoint(circleView.frame, point) {
                    if !circleView.active {
                        circlePoint = circleView.center;
                        pointArray.insert(circleView.center, atIndex: pointArray.count - 1);
                        circleView.active = true;
                        inputPassword += String(stringInterpolationSegment: circleView.num);
                        circleView.setNeedsDisplay();
                        break;
                    }
                }
            }
            self.setNeedsDisplay();
            break;
        case UIGestureRecognizerState.Ended:
            if pointArray.count < 1 {
                return;
            }
            pointArray.removeLast();
            if password == inputPassword {
                drawColor = greenColor;
                if delegate != nil {
                    delegate!.correctSecret();
                }
            } else {
                drawColor = redColor;
                if delegate != nil {
                    delegate!.wrongSecret();
                }
            }
            self.setNeedsDisplay();
            for circleView in viewArray {
                if circleView.active {
                    circleView.activeColor = drawColor;
                    inputPassword.removeAll(keepCapacity: false);
                    circleView.setNeedsDisplay();
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(Double(NSEC_PER_SEC) * 1.0)), dispatch_get_main_queue(), { () -> Void in
                        circleView.active = false;
                        circleView.setNeedsDisplay();
                        circleView.activeColor = self.blueColor;
                        self.pointArray.removeAll(keepCapacity: false);
                        self.setNeedsDisplay();
                        if self.drawColor == self.greenColor {
                            self.dismis();
                        }
                        self.drawColor = self.blueColor;
                    });
                }
            }
            break;
        default:
            break;
        }
    }
    override func drawRect(rect: CGRect) {
        context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 4);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetStrokeColorWithColor(context, drawColor.CGColor);
        CGContextBeginPath(context);
        for (index , point) in enumerate(pointArray) {
            CGContextMoveToPoint(context, point.x, point.y);
            if index < pointArray.count - 1 {
                var toPoint = pointArray[index + 1];
                CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
            }
        }
        CGContextStrokePath(context);
    }
    func show() {
        bgWindow = UIWindow(frame: UIScreen.mainScreen().bounds);
        bgWindow!.windowLevel = UIWindowLevelAlert;
        self.center = bgWindow!.center;
        bgWindow!.addSubview(self);
        bgWindow!.backgroundColor = self.backgroundColor;
        bgWindow!.makeKeyAndVisible();
    }
    func dismis() {
        bgWindow!.hidden = true;
        bgWindow!.resignKeyWindow();
        bgWindow!.removeFromSuperview();
        bgWindow = nil;
    }
}
