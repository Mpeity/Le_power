//
//  WechatLogViewController.m
//  LePower
//
//  Created by nick_beibei on 16/4/6.
//  Copyright © 2016年 nick_beibei. All rights reserved.
//

#import "WechatLogViewController.h"
#import "WXApi.h"

@interface WechatLogViewController ()<WXApiDelegate>
{
    UIImageView *_bgImgView;
}

@end

@implementation WechatLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self _createSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_createSubviews {
//     login_btn_wechat_login  login_btn_wechat_login_down  login_wechat_bg
    // 背景图片
    _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.8)];
    _bgImgView.image = [UIImage imageNamed:@"login_wechat_bg"];
    [self.view addSubview:_bgImgView];
    // 微信登录按钮
    UIButton *wechatBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-200)/2, kScreenHeight*0.675, 200, 40)];
    [wechatBtn setBackgroundImage:[UIImage imageNamed:@"login_btn_wechat_login"] forState:UIControlStateNormal];
    [wechatBtn setImage:[UIImage imageNamed:@"login_btn_wechat_login_down"] forState:UIControlStateSelected];
    [wechatBtn addTarget:self action:@selector(wechatBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wechatBtn];
    // label
    UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-200)/2, kScreenHeight*0.85, 200, 20)];
    textlabel.text = @"微信登陆后可使用更多高级功能";
    textlabel.font = [UIFont systemFontOfSize:14];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:textlabel];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-55, 30, 50, 30)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}


// 返回按钮响应方法
- (void)backBtnAction:(UIButton *)button {
    [self dismissViewControllerAnimated:NO completion:nil];
}


// 微信登录按钮响应方法
- (void)wechatBtnAction:(UIButton *)button {
    // 向微信注册
    [WXApi registerApp:WXAppID];
    [self sendAuthRequest];
    [self logIn];
    
}



#pragma mark - 微信登录
-(void)sendAuthRequest
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

// 如果你的程序要发消息给微信，那么需要调用WXApi的sendReq函数： 其中req参数为SendMessageToWXReq类型
//需要注意的是，SendMessageToWXReq的scene成员，如果scene填WXSceneSession，那么消息会发送至微信的会话内。如果scene填WXSceneTimeline，那么消息会发送至朋友圈。如果scene填WXSceneFavorite,那么消息会发送到“我的收藏”中。scene默认值为WXSceneSession。
-(BOOL) sendReq:(BaseReq*)req {
//    SendMessageToWXReq
    return YES;
}


// onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
-(void) onReq:(BaseReq*)req {
    NSLog(@"------%@ %i",req.openID,req.type);
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];  
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

// 如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面
-(void) onResp:(BaseResp*)resp {
    NSLog(@"--------%i %@ %i",resp.errCode,resp.errStr,resp.type);
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}


- (void)logIn {
    //    https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    
    NSString *urlString = @"https://api.weixin.qq.com/sns/oauth2/access_token?";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *appid = WXAppID;
    NSString *secret = WXAppSecret;
    NSString *code = @"CODE";
    NSString *grant_type = @"authorization_code";
    [params setObject:appid forKey:@"appid"];
    [params setObject:secret forKey:@"secret"];
    [params setObject:code forKey:@"code"];
    [params setObject:grant_type forKey:@"grant_type"];
    
    [DataServer requestWithFullUrlString:urlString params:params method:@"GET" data:nil block:^(id result) {
        
        NSLog(@"%@",result);
    }];
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
