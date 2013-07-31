//
//  ViewController.m
//  RefreshTableView
//
//  Created by jun on 13-7-31.
//  Copyright (c) 2013年 jun. All rights reserved.
//

#import "ViewController.h"
#import "LastTableViewCell.h"
#import "EGORefreshTableHeaderView.h"

#define kDataMax 60
@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.arrayOfData = [NSMutableArray array];
    
    if (self.refreshTableHeaderView == nil) {
        
        self.refreshTableHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        self.refreshTableHeaderView.delegate = self;
        [self.tableView addSubview:self.refreshTableHeaderView];
    }
    
    [self addDataToArray];
    [self initLastButtonView];
}

- (void)addDataToArray
{
    for (int i=0; i<20; i++) {
        [self.arrayOfData addObject:[NSString stringWithFormat:@"%d",i]];
    }
}

- (void)initLastButtonView
{
    UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tempButton setFrame:CGRectMake(10, 2, 300, 40)];
    [tempButton setBackgroundColor:[UIColor grayColor]];
    [tempButton setTitle:@"load next 20 items" forState:UIControlStateNormal];
    [tempButton addTarget:self action:@selector(lastButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [tempButton setEnabled:YES];
    self.lastButton = tempButton;
}

- (void)lastButtonTouch:(id)sender
{
    if ([self.arrayOfData count]<=kDataMax) {
        [self addDataToArray];
        [_refreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        [self.tableView reloadData];
    }  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayOfData count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[LastTableViewCell class]]) {
        [self lastButtonTouch:nil];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == [self.arrayOfData count]-1) {
        static NSString *thiscell = @"lastCellIdentifier";
        UINib *nib = [UINib nibWithNibName:@"LastTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:thiscell];
        LastTableViewCell *mycell = [tableView dequeueReusableCellWithIdentifier:thiscell];
        //如果没有数据（arrayOfData达到设定的max）
        if ([self.arrayOfData count] == kDataMax) {
            [self.lastButton setTitle:@"No more items" forState:UIControlStateNormal];
            [self.lastButton setEnabled:NO];
        }
        [mycell addSubview:self.lastButton];
        [mycell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return mycell;
    }else{
        static NSString *identifier = @"CellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        int row = [indexPath row];
        cell.textLabel.text = [self.arrayOfData objectAtIndex:row];
         return cell;
    }

}
#pragma mark –
#pragma mark Data Source Loading / Reloading Methods 

- (void)reloadTableViewDataSource{
    NSLog(@"==开始加载数据");
    self.isLoading = YES;
}

- (void)doneLoadingTableViewData{
    NSLog(@"===加载完数据");
    self.isLoading = NO;
    [self.refreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark -
#pragma mark ScrollView Delegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.refreshTableHeaderView egoRefreshScrollViewDidScroll:scrollView];

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self.refreshTableHeaderView egoRefreshScrollViewDidEndDragging:scrollView];

}
#pragma mark -
#pragma mark EgoRefreshTableHeader Delegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self reloadTableViewDataSource];
    [self lastButtonTouch:nil];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3];
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return self.isLoading;
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}
@end
