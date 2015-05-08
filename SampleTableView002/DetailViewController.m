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

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //名前を表示
    NSArray *Movie = [self select_movie];

    self.coffeeTitle.text = [NSString stringWithFormat:@"%@",[Movie valueForKeyPath:@"Movie"][@"title"]];
    self.descriptionText.text = [Movie valueForKeyPath:@"Restaurant"][@"name"];
    
    //動画を表示
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[Movie valueForKeyPath:@"Movie"][@"youtube_iframe_url"]]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];


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
