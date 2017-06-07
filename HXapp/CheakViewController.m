//
//  CheakViewController.m
//  HXapp
//
//  Created by CUIZE on 16/9/20.
//  Copyright © 2016年 CUIZE. All rights reserved.
//

#import "CheakViewController.h"
#import "cheakrecordViewController.h"
#import "LoadViewController.h"



@interface CheakViewController ()
@property  AVAudioPlayer *player;
//@property  NSURL *url;
@property int index;
@property NSArray *array;
@property UIAlertView *ale;
@property NSString *info;
@property AVSpeechSynthesizer *av ;
@property AVSpeechUtterance *utterance;
@property  AVSpeechSynthesisVoice *voice;
@property (strong, nonatomic)   UIButton *btn;
@property (strong, nonatomic)   UIButton *cheakInfo;
@property  UIBarButtonItem *left;
@end

@implementation CheakViewController

-(id)init{
    if(self){
        self=[super init];
    }
    
    self.userID=[[NSString  alloc]init];
    return self;
}
- (void)STOPACTION  {
    self.btn.tag=1;
    self.navigationItem.leftBarButtonItem=nil;
    self.cheakInfo.alpha=1;
    [self.session stopRunning];
    [self.layer removeFromSuperlayer];
    // 去掉扫描显示的内容
    [self.timer invalidate];
    [self.line removeFromSuperview];
    [self.rectImage removeFromSuperview];
    [self.explainLabel removeFromSuperview];
   
}
- (void)Getphoto:(UIButton *)sender {
    if(sender.tag==1){
        self.cheakInfo.alpha=0;
        self.navigationItem.leftBarButtonItem=self.left;
        self.btn.tag=0;
        //获取摄像设备
        AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        //创建输入流
        AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        //创建输出流
        AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
        //设置代理 在主线程里刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        // 设置扫码作用区域，参数是区域占全屏的比例,x、y颠倒，高宽颠倒来设置= =什么鬼
        CGRect screenBounds = [ [ UIScreen mainScreen ] bounds ];
        [output setRectOfInterest:CGRectMake((screenBounds.size.height - (screenBounds.size.width - 60))/2/screenBounds.size.height, 30/screenBounds.size.width, (screenBounds.size.width - 60)/screenBounds.size.height, (screenBounds.size.width - 60)/screenBounds.size.width)];
        
        //初始化链接对象
        self.session = [[AVCaptureSession alloc]init];
        //高质量采集率
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
        
        [self.session addInput:input];
        [self.session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        
        self.layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        self.layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
        self.layer.frame=self.view.layer.bounds;// 设置照相显示的大小
        //    CGRect screenBounds = [ [ UIScreen mainScreen ] bounds ];
        //    self.layer.frame = CGRectMake(30, (screenBounds.size.height - (screenBounds.size.width - 60)) / 2, screenBounds.size.width - 60, screenBounds.size.width - 60);
        
        [self.view.layer insertSublayer:self.layer atIndex:2];// 设置层级，可以在扫码时显示一些文字
        
        //开始捕获
        [self.session startRunning];
        
        // 方框
        self.rectImage = [[UIImageView alloc]initWithFrame:CGRectMake(30, (screenBounds.size.height - (screenBounds.size.width - 60))/2, screenBounds.size.width - 60, screenBounds.size.width - 60)];
        self.rectImage.image = [UIImage imageNamed:@"pick_bg"];
        [self.view addSubview:self.rectImage];
        
        self.explainLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, (screenBounds.size.height - (screenBounds.size.width - 60))/2 + screenBounds.size.width - 50, screenBounds.size.width - 60, 30)];
        self.explainLabel.text = @"将方框对准二维码";
        self.explainLabel.textColor=[UIColor redColor];
        self.explainLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.explainLabel];
        
        // 线条动画
        self.upOrdown = NO;
        self.num =0;
        self.line = [[UIImageView alloc] initWithFrame:CGRectMake(70, (screenBounds.size.height - (screenBounds.size.width - 60))/2 + 10, screenBounds.size.width - 140, 2)];
        self.line.image = [UIImage imageNamed:@"line.png"];
        [self.view addSubview:self.line];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation) userInfo:nil repeats:YES];}}


