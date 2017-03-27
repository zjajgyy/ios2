//
//  GuideViewController.swift
//  T-Helper
//
//  Created by 陈陈陈 on 2016/12/1.
//  Copyright © 2016年 thelper. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController,UIScrollViewDelegate {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var enterMainPageButton: UIButton!
    private var guideScrollView:UIScrollView!
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setGuidePages()
    }
    
    func setGuidePages(){
        //设置scrollview的内容大小,并且添加引导页
        let frame = self.view.bounds
        
        guideScrollView = UIScrollView(frame: frame)
        guideScrollView.isPagingEnabled = true
        guideScrollView.showsHorizontalScrollIndicator = false
        guideScrollView.showsVerticalScrollIndicator = false
        guideScrollView.scrollsToTop = false
        guideScrollView.bounces = false
        // 将 scrollView 的 contentSize 设为屏幕宽度的3倍(根据实际情况改变)
        guideScrollView.contentSize = CGSize(width:width*3,height:height)
        
        guideScrollView.delegate = self
        
        for i in 1...3{
            let imageView = UIImageView(frame:CGRect(x:width*CGFloat(i-1),y:0,width:width,height:height))
            imageView.image = UIImage(named:"guide\(i)")
            guideScrollView.addSubview(imageView)
            
        }
        self.view.insertSubview(guideScrollView, at: 0)
        enterMainPageButton.layer.cornerRadius = 15.0
        // 隐藏开始按钮
        enterMainPageButton.alpha = 0.0
        enterMainPageButton.isEnabled = false
        guideScrollView.delegate = self
        
    }
    //scrollView停止滑动后执行该方法
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x/width)
        if currentPage == 2{
            UIView.animate(withDuration: 0.5){
                self.enterMainPageButton.alpha = 1.0
            }
            enterMainPageButton.isEnabled = true
        }else{
            UIView.animate(withDuration:0.2) {
                self.enterMainPageButton.alpha = 0.0
            }
            
        }
        pageControl.currentPage = currentPage
    }
    
    @IBAction func enterMainPageButton(_ sender: UIButton) {
        let mainPageVC = storyboard!.instantiateViewController(withIdentifier:"MainPage")
        self.present(mainPageVC, animated: true, completion: nil)
        //self.presentingViewController(mainPageVC, animated: true, completion: nil)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
