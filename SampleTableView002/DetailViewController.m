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
    
    //テーブルのデリゲート
    _MovieTableView.delegate = self;
    _MovieTableView.dataSource = self;
    
    // セクション名を設定する
    sectionList =  [NSArray arrayWithObjects:@"ムービー", @"レストラン", nil];
    
    //テーブル
    //渡されたデータを取り出す
    NSArray *Movie = [self select_movie];

    //動画タイトル
    NSString *MovieTitle = [NSString stringWithFormat:@"%@",[Movie valueForKeyPath:@"Movie"][@"title"]];
    NSString *MovieCreated = [NSString stringWithFormat:@"%@",[Movie valueForKeyPath:@"Movie"][@"created"]];
    //ユーザー情報
    NSArray *User = [Movie valueForKeyPath:@"User"];
    NSString *ReporterName = [NSString stringWithFormat:@"%@",[User valueForKeyPath:@"UserProfile"][@"name"]];
    
    //レストラン情報
    RestDataHeader = @[@"店名",@"住所"];
    NSString *RestName = [NSString stringWithFormat:@"%@",[Movie valueForKeyPath:@"Restaurant"][@"name"]];
    NSString *RestAddress = [NSString stringWithFormat:@"%@",[Movie valueForKeyPath:@"Restaurant"][@"address"]];
    
    //名前を表示
    self.coffeeTitle.text = [NSString stringWithFormat:@"%@",[Movie valueForKeyPath:@"Movie"][@"title"]];

    //セクション１
    MovieDataHeader = @[@"タイトル",@"レポーター",@"撮影日時"];
    MovieData = @[MovieTitle,ReporterName,MovieCreated];
    //セクション２
    RestDataHeader = @[@"店名",@"住所"];
    RestData = @[RestName,RestAddress];
    
    //セルの項目をまとめる
    NSArray *datas = [NSArray arrayWithObjects:MovieData, RestData, nil];
    dataSource = [NSDictionary dictionaryWithObjects:datas forKeys:sectionList];
    
    NSLog(@"%@",dataSource);
    
    //動画を表示
    self.webView.delegate = self;
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[Movie valueForKeyPath:@"Movie"][@"youtube_iframe_url"]]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];

    // アクティビティインジケータ表示
    [self startActiviryIndicatorAnimation];
}


//テーブル全体のセクションの数を返す
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionList count];
}

//セクション名を返す
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sectionList objectAtIndex:section];
}

//セクションの項目数を返す
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionName = [sectionList objectAtIndex:section];
    return [[dataSource objectForKey:sectionName] count];
}

//指定された箇所のセルを作成する
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // セルが作成されていないか?
    if (!cell) { // yes
        // セルを作成
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // セクション名を取得する
    NSString *sectionName = [sectionList objectAtIndex:indexPath.section];
    
    // セクション名をキーにしてそのセクションの項目をすべて取得
    NSArray *items = [dataSource objectForKey:sectionName];
    
    // セルにテキストを設定
    cell.textLabel.text = [items objectAtIndex:indexPath.row];
    
    return cell;
}

//動画のダウンロードが始まった時
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

//動画のダウンロードが終わった時
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // アクティビティインジケータ非表示
    [self stopActivityIndicatorAnimation];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//エラーになった時
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //アラートビューを出す
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"ネットワークエラー" message:@"ネットワークが良いところでもう一度お試し下さい。"
                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
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
    
    //オブジェクトの画面の高さを取得する
    float navigationBar_hight = self.navigationController.navigationBar.frame.size.height;
    float statusBar_height = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float label_hight = self.coffeeTitle.frame.size.height;
    float webView_height = self.webView.frame.size.height;
    float activity_indicator_y = navigationBar_hight + statusBar_height + label_hight + webView_height/2 + 10;
    
    // 画面の中央に表示するようにframeを変更する
    float w = _indicator.frame.size.width;
    float h = _indicator.frame.size.height;
    float x = rect.size.width/2;
    float y = activity_indicator_y;
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
