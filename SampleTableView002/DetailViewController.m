//
//  DetailViewController.m
//  SampleTableView002
//
//  Created by Eriko Ichinohe on 2014/10/20.
//  Copyright (c) 2014年 Eriko Ichinohe. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%d",self.select_num);
    
    //if文を使った場合
//    if (self.select_num == 0) {
//        self.coffeeTitle.text = @"ブルーマウンテン";
//    }
//    
//    if (self.select_num == 1) {
//        self.coffeeTitle.text = @"キリマンジャロ";
//    }
    
    //配列を使った場合
    _movieArray = @[@{@"name":@"ブルーマウンテン",
                       @"desc":@"ジャマイカにあるブルーマウンテン山脈の標高800～1200mの限られた地域で栽培されるコーヒー豆のブランド。\nブルーマウンテンの特徴として、香りが非常に高く、繊細な味であることが挙げられる。香りが高いため、他の香りが弱い豆とブレンドすることが多い。"},
                     @{@"name":@"キリマンジャロ",@"desc":@"説明キリ"},
                     @{@"name":@"ブラジル",@"desc":@"説明ブラジル"},
                     @{@"name":@"コロンビア",@"desc":@"説明コロンビア"}];
    
//    _coffeeArray = @[@"ブルーマウンテン",@"キリマンジャロ",@"ブラジル",@"コロンビア"];
//    
    self.coffeeTitle.text = [NSString stringWithFormat:@"%@とは",_movieArray[self.select_num][@"name"]];
    self.descriptionText.text = _movieArray[self.select_num][@"desc"];
    
//    switch (self.select_num) {
//        case 0:
//            self.descriptionText.text = @"ジャマイカにあるブルーマウンテン山脈の標高800～1200mの限られた地域で栽培されるコーヒー豆のブランド。\nブルーマウンテンの特徴として、香りが非常に高く、繊細な味であることが挙げられる。香りが高いため、他の香りが弱い豆とブレンドすることが多い。";
//            break;
//            
//        default:
//            break;
//    }
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
