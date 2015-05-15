//
//  UploadViewController.m
//  SampleTableView002
//
//  Created by 森井宣至 on 2015/05/11.
//  Copyright (c) 2015年 Eriko Ichinohe. All rights reserved.
//

#import "UploadViewController.h"

@interface UploadViewController ()

@end

@implementation UploadViewController

-(void)refresh {
    [self.uploadWebView reload];
    if (self.uploadWebView) {
        if ([self.uploadWebView canGoBack]) {
            [self.uploadWebView reload];
        } else {
            
            //最初に呼び出すのと同じページを読み込む処理
            //[self loadFirstPage];
            NSLog(@"%@",@"ssss");
            //画面の大きさを取得する
            UIWebView *wv = [[UIWebView alloc] init];
            wv.delegate = self;
            
            //ステータスバーの高さ
            float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
            
            wv.frame = CGRectMake(0, self.navigationController.navigationBar.bounds.size.height+statusHeight, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.bounds.size.height-statusHeight);
            wv.scalesPageToFit = YES;
            [self.view addSubview:wv];
            
            NSString* presenturl = [self.uploadWebView stringByEvaluatingJavaScriptFromString:@"document.URL"];
            NSLog(@"%@",presenturl);
            
            NSString *str = @"http://localhost:8888/GourRepoM2/Movies/selectRestForAddMovie";
            NSURL *url = [NSURL URLWithString:str];
            NSURLRequest *req = [NSURLRequest requestWithURL:url];
            [wv loadRequest:req];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //リフレッシュボタンを追加
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]
                            initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                            target:self
                            action:@selector(refresh)
                            ];
    // ナビゲーションバーの右に追加する。
    self.navigationItem.rightBarButtonItem = btn;
    
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


// ページ読込開始時にインジケータをくるくるさせる
-(void)webViewDidStartLoad:(UIWebView*)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
 }

// ページ読込完了時にインジケータを非表示にする
-(void)webViewDidFinishLoad:(UIWebView*)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
