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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.tintColor = [UIColor darkGrayColor];
    searchBar.placeholder = @"検索";
    searchBar.keyboardType = UIKeyboardTypeDefault;
    searchBar.delegate = self;
    
    // UINavigationBar上に、UISearchBarを追加
    self.navigationItem.titleView = searchBar;
    self.navigationItem.titleView.frame = CGRectMake(0, 0, 320, 44);
    
    // 非同期表示・キャッシュ用の配列の初期化
    self.imageCache = [NSMutableDictionary dictionary];
    self.downloaderManager = [NSMutableDictionary dictionary];
    
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
    
    if ([_imageCache objectForKey:indexPath]) {
        // すでにキャッシュしてある場合
        [cell.thumbnail setImage:[_imageCache objectForKey:indexPath]];
        
    } else {
        if (_coffeeListTableView.dragging == NO && _coffeeListTableView.decelerating == NO)
        {
            // URLから画像を表示
            dispatch_queue_t q_global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_queue_t q_main = dispatch_get_main_queue();
            
            cell.imageView.image = nil;
            
            dispatch_async(q_global, ^{
                NSString *imageURL = _movieArray[(long)indexPath.row][@"Movie"][@"thumbnails_url"];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString: imageURL]]];
                if(!image){
                    image = [UIImage imageNamed:@"NoImage.png"];
                }
                dispatch_async(q_main, ^{
                    [cell.thumbnail setImage:image];
                });
            });
        }
    }
    
    return cell;
}

//何か行が押された時DetailViewControllerに画面遷移する
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //遷移先画面のカプセル化（インスタンス化）
    DetailViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    dvc.select_num = (int)indexPath.row;
    
    dvc.select_movie = _movieArray[(long)indexPath.row];
    
    //ナビゲーションコントローラーの機能で画面遷移
    [[self navigationController] pushViewController:dvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//リターンされた時に発動
- (void) searchItem:(NSString *) searchText {
    // 検索処理
}

- (void) searchBarSearchButtonClicked: (UISearchBar *) searchBar {
    [searchBar resignFirstResponder];
}

//検索
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *) searchText {
    NSLog(@"serch text=%@", searchText);
    
    // 送信したいURLを作成する
    NSURL *url = [NSURL URLWithString:@"http://localhost:8888/GourRepoM2/ApiMovies/returnMoviesJson.json"];
    // Mutableなインスタンスを作成し、インスタンスの内容を変更できるようにする
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    // MethodにPOSTを指定する。
    request.HTTPMethod = @"POST";
    
    // 送付したい内容を、文字列として作成する
    NSString *body = [NSString stringWithFormat:@"areaname=%@", searchText];
    
    // HTTPBodyには、NSData型で設定する
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // 作成に失敗する場合には、リクエストが送信されないので
    // チェックする
    if (!connection) {
        NSLog(@"connection error.");
    } else {
        //Loadingを表示するView(通信中にぐるぐる回るやつ) 設定
        UIScreen *sc = [UIScreen mainScreen];
        uv_load = [[UIView alloc] initWithFrame:CGRectMake(0,0,sc.applicationFrame.size.width, sc.applicationFrame.size.height)];
        uv_load.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.7];
        
        //ぐるぐる回る
        UIActivityIndicatorView *aci_loading;
        aci_loading = [[UIActivityIndicatorView alloc] init];
        aci_loading.frame = CGRectMake(0,0,sc.applicationFrame.size.width, sc.applicationFrame.size.height);
        aci_loading.center = uv_load.center;
        aci_loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [aci_loading startAnimating];
        
        //Loading表示
        [uv_load addSubview:aci_loading];
        [self.view addSubview:uv_load];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    // データの長さを0で初期化
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{

    // 受信したデータを追加していく
    [self.receivedData appendData:data];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSString *message = [array valueForKeyPath:@"message"];
    _movieArray = [message valueForKeyPath:@"result"];
    
    //データがない場合
    if(_movieArray.count == 0){
        //アラートビューを出す
        // １行で書くタイプ（１ボタンタイプ）
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"" message:@"ムービーがありませんでした。"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        //通信を中断
        [connection cancel];
        
        //Loading非表示
        uv_load.hidden = true;
    }
    NSLog(@"%@",_movieArray);
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

    //テーブルをリフレッシュする
    [self.coffeeListTableView reloadData];
    //Loading非表示
    uv_load.hidden = true;
    
    NSLog(@"Did finish loading!");
}

@end