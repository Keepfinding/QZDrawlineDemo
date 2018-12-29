//
//  DrawLineViewController.m
//  QZDrawRectTestDemo
//
//  Created by Stephen Hu on 2018/12/28.
//  Copyright © 2018 Stephen Hu. All rights reserved.
//

#import "DrawLineViewController.h"
#import "DrawLineView.h"
#import "UIView+SetRect.h"
#import "InterpolationTypeView.h"
@interface DrawLineViewController ()

@end

@implementation DrawLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    DrawLineView *lineView = [[DrawLineView alloc] initWithFrame:CGRectMake(0, 80,Width, 200)];
    lineView.model = self.model;
    InterpolationTypeView *interView = [[InterpolationTypeView alloc] initWithFrame:CGRectMake(0, 300, Width, 200)];
    [self.view addSubview:lineView];
    [self.view addSubview:interView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
