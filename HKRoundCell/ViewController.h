//
//  ViewController.h
//  HKRoundCell
//
//  Created by 黄康 on 16/12/15.
//  Copyright © 2016年 黄康. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *cells;

@end

