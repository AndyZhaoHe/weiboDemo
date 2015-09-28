//
//  MainViewController.swift
//  weibo
//
//  Created by 赵赫 on 15/9/26.
//  Copyright © 2015年 Andyzhao. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {


    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = UIColor.orangeColor()
        tabBar.backgroundImage = UIImage(named: "tabbar_background")
        
        
        addChildViewControllers()
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 添加中间按钮
        tabBar.addSubview(composeButton)
        // 设置中间按钮的位置
        let centerX : CGFloat = UIScreen.mainScreen().bounds.size.width * 0.5
        let width : CGFloat =  UIScreen.mainScreen().bounds.size.width / 5
        let height : CGFloat = tabBar.bounds.height
        composeButton.frame = CGRect(x: 0, y: 0, width: width, height: height)
        composeButton.center.x = centerX
        
    }
    
    func addChildViewControllers() {
        do{
          // 1.1 拿到json文件路径
          let path = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil)
          // 1.2 根据路径创建NSdata
          let data = NSData(contentsOfFile: path!)
            
          // 1.3 根据NSData创建数组 // 为什么try
          let dicArr = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
            
          // 遍历数组创建控制器
            for dict in dicArr as! [[String : AnyObject]]
            {
                print(dict)
               addChildViewController(dict["vcName"] as! String, imageName: dict["imageName"] as! String, title: dict["title"] as! String)
               
            }
          
            
        }catch
        {
        
            // 添加子控制器
            addChildViewController("HomeViewController", imageName: "tabbar_home", title: "首页")
            addChildViewController("DiscoverViewController", imageName: "tabbar_discover", title: "发现")
            addChildViewController("NULLViewController", imageName: " ", title: "")
            addChildViewController("MessageViewController", imageName: "tabbar_message_center", title: "消息")
            addChildViewController("ProfileViewController", imageName: "tabbar_profile", title: "我")
        
        }
    }
    
    
    // 添加子控制器方法
    func addChildViewController(vcName : String, imageName : String, title : String){
    
        // 在Swift中，如果想通过字符串创建一个类，那么必须加上命名空间，否则创建出来的nil
        // 获取命名空间
//        let nsp = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
         let nsp = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
//        let cls: AnyClass = NSClassFromString(nsp + "." + vcName)!
        print(nsp)
        let str = nsp + "." + vcName
        let cls: AnyClass =  NSClassFromString(str)!
        // AndClass并不知道具体的类型，所以需要将他转换为已知的类型，然后再调用init()方法创建
        let viewController = (cls as! UIViewController.Type).init()
        
        
        if imageName != ""
        {
           viewController.tabBarItem.image = UIImage(named: imageName)
           viewController.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        }
         viewController.title = title
        
        let nav =  NavViewController()
        nav.addChildViewController(viewController)
        addChildViewController(nav)
    }
    
    


    // MARK: - 懒加载
    lazy var composeButton : UIButton =
     {

       let btn = UIButton()
        // 设置按钮图片
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        
        // 设置按钮背景图片
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
         btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        // 监听按钮点击
        btn.addTarget(self, action: Selector("composeClick"), forControlEvents: UIControlEvents.TouchUpInside)
        
        btn.sizeToFit()
        return btn
        
        
    
    }()
    
    // 监听按钮点击
    func composeClick(){
        
        print("composeClick")
    }
}
