//
//  ViewController.h
//  RefreshTableView
//
//  Created by jun on 13-7-31.
//  Copyright (c) 2013年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayOfData;
@property (strong, nonatomic) UIButton *lastButton;
@property (strong, nonatomic) EGORefreshTableHeaderView *refreshTableHeaderView;
@property(nonatomic) BOOL isLoading;

@end
