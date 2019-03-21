//
//  ViewController.swift
//  QQZoneHeader
//
//  Created by onefboy on 2018/9/26.
//  Copyright © 2018 onefboy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UIScrollViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var navBarView: UIView!
  @IBOutlet weak var navBarTitle: UILabel!
  @IBOutlet weak var navBarBackBtn: UIButton!
  @IBOutlet weak var navBarBackTitle: UILabel!
  @IBOutlet weak var navBarRightBtn: UIButton!
  
  var bgImg: UIImageView!
  var bgImgHeight: CGFloat = 0
  var headerHeight: CGFloat = 0
  var originalFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
  
  let ratio: CGFloat = 880/1279// 图片宽高比例
  
  let cellId = "UITableViewCell"

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    tableView.rowHeight = 45
    bgImgHeight = view.frame.width*ratio// 根据图片比例计算headerView高度
    headerHeight = bgImgHeight - 64
    
    bgImg = UIImageView.init(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: bgImgHeight))
    bgImg.image = UIImage.init(named: "photo.jpeg")
//    tableView.insertSubview(img, at: 0)
    
    view.insertSubview(bgImg, at: 0)
    
    originalFrame = bgImg.frame
    
    // contentInset的实质就是修改bounds
    // scrollView滑动的本质，是修改bounds
//    tableView.contentInset = UIEdgeInsets(top: view.frame.width*880/1279, left: 0, bottom: 0, right: 0)
    
    let headerView = UIView(frame: CGRect.init(x: 0, y: 0, width: view.frame.width, height: headerHeight))
    headerView.backgroundColor = .clear
    tableView.tableHeaderView = headerView
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 25
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
    if cell == nil {
      cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
    }
    cell?.textLabel?.text = "Item \(indexPath.row)"
    return cell!
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let yOffset = scrollView.contentOffset.y
    print(yOffset)
    //设置导航栏的状态
    if yOffset < headerHeight {// 滑动到导航栏底部之前
      let alpha = yOffset/headerHeight
      navBarView.backgroundColor = UIColor.white.withAlphaComponent(alpha)
      
      navBarTitle.textColor = .white
      navBarBackTitle.textColor = .white
      navBarBackBtn.setImage(UIImage.init(named: "back.png"), for: .normal)
      navBarRightBtn.setImage(UIImage.init(named: "add.png"), for: .normal)
    } else {// 超过导航栏底部
      navBarView.backgroundColor = .white
      
      navBarTitle.textColor = .black
      navBarBackTitle.textColor = .black
      navBarBackBtn.setImage(UIImage.init(named: "back_sel.png"), for: .normal)
      navBarRightBtn.setImage(UIImage.init(named: "add_sel.png"), for: .normal)
    }
    
    // 处理图片放大效果，往上移动效果
    if yOffset > 0 {// 往上移动
      var frame = originalFrame
      frame.origin.y = originalFrame.origin.y - yOffset
      bgImg.frame = frame
    } else { // 往下移动
      var frame = originalFrame
      frame.size.height = originalFrame.size.height - yOffset
      frame.size.width = frame.size.height/ratio
      frame.origin.x = originalFrame.origin.x - (frame.size.width - originalFrame.size.width)/2
      bgImg.frame = frame
    }
    
  }

}

