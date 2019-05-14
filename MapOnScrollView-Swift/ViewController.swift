//
//  ViewController.swift
//  MapOnScrollView-Swift
//
//  Created by eidan on 17/1/16.
//  Copyright © 2017年 Amap.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UIScrollViewDelegate ,UIGestureRecognizerDelegate{
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    @IBOutlet weak var scrollView: UIScrollView!
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pan : UIPanGestureRecognizer  = UIPanGestureRecognizer.init(target: self, action: #selector(self.panHandle(gesture:)))
        pan.delegate = self //一定要设置
        self.scrollView.addGestureRecognizer(pan)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width = self.scrollView.frame.size.width;
        let height = self.scrollView.frame.size.height;
        
        let a = UILabel(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(width), height: CGFloat(height)))
        a.textAlignment = NSTextAlignment.center
        a.font = UIFont.systemFont(ofSize: CGFloat(100))
        a.text = "第一页"
        let b = UIView(frame: CGRect(x: CGFloat(width), y: CGFloat(0), width: CGFloat(width), height: CGFloat(height)))
        let c = UILabel(frame: CGRect(x: CGFloat(width * 2), y: CGFloat(0), width: CGFloat(width), height: CGFloat(height)))
        c.textAlignment = NSTextAlignment.center
        c.font = UIFont.systemFont(ofSize: CGFloat(100))
        c.text = "第三页"
        
        let map = MAMapView(frame: c.bounds)
        b.addSubview(map)
        
        scrollView.addSubview(a)
        scrollView.addSubview(b)
        scrollView.addSubview(c)
        
        self.scrollView.contentSize = CGSize(width: CGFloat(width * 3), height: CGFloat(height))
        
    }

    
    //实现手势处理
    @objc func panHandle(gesture : UIPanGestureRecognizer) {
        
        if gesture.state != UIGestureRecognizerState.ended {
            return
        }
        
        if fabs(gesture.velocity(in: self.scrollView).x) > 1400 {
            
            // -1 向左，1 向右
            let direction = fabs(gesture.velocity(in: self.scrollView).x) / gesture.velocity(in: self.scrollView).x
            let validIdx = 1
            
            if self.currentIndex == validIdx && !self.scrollView.isDecelerating {
                let width: CGFloat = self.scrollView.frame.size.width * CGFloat(1 - direction)
                scrollView.setContentOffset(CGPoint(x: width, y: CGFloat(0)), animated: true)
            }
        }
        
    }
    
    //设置允许和scrollview上pan手势并发
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //滚动的时候，更新上面的segmentedControl
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offX: CGFloat = scrollView.contentOffset.x
        let idx: Int = Int(round(offX / scrollView.bounds.size.width))
        if idx != self.currentIndex {
            self.currentIndex = idx
            self.segmentedControl.selectedSegmentIndex = self.currentIndex
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //xib click
    @IBAction func segmentedAction(_ sender: Any) {
        self.scrollView.setContentOffset(CGPoint.init(x: CGFloat(self.scrollView.frame.size.width) * CGFloat(self.segmentedControl.selectedSegmentIndex), y: 0), animated: true)
    }

}

