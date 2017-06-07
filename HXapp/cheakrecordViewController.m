//
//  cheakrecordViewController.m
//  HXapp
//
//  Created by CUIZE on 16/9/21.
//  Copyright © 2016年 CUIZE. All rights reserved.
//

#import "cheakrecordViewController.h"
#import "HEAD.h"
#import "AFNetworking.h"
#import "modelCell.h"
#import "MJRefresh.h"
@interface cheakrecordViewController()<UITableViewDataSource,UITableViewDelegate>
@property  NSMutableArray *arrList;
@end
@implementation cheakrecordViewController
-(id)init
{
    if(self){
        self=[super init];
    }
    self.userID=[[NSString alloc]init];
    return  self;
}
- (void)viewDidLoad {
    UIImageView*vic=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, w , 40)];
    vic.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:vic];
    self.labTitle=[[UILabel alloc]initWithFrame:CGRectMake(40, 64, w-80, 40)];
    
    self.labTitle.textColor=[UIColor colorWithRed:193/255.0 green:41/255.0 blue:49/255.0 alpha:1];
    self.labTitle.textAlignment=NSTextAlignmentCenter ;
    [self.view addSubview:self.labTitle];
    self.btnHead=[[UIButton alloc]initWithFrame:CGRectMake(w-40, 64, 40, 40)];
    [self.btnHead setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
      [self.btnHead setImage:[UIImage imageNamed:@"1"] forState:UIControlStateSelected];
    
    [self.view addSubview:_btnHead];
    [self.btnHead addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    
    self.count=2;
    self.Nowdatestr=[[NSString alloc]init];
    self.Enddatestr=[[NSString alloc]init];
   self.nowDate=[NSDate date];
    NSDate* theDate;
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
            NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
    theDate = [self.nowDate initWithTimeIntervalSinceNow: -oneDay*7 ];
    self.Enddatestr=[dateformatter stringFromDate:theDate];
    self.Nowdatestr=[dateformatter stringFromDate:self.nowDate] ;
    [self date:self.Nowdatestr stop:self.Enddatestr];
    self.arrList=[[NSMutableArray alloc]initWithObjects:@"7天内",@"30天内",@"三个月内",@"半年内",@"一年内",@"取消筛选", nil];
    self.dataArray=[NSMutableArray array];
    self.view.backgroundColor=[UIColor whiteColor];
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    title.text=@"核销记录" ;
    //    theDate = [self.nowDate initWithTimeIntervalSinceNow: +oneDay*3 ];
    //     NSLog(@"111%@" ,[dateformatter stringFromDate:theDate]);

    title.textColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"筛选" style:UIBarButtonItemStyleBordered target:self action:@selector(selectInfo)];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backView)];
    self.navigationItem.titleView=title;
    self.tabShow=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, w, h-64) style:UITableViewStylePlain];
    self.tabShow.delegate=self;
   self.tabShow.dataSource=self;
    // 下拉刷新
    self. tabShow.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self date:self.Nowdatestr stop:self.Enddatestr];

        [self.tabShow.mj_header endRefreshing];
    }];
    
    
    self. tabShow.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    self. tabShow.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self date:self.Nowdatestr stop:self.Enddatestr];

        
           [self.tabShow.mj_footer endRefreshing];
    }];

    [self.view addSubview:self.tabShow];
    
    self.rightView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, w, h)];
       self.rightView.backgroundColor=[ [UIColor grayColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:self.rightView];
    self.rightView.alpha=0;
    self.tabList=[[UITableView alloc]initWithFrame:CGRectMake(0.5*w , 64, 0.5*w , h-64) style:UITableViewStylePlain];
    self.tabList.delegate=self;
    self.tabList.dataSource=self;
    [self.rightView addSubview:self.tabList];
    
       [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)backView{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)selectInfo{
    if(self.rightView.alpha ==0){
        [UIView animateWithDuration:0.3 animations:^{
            self.rightView.alpha=1;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.rightView.alpha=0;
        }];
    }
}
-(void)cancle{
    [UIView animateWithDuration:0.3 animations:^{
        self.tabShow.frame=CGRectMake(0, 64, w , h-64);
}];
    }
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView==self.tabList){
        return self.arrList.count;

    }else{
        return self.dataArray.count;
    }
    return 0;
    }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str=@"qqq";
    if(tableView==self.tabList){
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:str];
    if(cell ==nil){
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2  reuseIdentifier:str];
                  }
    cell.detailTextLabel.text=self.arrList[indexPath.row];
        return cell;}
    else if(tableView==self.tabShow){
         modelCell *cell=[tableView dequeueReusableCellWithIdentifier:str];
        if(cell ==nil){
            cell =[[modelCell alloc]initWithStyle:UITableViewCellStyleValue2  reuseIdentifier:str];
        }
        [cell add:self.dataArray[indexPath.row]];
        return cell;}
  
