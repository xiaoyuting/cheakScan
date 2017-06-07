//
//  modelCell.m
//  HYB
//
//  Created by CUIZE on 16/8/23.
//  Copyright © 2016年 CUIZE. All rights reserved.
//

#import "modelCell.h"
#import "Head.h"
@implementation modelCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self addContent];
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//添加控件
-(void)addContent
{
   
        //昵称
    
    _name=[[UILabel alloc] initWithFrame:CGRectZero];
    
    _name.adjustsFontSizeToFitWidth=YES;
 
    //_name.font=[UIFont systemFontOfSize:NAMEFONT];
    [self.contentView addSubview:_name];
    //评论时间
    _time=[[UILabel alloc]initWithFrame:CGRectZero];
    _time.adjustsFontSizeToFitWidth=YES;
 
    [self.contentView addSubview:_time];
    //内容
    _text=[[UILabel alloc]init];
 
    [self.contentView addSubview:_text];
    
}


//设置内容
-(CGFloat)add:(NSDictionary*)mesinfo
{
    CGFloat height=15;
    _name.frame=CGRectMake(20, 5, w-40, 30);
    _name.text=[NSString stringWithFormat:@"%@", [mesinfo objectForKey:@"couponName"]];

    self. text.numberOfLines=0;
    self.text.font=[UIFont systemFontOfSize:14];
    
    self. text.text= [NSString stringWithFormat:@"%@", [mesinfo objectForKey:@"remark"]];
    
    CGSize textSize=[self.text.text boundingRectWithSize:CGSizeMake(w-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    CGFloat textH=textSize.height;
    self.text.frame=CGRectMake(20, 30, w-40, textH);
     height=textH+height;
    _time.frame=CGRectMake(0.5*w , height+10, 0.5*w, 20);
    _time.text=[NSString stringWithFormat:@"核销时间%@", [mesinfo objectForKey:@"checkInTime"]];
   
    return height+40;
}

@end
