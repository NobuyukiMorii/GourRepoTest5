//
//  DetailViewController.h
//  SampleTableView002
//
//  Created by Eriko Ichinohe on 2014/10/20.
//  Copyright (c) 2014年 Eriko Ichinohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    //セクション名を指定する
    NSArray *sectionList;
    
    //テーブルに表示するデータを格納する変数
    NSDictionary *dataSource;
    NSDictionary *headerSource;
    
    //ムービーに関するデータ
    NSArray *MovieDataHeader;
    NSArray *MovieData;
    
    //レストランに関するデータ
    NSArray *RestDataHeader;
    NSArray *RestData;
    NSString *RestId;
}

@property (weak, nonatomic) IBOutlet UILabel *coffeeTitle;

@property (nonatomic,assign) int select_num;
@property (nonatomic,assign) NSArray* select_movie;

@property (weak, nonatomic) IBOutlet UITableView *MovieTableView;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
