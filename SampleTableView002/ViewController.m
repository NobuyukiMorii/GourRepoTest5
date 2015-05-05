//
//  ViewController.m
//  SampleTableView002
//
//  Created by Eriko Ichinohe on 2014/10/20.
//  Copyright (c) 2014年 Eriko Ichinohe. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "customTableViewCell.h"

@interface ViewController ()
@end

@implementation ViewController
{
    UIView *loadingView;
    UIActivityIndicatorView *indicator;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    _coffeeListTableView.delegate = self;
    _coffeeListTableView.dataSource = self;
    
    _coffeeListTableView.rowHeight = 100;
    
    //カスタマイズしたセルをテーブルビューにセット
    UINib *nib = [UINib nibWithNibName:@"customCell" bundle:nil];
    
    //カスタムセルを使用しているTableViewに登録
    [self.coffeeListTableView registerNib:nib forCellReuseIdentifier:@"Cell"];
    
    NSString * urlString = [NSString stringWithFormat:@"http://localhost:8888/GourRepoM2/ApiMovies/returnMoviesJson.json"];
    NSURL * url = [NSURL URLWithString:urlString];
    NSData * data = [NSData dataWithContentsOfURL:url];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSString *message = [array valueForKeyPath:@"message"];
    _movieArray = [message valueForKeyPath:@"result"];
    
}

//行数を返す
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _movieArray.count;
}

//セルに文字を表示する
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //定数を宣言（static = 静的)
    static NSString *CellIdentifer = @"Cell";
    
    //セルの再利用
    customTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    
    cell.title.text = [NSString stringWithFormat:@"%@",_movieArray[(long)indexPath.row][@"Movie"][@"title"]];
    cell.count.text = [NSString stringWithFormat:@"%@",_movieArray[(long)indexPath.row][@"Movie"][@"count"]];
    cell.RestName.text = [NSString stringWithFormat:@"%@",_movieArray[(long)indexPath.row][@"Restaurant"][@"name"]];
    cell.StationName.text = [NSString stringWithFormat:@"%@",_movieArray[(long)indexPath.row][@"Restaurant"][@"access_station"]];
    cell.ReporterName.text = [NSString stringWithFormat:@"%@",_movieArray[(long)indexPath.row][@"User"][@"UserProfile"][@"name"]];

    // URLから画像を表示
    NSString *urlString = [NSString stringWithFormat:@"%@",_movieArray[(long)indexPath.row][@"Movie"][@"thumbnails_url"]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc]initWithData:data];
    if(!img){
        urlString = @"http://toko9000.com/ecapps/files/no-image-available.png";
        url = [NSURL URLWithString:urlString];
        data = [NSData dataWithContentsOfURL:url];
        img = [[UIImage alloc]initWithData:data];
    }
    [cell.thumbnail setImage:img];
    
    return cell;
}

//何か行が押された時DetailViewControllerに画面遷移する
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"Tap:%ld",indexPath.row);
    
    //遷移先画面のカプセル化（インスタンス化）
    DetailViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    dvc.select_num = (int)indexPath.row;
    
    //ナビゲーションコントローラーの機能で画面遷移
    [[self navigationController] pushViewController:dvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//リターンされた時に発動
- (IBAction)serchMovie:(id)sender {

    //ぐるぐるを表示するための処理
    loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
    // 雰囲気出すために背景を黒く半透明する
    loadingView.backgroundColor = [UIColor blackColor];
    loadingView.alpha = 0.5f;
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    // でっかいグルグル
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    // 画面の中心に配置
    [indicator setCenter:CGPointMake(loadingView.bounds.size.width / 2, loadingView.bounds.size.height / 2)];
    // 画面に追加
    [loadingView addSubview:indicator];
    [self.view addSubview:loadingView];
    // ぐるぐる開始
    [indicator startAnimating];

    
    // 送信したいURLを作成する
    NSURL *url = [NSURL URLWithString:@"http://localhost:8888/GourRepoM2/ApiMovies/returnMoviesJson.json"];
    // Mutableなインスタンスを作成し、インスタンスの内容を変更できるようにする
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    // MethodにPOSTを指定する。
    request.HTTPMethod = @"POST";
    
    // 送付したい内容を、key1=value1&key2=value2・・・という形の
    // 文字列として作成する
    NSString *areaname = self.serchTextField.text;
    NSString *body = [NSString stringWithFormat:@"areaname=%@", areaname];
    
    // HTTPBodyには、NSData型で設定する
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLConnection     *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // 作成に失敗する場合には、リクエストが送信されないので
    // チェックする
    if (!connection) {
        NSLog(@"connection error.");
    }
    //リロードする
    [self.coffeeListTableView reloadData];
}

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response{
    // データの長さを0で初期化
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{

    //テーブルの設定
    _coffeeListTableView.delegate = self;
    _coffeeListTableView.dataSource = self;
    _coffeeListTableView.rowHeight = 100;
    
    //カスタマイズしたセルをテーブルビューにセット
    UINib *nib = [UINib nibWithNibName:@"customCell" bundle:nil];
    
    //カスタムセルを使用しているTableViewに登録
    [self.coffeeListTableView registerNib:nib forCellReuseIdentifier:@"Cell"];

    // 受信したデータを追加していく
    [self.receivedData appendData:data];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSString *message = [array valueForKeyPath:@"message"];
    _movieArray = [message valueForKeyPath:@"result"];
   
    NSLog(@"%@",_movieArray);
}

- (void)connectionDifFinishLoading:(NSURLConnection *)connection {
    // ぐるぐる停止
    [indicator stopAnimating];
    // 画面から除去して黒い半透明を消す
    [loadingView removeFromSuperview];
    
    NSLog(@"Did finish loading!");
}

@end