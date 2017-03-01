//
//  DrawSpecificView.swift
//  YellowLineIsGood
//
//  Created by Justin Huang on 2017/2/28.
//  Copyright © 2017年 Justin Huang. All rights reserved.
//

import Foundation
import UIKit
class DrawSpecificView{
    func drawTriangle(superView:UIView,fillCgColor:CGColor){
//        let triangleView = UIView()
//        triangleView.frame = CGRect(x: 100 , y: 100, width: 110, height: 110)
//        triangleView.backgroundColor = UIColor.clear
        let mainPath5 = UIBezierPath()
        mainPath5.move(to: CGPoint(x:0, y: -5))
        mainPath5.addLine(to: CGPoint(x: superView.frame.width/2, y:superView.frame.height ))
        mainPath5.addLine(to: CGPoint(x: superView.frame.width , y: -5))
        mainPath5.close()
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = mainPath5.cgPath //存入UIBezierPath的路径
        shapeLayer.fillColor = fillCgColor //设置填充色
        shapeLayer.lineWidth = 1  //设置路径线的宽度
        shapeLayer.strokeColor = UIColor.gray.cgColor //路径颜色
        //如果想变为虚线设置这个属性，[实线宽度，虚线宽度]，若两宽度相等可以简写为[宽度]
        shapeLayer.lineDashPattern = []
        //一般可以填"path"  "strokeStart" "strokeEnd"  具体还需研究
        //        let baseAnimation = CABasicAnimation(keyPath: "strokeEnd")
        //        baseAnimation.duration = 2   //持续时间
        //        baseAnimation.fromValue = 0  //开始值
        //        baseAnimation.toValue = 2    //结束值
        //        baseAnimation.repeatDuration = 5  //重复次数
        //        shapeLayer.add(baseAnimation, forKey: nil) //给ShapeLayer添
        //显示在界面上
        superView.layer.addSublayer(shapeLayer)
//        superView.addSubview(triangleView)
    }
}
