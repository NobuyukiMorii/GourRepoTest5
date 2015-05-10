//
//  DetailViewController.m
//  SampleTableView002
//
//  Created by Eriko Ichinohe on 2014/10/20.
//  Copyright (c) 2014年 Eriko Ichinohe. All rights reserved.
//

#import "DetailViewController.h"
//Youtube再生用


@interface DetailViewController ()
 // アクティビティインジケータ
@property UIActivityIndicatorView *indicator;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //名前を表示
    NSArray *Movie = [self select_movie];

    self.coffeeTitle.text = [NSString stringWithFormat:@"%@",[Movie valueForKeyPath:@"Movie"][@"title"]];
    self.descriptionText.text = [Movie valueForKeyPath:@"Restaurant"][@"name"];
    
    //動画を表示
    self.webView.delegate = self;
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[Movie valueForKeyPath:@"Movie"][@"youtube_iframe_url"]]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];

    // アクティビティインジケータ表示
    [self startActiviryIndicatorAnimation];

}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // アクティビティインジケータ非表示
    [self stopActivityIndicatorAnimation];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)startActiviryIndicatorAnimation
{
    _indicator = [[UIActivityIndicatorView alloc] init];
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;

    //画面の大きさを取得する
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    // 画面の中央に表示するようにframeを変更する
    float w = _indicator.frame.size.width;
    float h = _indicator.frame.size.height;
    float x = rect.size.width/2;
    float y = self.webView.frame.size.height/2 - h/2;
    _indicator.frame = CGRectMake(x, y, w, h);
    
    _indicator.hidesWhenStopped = YES;
    [_indicator startAnimating];
    [self.view addSubview:_indicator];
}

// アクティビティインジケータ非表示
- (void)stopActivityIndicatorAnimation
{
    [_indicator stopAnimating];
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
