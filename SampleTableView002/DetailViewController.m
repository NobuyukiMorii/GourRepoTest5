//
//  DetailViewController.m
//  SampleTableView002
//
//  Created by Eriko Ichinohe on 2014/10/20.
//  Copyright (c) 2014年 Eriko Ichinohe. All rights reserved.
//

#import "DetailViewController.h"
#import "UploadViewController.h"
#import "customTableViewCell2.h"
//Youtube再生用


@interface DetailViewController ()
 // アクティビティインジケータ
@property UIActivityIndicatorView *indicator;
@end

@implementation DetailViewController


- (void)upload
{
    UploadViewController *uploadViewController = [[UploadViewController alloc] init];
    [[self navigationController] pushViewController:uploadViewController animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // タイトルとボタンのスタイルを指定した生成例
    UIBarButtonItem *btn =
    [[UIBarButtonItem alloc]
     initWithTitle:@"Upload"
     style:UIBarButtonItemStylePlain
     target:self  // デリゲートのターゲットを指定
     action:@selector(upload)
     ];
     self.navigationItem.rightBarButtonItem = btn;
    
    //テーブルのデリゲート
    _MovieTableView.delegate = self;
    _MovieTableView.dataSource = self;
    
    //カスタマイズしたセルをテーブルビューにセット
    UINib *nib = [UINib nibWithNibName:@"customCell2" bundle:nil];
    //カスタムセルを使用しているTableViewに登録
    [self.MovieTableView registerNib:nib forCellReuseIdentifier:@"Cell"];
    // セクション名を設定する
    sectionList =  [NSArray arrayWithObjects:@"ムービー", @"レストラン", nil];
    
    //テーブル
    //渡されたデータを取り出す
    NSArray *Movie = [self select_movie];

    //動画タイトル
    NSString *MovieTitle = [NSString stringWithFormat:@"%@",[Movie valueForKeyPath:@"Movie"][@"title"]];
    NSString *MovieCount = [NSString stringWithFormat:@"%@",[Movie valueForKeyPath:@"Movie"][@"count"]];
    NSString *Moviedescription = [NSString stringWithFormat:@"%@",[Movie valueForKeyPath:@"Movie"][@"description"]];
    NSString *MovieCreated = [NSString stringWithFormat:@"%@",[Movie valueForKeyPath:@"Movie"][@"created"]];
    //ユーザー情報
    NSArray *User = [Movie valueForKeyPath:@"User"];
    NSString *ReporterName = [NSString stringWithFormat:@"%@",[User valueForKeyPath:@"UserProfile"][@"name"]];
    
    //レストラン情報
    NSString *RestName = [NSString stringWithFormat:@"%@",[Movie valueForKeyPath:@"Restaurant"][@"name"]];
    NSString *RestAddress = [NSString stringWithFormat:@"%@",[Movie valueForKeyPath:@"Restaurant"][@"address"]];
    NSString *RestGenre = [NSString stringWithFormat:@"%@",[Movie valueForKeyPath:@"Restaurant"][@"category_name_l"]];
    NSString *RestStation = [NSString stringWithFormat:@"%@",[Movie valueForKeyPath:@"Restaurant"][@"access_station"]];
    NSString *RestOpentime = [NSString stringWithFormat:@"%@",[Movie valueForKeyPath:@"Restaurant"][@"opentime"]];
    
    //名前を表示
    self.coffeeTitle.text = [NSString stringWithFormat:@"%@",[Movie valueForKeyPath:@"Movie"][@"title"]];

    //セクション１
    MovieDataHeader = @[@"タイトル",@"レポーター",@"説明文",@"再生回数",@"撮影日時"];
    MovieData = @[MovieTitle,ReporterName,Moviedescription,MovieCount,MovieCreated];
    //セクション２
    RestDataHeader = @[@"店名",@"ジャンル",@"最寄駅",@"住所",@"営業時間"];
    RestData = @[RestName,RestGenre,RestStation,RestAddress,RestOpentime];
    
    //セルの項目をまとめる
    NSArray *datas = [NSArray arrayWithObjects:MovieData, RestData, nil];
    dataSource = [NSDictionary dictionaryWithObjects:datas forKeys:sectionList];
    
    NSArray *headers = [NSArray arrayWithObjects:MovieDataHeader, RestDataHeader, nil];
    headerSource = [NSDictionary dictionaryWithObjects:headers forKeys:sectionList];
    
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
    customTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // セクション名を取得する
    NSString *sectionName = [sectionList objectAtIndex:indexPath.section];
    
    // セクション名をキーにしてそのセクションの項目をすべて取得
    NSArray *items = [dataSource objectForKey:sectionName];
    NSArray *headerNames = [headerSource objectForKey:sectionName];
    
    // セルにテキストを設定
    cell.headerName.font = [UIFont systemFontOfSize:10.0];
    cell.headerName.text = [headerNames objectAtIndex:indexPath.row];
    
    cell.item.font = [UIFont systemFontOfSize:10.0];
    cell.item.text = [items objectAtIndex:indexPath.row];
    
    return cell;
}

//カスタマイズするheaderSectionの高さ指定
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0f;
}

//セクションの指定
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 30.0f)];
    sectionView.backgroundColor = [UIColor clearColor];
    
    UIScreen* screen = [UIScreen mainScreen];
    
    UILabel *title_l = [[UILabel alloc] init];
    title_l.frame = CGRectMake(0, 0, screen.applicationFrame.size.width, 30);
    title_l.textColor = [UIColor whiteColor];
    title_l.backgroundColor = [UIColor blueColor];
    title_l.textAlignment = NSTextAlignmentLeft;
    title_l.font = [UIFont systemFontOfSize:13.0];

    // セクション名を設定する
    if (section == 0) {
        title_l.text = @"Movie";
    } else if(section == 1) {
        title_l.text = @"Restaurant";
    }
    
    [sectionView addSubview:title_l];
    
    return sectionView;
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
