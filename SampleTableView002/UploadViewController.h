//
//  UploadViewController.h
//  SampleTableView002
//
//  Created by 森井宣至 on 2015/05/11.
//  Copyright (c) 2015年 Eriko Ichinohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *uploadWebView;
@property (nonatomic,assign) NSString *RestId;
@property (nonatomic,assign) NSTimer *tm;

@property (nonatomic,assign) BOOL flg;
@property (nonatomic,assign) int google_access_count;

@end
