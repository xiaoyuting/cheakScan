//
//  modelCell.h
//  HYB
//
//  Created by CUIZE on 16/8/23.
//  Copyright © 2016年 CUIZE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface modelCell : UITableViewCell
@property    UILabel *text;
 
@property    UILabel *name;
@property    UILabel *time;
-(CGFloat)add:(NSDictionary*)mesinfo;
@end
