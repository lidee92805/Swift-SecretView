//
//  LDHCircleView.swift
//  LDHSecret
//
//  Created by lidehua on 15/6/16.
//  Copyright (c) 2015年 李德华. All rights reserved.
//

import UIKit

class LDHCircleView: UIView {
    var num : Int = 0;
    var active : Bool;
    var activeColor : UIColor?;
    init(number : Int , center : CGPoint) {
        active = false;
        super.init(frame: CGRect(x: center.x, y: center.y, width: 48, height: 48));
        num = number;
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext();
        var ret = CGRect(x: rect.origin.x + 2, y: rect.origin.y + 2, width: rect.size.width - 4, height: rect.size.height - 4);
        if active {
            CGContextSetFillColorWithColor(context, UIColor(red: 40/255.0, green: 42/255.0, blue: 41/255.0, alpha: 0.8).CGColor);
        } else {
            CGContextSetFillColorWithColor(context, UIColor(red: 50/255.0, green: 51/255.0, blue: 54/255.0, alpha: 0.8).CGColor);
        }
        CGContextFillEllipseInRect(context, ret);
        
        if active {
            var shadowRect = CGRect(x: rect.origin.x + 13, y: rect.origin.y + 13, width: rect.size.width - 26, height: rect.size.height - 26);
            CGContextSetFillColorWithColor(context, UIColor(red: 31/255.0, green: 36/255.0, blue: 34/255.0, alpha: 0.3).CGColor);
            CGContextFillEllipseInRect(context, shadowRect);
            if activeColor != nil {
                var blueColor = activeColor!;
                CGContextSetStrokeColorWithColor(context, blueColor.CGColor);
                CGContextSetFillColorWithColor(context, blueColor.CGColor);
            }
            var blueRect = CGRect(x: rect.origin.x + 15, y: rect.origin.y + 15, width: rect.size.width - 30, height: rect.size.height - 30);
            CGContextFillEllipseInRect(context, blueRect);
        } else {
            CGContextSetStrokeColorWithColor(context, UIColor(red: 101/255.0, green: 102/255.0, blue: 106/255.0, alpha: 1).CGColor);
        }
        CGContextSetLineWidth(context, 2);
        var rt = CGRect(x: rect.origin.x + 1, y: rect.origin.y + 1, width: rect.size.width - 2, height: rect.size.height - 2);
        CGContextStrokeEllipseInRect(context, rt);
        CGContextStrokePath(context);
    }
}
