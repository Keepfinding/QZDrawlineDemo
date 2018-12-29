//
//  ViewController.m
//  QZDrawRectTestDemo
//
//  Created by Stephen Hu on 2018/12/28.
//  Copyright © 2018 Stephen Hu. All rights reserved.
//

#import "ViewController.h"
#import "DrawLineViewController.h"
@interface ViewController ()
@property (nonatomic, strong) StudyInfoModel *model;
@end

@implementation ViewController
- (IBAction)drawRectAction:(UIButton *)sender {
    DrawLineViewController *lineVc = [DrawLineViewController new];
    lineVc.model = self.model;
    [self presentViewController:lineVc animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    StudyInfoModel *model = [StudyInfoModel new];
    model.title           = @"语文";
    [model.times addObject:studyTimeModel(@"0", 0)];
    [model.times addObject:studyTimeModel(@"5", 0.1)];
    [model.times addObject:studyTimeModel(@"10", 0.18)];
    [model.times addObject:studyTimeModel(@"15", 0.34)];
    [model.times addObject:studyTimeModel(@"20", 0.57)];
    [model.times addObject:studyTimeModel(@"25", 0.60)];
    [model.times addObject:studyTimeModel(@"30", 0.75)];
    [model.times addObject:studyTimeModel(@"35", 0.93)];
    self.model = model;
}


@end
