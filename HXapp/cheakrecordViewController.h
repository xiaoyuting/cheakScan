//
//  cheakrecordViewController.h
//  HXapp
//
//  Created by CUIZE on 16/9/21.
//  Copyright © 2016年 CUIZE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cheakrecordViewController : UIViewController
@property UIView *rightView;
@property UITableView *tabList;
@property UITableView *tabShow;
@property NSMutableArray *dataArray;
@property NSDate *  nowDate;
@property NSString *Nowdatestr;
@property NSString *Enddatestr;
@property NSString *userID;
@property int count;
@property UILabel *labTitle;
@property UIButton *btnHead;
@end
