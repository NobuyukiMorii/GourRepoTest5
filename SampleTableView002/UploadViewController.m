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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //画面の大きさを取得する
    UIWebView *wv = [[UIWebView alloc] init];
    wv.delegate = self;
    
    //ステータスバーの高さ
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    wv.frame = CGRectMake(0, self.navigationController.navigationBar.bounds.size.height+statusHeight, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.bounds.size.height-statusHeight);
    wv.scalesPageToFit = YES;
    [self.view addSubview:wv];
    
    NSLog(@"%@",_RestId);
    NSString *str = @"http://mory.weblike.jp/GourRepoM2/Movies/selectRestForAddMovie";
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [wv loadRequest:req];

    
}


// ページ読込開始時
-(void)webViewDidStartLoad:(UIWebView*)webView{
    //インジケータをくるくるさせる
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
 }

// ページ読込完了時
-(void)webViewDidFinishLoad:(UIWebView*)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *urlString = [NSString stringWithFormat:@"%@", request];
    NSLog(@"url :%@", urlString);
    
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

@end
