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
    UIScreen* screen = [UIScreen mainScreen];
    
    UIWebView *wv = [[UIWebView alloc] init];
    wv.delegate = self;
    wv.frame = CGRectMake(0, 0, screen.applicationFrame.size.width, screen.applicationFrame.size.height);
    wv.scalesPageToFit = YES;
    [self.view addSubview:wv];
    
    NSLog(@"%@",_RestId);
    NSString *str1 = @"http://localhost:8888/GourRepoM2/Movies/add/";
    NSString *str2 = _RestId;
    NSString *str3 = [str1 stringByAppendingString:str2];
                      
    NSURL *url = [NSURL URLWithString:str3];
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
