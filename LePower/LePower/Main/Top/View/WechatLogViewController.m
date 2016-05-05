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
    NSString *_code;
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
}



#pragma mark - 微信登录
-(void)sendAuthRequest
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ; // snsapi_base snsapi_userinfo
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

// 如果你的程序要发消息给微信，那么需要调用WXApi的sendReq函数： 其中req参数为SendMessageToWXReq类型
//需要注意的是，SendMessageToWXReq的scene成员，如果scene填WXSceneSession，那么消息会发送至微信的会话内。如果scene填WXSceneTimeline，那么消息会发送至朋友圈。如果scene填WXSceneFavorite,那么消息会发送到“我的收藏”中。scene默认值为WXSceneSession。

-(BOOL) sendReq:(BaseReq*)req {
//    SendMessageToWXReq
    NSLog(@"%@ %i",req.openID,req.type);
    return YES;
}

//授权后回调 WXApiDelegate
-(void)onResp:(BaseReq *)resp
{
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    SendAuthResp *aresp = (SendAuthResp *)resp;
    if (aresp.errCode== 0) {
        _code = aresp.code;
        NSDictionary *dic = @{@"code":_code};
    }
}

- (void)logIn {
    //    https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    
//    https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxf0e81c3bee622d60&redirect_uri=http%3A%2F%2Fnba.bluewebgame.com%2Foauth_response.php&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect
    
//    https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxf0e81c3bee622d60&redirect_uri=http%3A%2F%2Fnba.bluewebgame.com%2Foauth_response.php&scope=snsapi_userinfo&response_type=code&state=STATE#wechat_redirect
    
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
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WXAppID,WXAppSecret,_code];
    
    [DataServer requestWithFullUrlString:url params:nil method:@"GET" data:nil block:^(id result) {
        NSLog(@"%@",result);
    }];
}

//-(void)getAccess_token
//{
//    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
//    
//    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWXAPP_ID,kWXAPP_SECRET,self.wxCode.text];
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSURL *zoneUrl = [NSURL URLWithString:url];
//        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
//        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (data) {
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                /*
//                 {
//                 "access_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWiusJMZwzQU8kXcnT1hNs_ykAFDfDEuNp6waj-bDdepEzooL_k1vb7EQzhP8plTbD0AgR8zCRi1It3eNS7yRyd5A";
//                 "expires_in" = 7200;
//                 openid = oyAaTjsDx7pl4Q42O3sDzDtA7gZs;
//                 "refresh_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWi2ZzH_XfVVxZbmha9oSFnKAhFsS0iyARkXCa7zPu4MqVRdwyb8J16V8cWw7oNIff0l-5F-4-GJwD8MopmjHXKiA";
//                 scope = "snsapi_userinfo,snsapi_base";
//                 }
//                 */
//                
//                NSString *token = [dic objectForKey:@"access_token"];
//                NSString *openid = [dic objectForKey:@"openid"];
//                
//            }
//        });
//    });
//}

//-(void)getUserInfo
//{
//    // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
//    
//    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",self.access_token.text,self.openid.text];
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSURL *zoneUrl = [NSURL URLWithString:url];
//        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
//        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (data) {
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                /*
//                 {
//                 city = Haidian;
//                 country = CN;
//                 headimgurl = "http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0";
//                 language = "zh_CN";
//                 nickname = "xxx";
//                 openid = oyAaTjsDx7pl4xxxxxxx;
//                 privilege =     (
//                 );
//                 province = Beijing;
//                 sex = 1;
//                 unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
//                 }
//                 */
//                
//                self.nickname.text = [dic objectForKey:@"nickname"];
//                self.wxHeadImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"headimgurl"]]]];
//                
//            }
//        });
//        
//    });
//}



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
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }      else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
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
