//
//  customTableViewCell.h
//  SampleTableView002
//
//  Created by Eriko Ichinohe on 2015/04/15.
//  Copyright (c) 2015年 Eriko Ichinohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *RestName;
@property (weak, nonatomic) IBOutlet UILabel *StationName;
@property (weak, nonatomic) IBOutlet UILabel *ReporterName;

@end
