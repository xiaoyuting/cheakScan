//
//  LoadViewController.m
//  HXapp
//
//  Created by CUIZE on 16/9/20.
//  Copyright © 2016年 CUIZE. All rights reserved.
//

#import "LoadViewController.h"
#import "SMProgressHUD.h"

#import "CheakViewController.h"
@interface LoadViewController ()
@property NSDictionary *Dic;
@property NSMutableArray*Array;
@property NSString * shopID;

@end

@implementation LoadViewController

- (void)viewDidLoad {
     
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    UIImage *image=[UIImage imageNamed:@"load"];
    UIImageView *viewImage=[[UIImageView alloc]initWithImage:image];
    viewImage.frame=self.view.frame;
    viewImage.image=image;
    [self.view addSubview:viewImage];

    [self loadInfo];
            self.Array =[[NSMutableArray alloc]init];
   // [self remberGet];

    // Do any additional setup after loading the view.
}
//- (void)UIKeyboardWillChangeFrame:(NSNotification *)noti{
//    CGRect frame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
//    CGFloat keyY = frame.origin.y;
//    CGFloat keyDuration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey]floatValue];
//    [UIView animateWithDuration:keyDuration animations:^{
//        self.view.transform = CGAffineTransformMakeTranslation(0, keyY - h );
//    }];
//}

-(void)remberGet{
    NSString *path=NSHomeDirectory();
    NSString * path2=[path stringByAppendingString:@"/Documents/"];
    NSString * path1=[path2 stringByAppendingString:@"/arry.xml"];
    NSArray *array=[[NSArray alloc]init];
    array=[NSArray arrayWithContentsOfFile:path1];
    if(array.count==0){
        self.name.textField .text=@"";
        
    }else{
        self.name.textField.text=[array.lastObject objectForKey:@"name"];
        self.Password.textField.text=[array.lastObject objectForKey:@"pass"];
        self.name.moved=YES;
       // self.name.textField.text.length = 0
        self.Password.moved=NO;
    }
}

-(void)loadInfo{
    self.name=[[LYTextField alloc]initWithFrame:CGRectMake(40,  h-287, w-80, 30)];
    self.name.textField.clearButtonMode =  UITextFieldViewModeWhileEditing;
    self.name.ly_placeholder=@"账号";
    self.name.textField.placeholder=@"输入用户名";
    self.name.image.image=[UIImage imageNamed:@"6.png"];
    self.Password=[[LYTextField alloc]initWithFrame:CGRectMake(40, h-207, w-80, 30)];
    self.Password.ly_placeholder=@"密码";
    self.Password.textField.placeholder=@"输入密码";
    self.Password.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.Password.textField.keyboardType=UIKeyboardTypeNumberPad;
    self.Password.textField.secureTextEntry=YES;
     self.Password.image.image=[UIImage imageNamed:@"4.png"];
    [self.view addSubview:self.name];
    [self.view addSubview:self.Password];
    self.btnJump=[[UIButton alloc]initWithFrame:CGRectMake(40, h-107, w-80, 30)];
    _btnJump.backgroundColor=[UIColor whiteColor];
     [_btnJump setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_btnJump setTitle:@"登录" forState:UIControlStateNormal];
    [_btnJump setTitle:@"登录中" forState:UIControlStateHighlighted];
    [_btnJump  addTarget:self action:@selector(pushView) forControlEvents:UIControlEventTouchUpInside];
    _btnJump.layer.cornerRadius=5;
    _btnJump.layer.masksToBounds=YES;

    [self.view addSubview:_btnJump ];
    self.btnCancel=[[UIButton alloc]initWithFrame:CGRectMake(w-110, h-340, 80, 30)];
    [self.btnCancel setTitle:@"注销账户" forState:UIControlStateNormal];
    [self.btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btnCancel.layer.borderWidth=1;
    _btnCancel.layer.borderColor=[UIColor blackColor].CGColor;
 //   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UIKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

    //[self.view addSubview:self.btnCancel];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 -(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event         {
     [self.view endEditing:YES];
 }
 -(void)pushView{
      
    if([self.name.textField.text isEqualToString:@""]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"帐号为空" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
        
        
    }else if([self.Password.textField.text isEqualToString:@""]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"密码为空" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
        
        
    }else{
        [[SMProgressHUD shareInstancetype] showLoading];
       // NSString *urlStr= [NSString stringWithFormat:@"http://buy.hiyo.cc:5050/user/service/rest/admin/login/%@/%@/.json",self.name.textField.text,self.Password.textField.text];
       // http://139.196.253.143:6060
        NSString *urlStr= [NSString stringWithFormat:@"http://139.196.253.143:6060/user/service/rest/admin/login/%@/%@/.json",self.name.textField.text,self.Password.textField.text];
        NSURL *url=[NSURL URLWithString:urlStr];
        
        NSURLRequest *request=[NSURLRequest requestWithURL:url];
        
        NSOperationQueue *queue=[NSOperationQueue mainQueue];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            [[SMProgressHUD shareInstancetype] dismissLoadingView];
            NSLog(@"--block回调数据--%@---%lu", [NSThread currentThread],data.length);
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"dic===%@",dict);
            NSDictionary *dic=[dict objectForKey:@"Result"];
            NSNumber *err=[dic objectForKey:@"errorCode"];
            int a=[err intValue];
            if( a ==-1){
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:[dic objectForKey:@"errorMessage"]    delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                [alert show];
            }else if( a==1){
                
                self.shopID=[dic  objectForKey:@"shopId"];
                NSString *path=NSHomeDirectory();
                NSArray *arrID=[NSArray arrayWithObject: [dic objectForKey:@"userId"]];
                path= [path stringByAppendingString:@"/Documents/"];
                NSString *fileName = [path stringByAppendingPathComponent:@"shopid.xml"];
                if([arrID writeToFile:fileName atomically:YES])
                {
                    NSLog(@"写入成功");
                }
                else
                {
                    NSLog(@"写入失败");
                }

               // [self write];
                CheakViewController *vic1=[[CheakViewController alloc ]init];
             
                vic1.userID=[NSString stringWithFormat:@"%@",
                             [dic objectForKey:@"userId"] ];
               
                UINavigationController *niv=[[UINavigationController alloc]initWithRootViewController:vic1];
                [niv.navigationBar setTintColor:[UIColor whiteColor]];
                [niv.navigationBar setBarTintColor:[UIColor colorWithRed:203/255.0 green:34/255.0 blue:39/255.0 alpha:1]];
                
                [self presentViewController:niv  animated:YES completion:nil];
                //[self.navigationController pushViewController:vic1 animated:YES];
            }
            
            
        }];}
    
    
}
-(void)write{
    self. Dic =[[NSDictionary alloc]initWithObjectsAndKeys: self.name.textField.text ,@"name",self.Password.textField.text,@"pass", nil];
    [self.Array addObject:self.Dic];
    
    NSString *path=NSHomeDirectory();
    
    path= [path stringByAppendingString:@"/Documents/"];
    NSString *fileName = [path stringByAppendingPathComponent:@"arry.xml"];
    if([self.Array writeToFile:fileName atomically:YES])
    {
        //        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"保存成功" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        //        [alert show];
        
        NSLog(@"写入成功");
    }
    else
    {
        NSLog(@"写入失败");
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
