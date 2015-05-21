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

    // UISeachBar(self.searchBar)の検索ボタンを常に有効にする
    [self getTextFieldFromView:searchBar].enablesReturnKeyAutomatically = NO;
    
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
    
    NSString * urlString = [NSString stringWithFormat:@"http://mory.weblike.jp/GourRepoM2/ApiMovies/returnMoviesJson.json"];
    NSURL * url = [NSURL URLWithString:urlString];
    //ステータスバーのぐるぐる表示
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSData * data = [NSData dataWithContentsOfURL:url];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSString *message = [array valueForKeyPath:@"message"];
    _movieArray = [message valueForKeyPath:@"result"];
    
    //ステータスバーのぐるぐる非表示
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
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
    //Loading非表示
    uv_load.hidden = true;
    searchText = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (![searchText isEqualToString:@""]){
        
        NSLog(@"%@",@"あるよ");
    
        // 送信したいURLを作成する
        NSString *str1 = @"http://mory.weblike.jp/GourRepoM2/ApiMovies/returnMoviesJsonGET.json?areaname=";
        str1 = [str1 stringByAppendingString: searchText];
        NSURL *url2 = [NSURL URLWithString:str1];
        
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
        
        //ステータスバーのぐるぐる表示
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        NSData * data = [NSData dataWithContentsOfURL:url2];
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSString *message = [array valueForKeyPath:@"message"];
        _movieArray = [message valueForKeyPath:@"result"];
        
        if(!_movieArray){
            NSLog(@"connection error.");
            //Loading非表示
            uv_load.hidden = true;
        } else {
            if(_movieArray.count == 0){
               NSLog(@"connection error.");
                //Loading非表示
                uv_load.hidden = true;
            } else {
                //テーブルをリフレッシュする
                [self.coffeeListTableView reloadData];
                //Loading非表示
                uv_load.hidden = true;
                
                NSLog(@"Did finish loading!");
            }
        }
        //ステータスバーのぐるぐる非表示
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

// UISearchBar内のUITextFieldを取得する
- (UITextField *)getTextFieldFromView:(UIView *)view {
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            return (UITextField *)subview;
        } else {
            UITextField *textField = [self getTextFieldFromView:subview];
            if (textField) {
                return textField;
            }
        }
    }
    return nil;
}

@end