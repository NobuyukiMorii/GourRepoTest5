//
//  ViewController.h
//  SampleTableView002
//
//  Created by Eriko Ichinohe on 2014/10/20.
//  Copyright (c) 2014年 Eriko Ichinohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate>
{
    NSArray *_movieArray;   //メンバ変数宣言
    UIView *uv_load;        //LoadingView(通信中にぐるぐる回るやつ)
    NSString *KensakuText;   //検索文字列
}

@property (weak, nonatomic) NSMutableData *receivedData;

@property (weak, nonatomic) IBOutlet UITableView *coffeeListTableView;

//一度読み込んだ画像をキャッシュして、再び読み込まない
@property (nonatomic, strong) NSMutableDictionary *imageCache;
@property (nonatomic, strong) NSMutableDictionary *downloaderManager;

@end

