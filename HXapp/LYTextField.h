//
//  LYTextField.h
//  自定义登录界面
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 雷晏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYTextField : UIView

//注释信息
@property (nonatomic,copy) NSString *ly_placeholder;

//光标颜色
@property (nonatomic,strong) UIColor *cursorColor;

//注释普通状态下颜色
@property (nonatomic,strong) UIColor *placeholderNormalStateColor;

//注释选中状态下颜色
@property (nonatomic,strong) UIColor *placeholderSelectStateColor;
//图片
@property (nonatomic,strong)UIImageView *image;
//文本框
@property (nonatomic,strong) UITextField *textField;

//注释
@property (nonatomic,strong) UILabel *placeholderLabel;

//线
@property (nonatomic,strong) UIView *lineView;

//填充线
@property (nonatomic,strong) CALayer *lineLayer;

//移动一次
@property (nonatomic,assign) BOOL moved;

@end