UITableViewCell *cell=[[UITableViewCell alloc]init];

 return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==self.tabList){
       
    if(indexPath.row==5){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [UIView animateWithDuration:0.3 animations:^{
            self.rightView.alpha=0;
        }];
    }else if(indexPath.row==0){
        [UIView animateWithDuration:0.3 animations:^{
            self.tabShow.frame=CGRectMake(0, 104, w, h-104);
            
        }];        self.labTitle.text=[NSString stringWithFormat:@"筛选时间:%@",self.arrList[indexPath.row]];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
         NSDate* theDate;
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [self.nowDate initWithTimeIntervalSinceNow: -oneDay*7 ];
        self.Enddatestr=[dateformatter stringFromDate:theDate];
        [self date:self.Nowdatestr stop:self.Enddatestr];

        
    }else if(indexPath.row==1){
        [UIView animateWithDuration:0.3 animations:^{
            self.tabShow.frame=CGRectMake(0, 104, w, h-104);
            
        }];
        self.labTitle.text=[NSString stringWithFormat:@"筛选时间:%@",self.arrList[indexPath.row]];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        NSDate* theDate;
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [self.nowDate initWithTimeIntervalSinceNow: -oneDay*30];
        self.Enddatestr=[dateformatter stringFromDate:theDate];
        [self date:self.Nowdatestr stop:self.Enddatestr];

        
    }else if(indexPath.row==2){
        [UIView animateWithDuration:0.3 animations:^{
            self.tabShow.frame=CGRectMake(0, 104, w, h-104);

                    }];

        self.tabShow.frame=CGRectMake(0, 104, w, h-104);
        self.labTitle.text=[NSString stringWithFormat:@"筛选时间:%@",self.arrList[indexPath.row]];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        NSDate* theDate;
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [self.nowDate initWithTimeIntervalSinceNow: -oneDay*90];
        self.Enddatestr=[dateformatter stringFromDate:theDate];
        [self date:self.Nowdatestr stop:self.Enddatestr];

        
    }else if(indexPath.row==3){
        [UIView animateWithDuration:0.3 animations:^{
            self.tabShow.frame=CGRectMake(0, 104, w, h-104);
            
        }];        self.labTitle.text=[NSString stringWithFormat:@"筛选时间:%@",self.arrList[indexPath.row]];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        NSDate* theDate;
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [self.nowDate initWithTimeIntervalSinceNow: -oneDay*180 ];
        self.Enddatestr=[dateformatter stringFromDate:theDate];
        [self date:self.Nowdatestr stop:self.Enddatestr];

    }else if(indexPath.row==4){
        [UIView animateWithDuration:0.3 animations:^{
            self.tabShow.frame=CGRectMake(0, 104, w, h-104);
            
        }];
        self.labTitle.text=[NSString stringWithFormat:@"筛选时间:%@",self.arrList[indexPath.row]];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        NSDate* theDate;
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [self.nowDate initWithTimeIntervalSinceNow: -oneDay*365 ];
        self.Enddatestr=[dateformatter stringFromDate:theDate];
        [self date:self.Nowdatestr stop:self.Enddatestr];

        
    }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.tabShow==tableView){
    modelCell *cell=[[ modelCell  alloc]init];;
        return[cell add:self.dataArray[indexPath.row]];}
    return 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)date:(NSString *)over    stop:(NSString *) start {
    self.count=2;
    NSDictionary *json = @{
                           @"id" : @"1",
                           @"jsonrpc":@"2.0",
                           @"method":@"crm.coupon.queryCheckinLog",
                           @"params":@{
                                   
                                   @"userId":self.userID,
                                   @"pageNumber":@"1",
                                   @"pageSize":@"10",
                                   @"startDate":start,
                                   @"endDate":over
                                   
                                   }
                           };
    
    NSLog(@"json%@",json);
    AFHTTPRequestOperationManager*manager=[AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //申明请求的数据是json类型
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置请求头
    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json;charset=utf-8"forHTTPHeaderField:@"Content-Type"];
    //发送请求
    [manager POST:  card  parameters:json success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.dataArray removeAllObjects];
        
        
        NSDictionary *dic=[responseObject objectForKey:@"result"];
        [self.dataArray addObjectsFromArray:[dic objectForKey:@"data"]];
        [self.tabShow reloadData];
      [UIView animateWithDuration:0.3 animations:^{
            self.rightView.alpha=0;
        }];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIView animateWithDuration:0.3 animations:^{
            self.rightView.alpha=0;
        }];

        NSLog(@"Error: %@", error);
        [[[UIAlertView alloc]initWithTitle:@"提示信息" message:@"网络出错"  delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil]  show];
    }];

}
-(void)refresh:(NSString *)over    stop:(NSString *) start {
    
    NSDictionary *json = @{
                           @"id" : @"1",
                           @"jsonrpc":@"2.0",
                           @"method":@"crm.coupon.queryCheckinLog",
                           @"params":@{
                                   
                                   @"userId":self.userID,
                                   @"pageNumber":[NSString stringWithFormat: @"%d",self.count],
                                   @"pageSize":@"10",
                                   @"startDate":start,
                                   @"endDate":over
                                   
                                   }
                           };
    
    NSLog(@"json%@",json);
    AFHTTPRequestOperationManager*manager=[AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //申明请求的数据是json类型
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置请求头
    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json;charset=utf-8"forHTTPHeaderField:@"Content-Type"];
    //发送请求
    [manager POST: @"http://piaowu.hiyo.cc/wxtest/doProxy"  parameters:json success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
       
        
        self.count++;
        NSDictionary *dic=[responseObject objectForKey:@"result"];
        [self.dataArray addObjectsFromArray:[dic objectForKey:@"data"]];
        [self.tabShow reloadData];
        [UIView animateWithDuration:0.3 animations:^{
            self.rightView.alpha=0;
        }];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIView animateWithDuration:0.3 animations:^{
            self.rightView.alpha=0;
        }];
        
        NSLog(@"Error: %@", error);
        [[[UIAlertView alloc]initWithTitle:@"提示信息" message:@"网络出错"  delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil]  show];
    }];
    
}

@end