-(void)animation
{
    CGRect screenBounds = [ [ UIScreen mainScreen ] bounds ];
    if (self.upOrdown == NO) {
        self.num ++;
        self.line.frame = CGRectMake(70, (screenBounds.size.height - (screenBounds.size.width - 60))/2 + 10 +2*self.num, screenBounds.size.width - 140, 2);
        if (2*self.num == 280) {
            self.upOrdown = YES;
        }
    }
    else {
        self.num --;
        self.line.frame = CGRectMake(70, (screenBounds.size.height - (screenBounds.size.width - 60))/2 + 10 +2*self.num, screenBounds.size.width - 140, 2);
        if (self.num == 0) {
            self.upOrdown = NO;
        }
    }
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSLog(@"调用摄像头");
    if (metadataObjects.count>0) {
        
        NSLog(@"调用摄像头==%@",metadataObjects);
        //[session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        
        self.scanResult = metadataObject.stringValue;// 将结果显示在label上
        
        if([[self.scanResult  substringToIndex:2] isEqualToString:@"CP"]){
            
            
            NSDictionary *json = @{
                                   @"id" : @"1",
                                   @"jsonrpc":@"2.0",
                                   @"method":@"crm.coupon.checkin",
                                   @"params":@{
                                           @"barCode":self.scanResult,
                                           @"userId":self.userID,
                                           
                                           
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
            [manager POST: card  parameters:json success:^(AFHTTPRequestOperation *operation, id responseObject) {
               
                NSDictionary *dic=[responseObject objectForKey:@"result"];
                if([[NSString stringWithFormat:@"%@",[dic objectForKey:@"success"]] isEqualToString:@"0"]){
                    [[[UIAlertView alloc]initWithTitle:@"提示信息" message:[NSString stringWithFormat:@"%@",[dic objectForKey:@"resultMsg"]]  delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil , nil]  show];
                }else{
                    NSString *str=[NSString stringWithFormat:@"券名:%@\n优惠 :%@\n时间:%@",[[[dic objectForKey:@"coupon"] objectForKey:@"coupon"] objectForKey:@"name"],[[[dic objectForKey:@"coupon"] objectForKey:@"coupon"] objectForKey:@"discountInfo"],[[dic objectForKey:@"coupon"] objectForKey:@"checkTime"]];
                    
                    [[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",[[[dic objectForKey:@"coupon"] objectForKey:@"shop"] objectForKey:@"name"]] message: str  delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil]  show];
                    
                    
                }
                self.utterance= [[AVSpeechUtterance alloc]initWithString:@"成功"];
                //需要转换的文本
                
                self. utterance.voice=self.voice;
                [self.av speakUtterance:self.utterance];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"Error: %@", error);
                self.utterance= [[AVSpeechUtterance alloc]initWithString:@"失败"];
                //需要转换的文本
                
                self. utterance.voice=self.voice;
                [self.av speakUtterance:self.utterance];
                [[[UIAlertView alloc]initWithTitle:@"提示信息" message:@"网络卡了下"  delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil]  show];
            }];
            
            
        }else{
            
                     // 1.创建请求
                        
                        AFHTTPRequestOperationManager*manager=[AFHTTPRequestOperationManager manager];
                        //申明返回的结果是json类型
                     manager.requestSerializer=[AFJSONRequestSerializer serializer];
                        //申明请求的数据是json类型
                      manager.responseSerializer=[AFJSONResponseSerializer serializer];
                                     //设置请求头
                        [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
                        [manager.requestSerializer setValue:@"application/json;charset=utf-8"forHTTPHeaderField:@"Content-Type"];
                        NSDictionary *json = @{
                                               @"id": @"1",
                                               @"jsonrpc": @"2.0",
                                               @"method": @"orderCheckin.ticket.newCheckin",
                                               @"params": @{
                                                   @"barCode":self.scanResult,
                                                   @"userId":self.userID
                                                 }
                                               };
            NSLog(@"jiuhua%@",json);
                        //发送请求
                        [manager POST:URL  parameters: json success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSLog(@"responseObject===%@",responseObject);
                            NSDictionary *dic=[responseObject objectForKey:@"result"];
                            
                            if([[ NSString stringWithFormat:@"%@",[dic objectForKey:@"errorCode"]] isEqualToString:@"0"]){
                                NSString *name=[[NSString alloc]init];
                                //单票
                                if([[ NSString stringWithFormat:@"%@",[dic objectForKey:@"ticketType"]] isEqualToString:@"1"]){
                                    name=@"门票";
                                    NSDictionary *dicticket=[dic objectForKey:@"ticket"];
                                    NSString *age=[[NSString alloc]init];
                                    if([[ NSString stringWithFormat:@"%@",[dicticket objectForKey:@"personTicketType"]] isEqualToString:@"1"]){
                                        age=@"儿童票";
                                    }else if([[ NSString stringWithFormat:@"%@",[dicticket objectForKey:@"personTicketType"]] isEqualToString:@"2"]){
                                        age=@"成人票";
                                    }
                                    else if([[ NSString stringWithFormat:@"%@",[dicticket objectForKey:@"personTicketType"]] isEqualToString:@"3"]){
                                        age=@"老人票";
                                    }
                                    
                                    NSString *info =  [NSString   stringWithFormat:@"%@%@%@x%@张",[dicticket objectForKey:@"shopName"],age,name,[dicticket objectForKey:@"counts"]];
                                    [[[UIAlertView alloc]initWithTitle:@"提示信息" message: info   delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil]  show];}
                                
                             
                            //美食
                            else if([[ NSString stringWithFormat:@"%@",[dic objectForKey:@"ticketType"]] isEqualToString:@"2"]){
                                     name=@"美食";
                                NSDictionary *food=[dic objectForKey:@"food"];
                                NSArray *subList=[food objectForKey:@"subProductList"];
                                if(subList.count==0){
                                  
                                     [[[UIAlertView alloc]initWithTitle:@"提示信息" message:  [NSString stringWithFormat:@"%@\n%@",[food objectForKey:@"productName"],[food objectForKey:@"orderTime"]]    delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil]  show];
                                }else{
                                NSString *strList=[[NSString alloc]init];
                                    for (id str  in subList) {
                                        strList=[strList stringByAppendingString:[NSString stringWithFormat:@"\n%@\n价格:%@－数量:%@",[str objectForKey:@"subShopProductName"],[str objectForKey:@"subTotalAmount"],[str objectForKey:@"subTotalCounts"]]];
                                    }
                                  
                                    [[[UIAlertView alloc]initWithTitle: [NSString stringWithFormat:@"%@",[food objectForKey:@"shopName"]] message:  [ NSString stringWithFormat:@"%@\n订单号:%@\n手机号:%@\n时间:%@%@",[NSString stringWithFormat:@"%@",[food objectForKey:@"productName"]],[NSString stringWithFormat:@"%@",[food objectForKey:@"orderNo"]],[NSString stringWithFormat:@"%@",[food objectForKey:@"mobile"]],[food objectForKey:@"orderTime"],strList]    delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil]  show];
                                }
                            }
                            //景＋餐
                                 else if([[ NSString stringWithFormat:@"%@",[dic objectForKey:@"ticketType"]] isEqualToString:@"3"]){
                                    name=@"景＋餐";
                                }
                            //景＋非餐
                                 else if([[ NSString stringWithFormat:@"%@",[dic objectForKey:@"ticketType"]] isEqualToString:@"4"]){
                                   name=@"景＋非餐";
                           [[[UIAlertView alloc]initWithTitle:@"提示信息" message:[NSString stringWithFormat:@"%@",[[dic objectForKey:@"packTicket"] objectForKey:@"successInfo"]]    delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil]  show];
                                }
                                self.utterance= [[AVSpeechUtterance alloc]initWithString:@"成功"];
                                //需要转换的文本
                                 self. utterance.voice=self.voice;
                                [self.av speakUtterance:self.utterance];
                            }else{
                                [[[UIAlertView alloc]initWithTitle:@"提示信息" message: [ NSString stringWithFormat:@"%@",[dic objectForKey:@"errorMessage"]]  delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil]  show];
                           
                            }
                            
                        }  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"Error: %@", error);
                            self.utterance= [[AVSpeechUtterance alloc]initWithString:@"失败"];
                            //需要转换的文本
                            
                            self. utterance.voice=self.voice;
                            [self.av speakUtterance:self.utterance];
                            [[[UIAlertView alloc]initWithTitle:@"提示信息" message:@"网络卡了下"  delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil]  show];
                        }];
                        
                   
             }
        // 关闭扫描，退出扫描界面
        [self.session stopRunning];
        [self.layer removeFromSuperlayer];
        
        // 去掉扫描显示的内容
        [self.timer invalidate];
        [self.line removeFromSuperview];
        [self.rectImage removeFromSuperview];
        [self.explainLabel removeFromSuperview];
    }
    self.btn.tag=1;
    self.cheakInfo.alpha=1;
    self.navigationItem.leftBarButtonItem=nil;
}


- (void)viewDidLoad {
    self.view.backgroundColor=[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    title.textColor=[UIColor whiteColor];
    title.text=@"商户核销系统";
    self.navigationItem.titleView = title;
    
   self. av = [[AVSpeechSynthesizer alloc]init];
    self.scanResult=[[NSString alloc]init];
    self.voice= [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    self.btn=[[UIButton alloc]initWithFrame:CGRectMake(40, 0.2*h , w-80, (w-80)*323/278.0)];
    [self.btn setBackgroundImage:[UIImage imageNamed:@"5"] forState:UIControlStateNormal];
    self.btn.layer.cornerRadius=5;
    [self.btn addTarget:self action:@selector(Getphoto:) forControlEvents:UIControlEventTouchUpInside];
    self.cheakInfo=[[UIButton alloc]initWithFrame:CGRectMake(40, h-107, w-80, 35)];
    self.cheakInfo.backgroundColor=[UIColor colorWithRed:193/255.0 green:41/255.0 blue:49/255.0 alpha:1];
    [self.cheakInfo setTitle:@"核销记录" forState:UIControlStateNormal];
    self.cheakInfo.layer.cornerRadius=5;
    [self.view addSubview:self.btn];
    [self.view addSubview:self.cheakInfo];
    self.btn.tag=1;
    [super viewDidLoad];
    [self.cheakInfo addTarget:self action:@selector(pushCheakview) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"注销" style:UIBarButtonItemStyleBordered target:self action:@selector(popView)];
   self.left=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(STOPACTION)];

    // Do any additional setup after loading the view.
}
-(void)popView{
    LoadViewController *vic =[[LoadViewController alloc]init];
 
    [self presentViewController:vic animated:YES completion:nil];
    
}
-(void)pushCheakview{
    cheakrecordViewController *vic =[[cheakrecordViewController alloc]init];
    UINavigationController *niv =[[UINavigationController alloc]initWithRootViewController:vic];
    vic.userID=self.userID;
    
    [niv.navigationBar setTintColor:[UIColor whiteColor]];
    [niv.navigationBar setBarTintColor:[UIColor colorWithRed:203/255.0 green:34/255.0 blue:39/255.0 alpha:1]];
    [self presentViewController:niv  animated:YES completion:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


