//
//  UploadViewController.m
//  SampleTableView002
//
//  Created by 森井宣至 on 2015/05/11.
//  Copyright (c) 2015年 Eriko Ichinohe. All rights reserved.
//

#import "UploadViewController.h"
#import "GTMOAuth2Authentication.h"
#import "GTMOAuth2ViewControllerTouch.h"

@interface UploadViewController ()

@property (nonatomic, retain) GTMOAuth2Authentication *auth;
-(void) startLogin;

@end

static NSString *const kKeychainItemName = @"GOAuthTest";
static NSString *const scope = @"https://www.googleapis.com/auth/calendar";// Calendar APIを利用する場合のscope
static NSString *const clientId = @"399027015882-d92fksp0gn87tjeudelrhirqgkkae9bi.apps.googleusercontent.com";// 発行されたClient IDを設定
static NSString *const clientSecret = @"HPL-NJzOtVVQjxg9lVy4jmtz";// 発行されたClient Secretを設定
static NSString *const hasLoggedIn = @"hasLoggedInKey";// NSUserDefaultに保存するための文字列


@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


// ページ読込開始時
-(void)webViewDidStartLoad:(UIWebView*)webView{
    //インジケータをくるくるさせる
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
 }

// ページ読込完了時
-(void)webViewDidFinishLoad:(UIWebView*)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookiesForURL:[NSURL URLWithString:@"http://hogehoge.com"]];
    [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie *cookie, NSUInteger idx, BOOL *stop) {
        [cookieStorage deleteCookie:cookie];
    }];

    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:[NSDictionary dictionaryWithObjectsAndKeys:
                                                               cookieName, NSHTTPCookieName,
                                                               cookieValue, NSHTTPCookieValue,
                                                               cookieDomain, NSHTTPCookieDomain,
                                                               @"/", NSHTTPCookiePath,
                                                               [NSDate distantFuture], NSHTTPCookieExpires,
                                                               nil]];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //NSLog(@"web view string 's  is %@",request.URL.absoluteString);
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewDidAppear:(BOOL)animated
{
    // アプリ起動してOAuth認証動作を開始する
    [self startLogin];
}

// OAuth認証の開始
- (void)startLogin
{
    // 既に認証をしたかどうか確認
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL hasLoggedin = [defaults boolForKey:hasLoggedIn];
    
    if(hasLoggedin == YES) {
        // 認証したことがある場合
        self.auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                          clientID:clientId
                                                                      clientSecret:clientSecret];
        // アクセストークンの取得
        [self authorizeRequest];
        
        //WebViewの表示
        [self displayWebView];
    } else {
        // 認証したことがない場合
        GTMOAuth2ViewControllerTouch *gvc = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:scope
                                                                                       clientID:clientId
                                                                                   clientSecret:clientSecret
                                                                               keychainItemName:kKeychainItemName
                                                                                       delegate:self
                                                                               finishedSelector:@selector(viewController:finishedWithAuth:error:)
                                             ];
        // 認証画面の表示
        [self presentViewController:gvc animated:YES completion:nil];
    }
}

// 認証後に実行する処理
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error
{
    if(error != nil) {
        // 認証失敗
    } else {
        // 認証成功
        self.auth = auth;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:hasLoggedIn];
        [defaults synchronize];
        
        // アクセストークンの取得
        [self authorizeRequest];
        
        //WebViewの表示
        [self displayWebView];

        
    }
    
    // 認証画面を閉じる
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

// アクセストークンの取得処理
- (void)authorizeRequest
{
    NSLog(@"%@", self.auth);
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:self.auth.tokenURL];
    [self.auth authorizeRequest:req completionHandler:^(NSError *error) {
        NSLog(@"%@", self.auth);
    }];
}

//WebViewの表示
- (void)displayWebView{
    //画面の大きさを取得する
    UIWebView *wv = [[UIWebView alloc] init];
    wv.delegate = self;
    
    //ステータスバーの高さ
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    wv.frame = CGRectMake(0, self.navigationController.navigationBar.bounds.size.height+statusHeight, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.bounds.size.height-statusHeight);
    wv.scalesPageToFit = YES;
    [self.view addSubview:wv];
    
    NSLog(@"%@",_RestId);
    NSString *str = @"http://localhost:8888/GourRepoM2/Movies/selectRestForAddMovie";
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [wv loadRequest:req];
}

@end
