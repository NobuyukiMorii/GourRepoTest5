//
//  UploadViewController.m
//  SampleTableView002
//
//  Created by 森井宣至 on 2015/05/11.
//  Copyright (c) 2015年 Eriko Ichinohe. All rights reserved.
//

#import "ViewController.h"
#import "UploadViewController.h"

@interface UploadViewController ()
@end

@implementation UploadViewController

- (void)cancelWeb
{
    NSLog(@"didn't finish loading within 20 sec");
    // do anything error
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //フラグをNoにする
    _flg = NO;
    _google_access_count = 0;
    
    //画面の大きさを取得する
    UIWebView *wv = [[UIWebView alloc] init];
    wv.delegate = self;
    
    //ステータスバーの高さ
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    wv.frame = CGRectMake(0, self.navigationController.navigationBar.bounds.size.height+statusHeight, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.bounds.size.height-statusHeight);
    wv.scalesPageToFit = YES;
    [self.view addSubview:wv];
    
    NSString *str = @"http://mory.weblike.jp/GourRepoM2/Movies/add/";
    //NSString *str = @"http://localhost:8888/GourRepoM2/Movies/add/";
    NSString *mergeStr = [str stringByAppendingString:_RestId];
    NSURL *url = [NSURL URLWithString:mergeStr];
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
    [self.tm invalidate];
    self.tm = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
//    if(_google_access_count >= 15){
//        return YES;
//    }
//        
    NSString *urlString = [NSString stringWithFormat:@"%@", [request valueForKeyPath:@"URL"]];
    NSLog(@"%@", urlString);

    
    NSString *error = @"&pageId=none";
    
    NSRange range = [urlString rangeOfString:error];
    if (range.location != NSNotFound) {
        //真っ白画面

        NSLog(@"%@",@"真っ白");
        //画面の大きさを取得する
        UIWebView *wv = [[UIWebView alloc] init];
        wv.delegate = self;
        
        //ステータスバーの高さ
        float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        
        wv.frame = CGRectMake(0, self.navigationController.navigationBar.bounds.size.height+statusHeight, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.bounds.size.height-statusHeight);
        wv.scalesPageToFit = YES;
        [self.view addSubview:wv];
        
        NSString *str = @"http://mory.weblike.jp/GourRepoM2/Movies/add/";
        //NSString *str = @"http://localhost:8888/GourRepoM2/Movies/add/";
        NSString *mergeStr = [str stringByAppendingString:_RestId];
        NSURL *url = [NSURL URLWithString:mergeStr];
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        [wv loadRequest:req];
        
    }
    
    //動画投稿完了時にメインの検索画面に戻す
    NSString *view = @"http://mory.weblike.jp/GourRepoM2/Movies/view";
    NSRange range2 = [urlString rangeOfString:view];
    
    if (range2.location != NSNotFound) {
        //遷移先画面のカプセル化（インスタンス化）
        ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        
        //ナビゲーションコントローラーの機能で画面遷移
        [[self navigationController] pushViewController:vc animated:YES];
        
        // 投稿完了時のアラートビュー
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"登録成功" message:@"動画の登録に成功しました。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
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
