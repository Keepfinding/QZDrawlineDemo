//
//  DrawLineView.m
//  QZDrawRectTestDemo
//
//  Created by Stephen Hu on 2018/12/28.
//  Copyright © 2018 Stephen Hu. All rights reserved.
//  一个折线图，其实这个不重要，主要是为了学习大神封装的工具学习

#import "DrawLineView.h"
#import "CGContextManager.h"
#import "UIView+SetRect.h"
#import "HexColors.h"
#import "AttributedStringConfigHelper.h"
@interface DrawLineView()
@property (nonatomic, strong) CGContextManager *manager;
@property (nonatomic, strong) NSMutableDictionary <NSString *, DrawingAttribute *> *attributes;
@end
@implementation DrawLineView {
    CGFloat _leftGap;  // 左边距
    CGFloat _rightGap; // 右边距
    CGFloat _topGap;   // 顶部边距
    
    CGFloat _areaWidth;
    CGFloat _areaHeight;
    
    NSInteger _hrLineCount; // 水平线条数目
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self contextSetting];
    }
    return self;
}
- (void)contextSetting {
    self.manager = [CGContextManager contextManagerFromView:self];
    self.attributes = [NSMutableDictionary dictionary];
    _leftGap    = 50.f;
    _rightGap   = 30.f;
    _topGap     = 50.f;
    _areaWidth  = Width - _leftGap - _rightGap;
    _areaHeight = 125.f;
    _hrLineCount = 5; // 五条线
    {
        DrawingAttribute *attribute = [DrawingAttribute new];
        attribute.lineWidth         = 0.5f;
        attribute.strokeColor       = [UIColor colorWithHexString:@"#D2DFEC"];
        attribute.fillColor         = [UIColor colorWithHexString:@"#FFB03B"];
        self.attributes[@"base"]    = attribute;
    }
    
    {
        DrawingAttribute *attribute = [DrawingAttribute new];
        attribute.lineWidth         = 1.f;
        attribute.lineCap           = kCGLineCapRound;
        attribute.strokeColor       = [UIColor colorWithHexString:@"#FFB03B"];
        attribute.fillColor         = [UIColor colorWithHexString:@"#FFB03B"];
        self.attributes[@"line"] = attribute;
    }
}
- (void)drawRect:(CGRect)rect {
    [self.manager startDraw];
    if (self.model) {
        // 网格格子宽度
        CGFloat vtGridGap = _areaWidth / (self.model.times.count - 1);
        // 网格格子高度
        CGFloat hrGridGap = _areaHeight / (_hrLineCount - 1);
        // 绘制标题
        NSMutableAttributedString *title = \
        [NSMutableAttributedString mutableAttributedStringWithString:self.model.title config:^(NSString *string, NSMutableArray<AttributedStringConfig *> *configs) {
            [configs addObject:[FontAttributeConfig configWithFont:[UIFont AvenirWithFontSize:16.f] range:NSMakeRange(0, string.length)]];
        }];
        [self.manager drawAttributeString:title atPoint:CGPointMake(Width / 2.f, _topGap / 2.f) centerAlignment:DrawContentCenterAlignmentCenterPosition offsetX:0 offsetY:0];
        // 绘制坐标轴
        // 抗锯齿不开启
        [self.manager shouldAntialias:NO];
        // 设置绘制参数(线宽、颜色等)
        [self.manager useDrawingAttribute:self.attributes[@"base"]];
        // 画多条线block内返回线的数据二维数组
        [self.manager strokeLinesPathWithPointValuesArraysBlock:^NSArray<NSArray<NSValue *> *> *{
            // 创建数组用来保存所有的线
            NSMutableArray *allLines = [NSMutableArray array];
            // 垂直线条
            for (int i = 0; i < self.model.times.count; i++) {
                // 创建数组用来保存起点和终点（一条线）
                NSMutableArray *vtLines = [NSMutableArray array];
                // 创建顶部的点
                [vtLines addObject:CGPointValue(self->_leftGap + i * vtGridGap, self->_topGap)];
                // 创建底部的点
                [vtLines addObject:CGPointValue(self->_leftGap + i * vtGridGap, self->_topGap + self->_areaHeight)];
                [allLines addObject:vtLines];
            }
            // 水平线条
            for (int i = 0 ; i < self ->_hrLineCount; i++) {
                // 创建一个数组用来保存一条线的两个点
                NSMutableArray *hrLines = [NSMutableArray array];
                // 左侧起点
                [hrLines addObject:CGPointValue(self -> _leftGap, self -> _topGap + i * hrGridGap)];
                // 右侧终点
                [hrLines addObject:CGPointValue(self->_leftGap + self->_areaWidth, self->_topGap  + i * hrGridGap)];
                [allLines addObject:hrLines];
            }
            return allLines;
        } closePath:NO];
        // 开启抗锯齿
        [self.manager shouldAntialias:YES];
        // 绘制坐标系底部的文本
        [self.model.times enumerateObjectsUsingBlock:^(StudyTimeModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx != 0) { // 0点没有文字标记
                [self.manager drawAttributeString:model.timeString atPoint:CGPointMake(self -> _leftGap + idx * vtGridGap, self -> _areaHeight + self -> _topGap) centerAlignment:DrawContentCenterAlignmentBottomSide offsetX:0 offsetY:3.f];
            }
        }];
        // 绘制坐标系左边的文本
        for (int i = 0; i < _hrLineCount; i++) {
            if (i == _hrLineCount - 1) {
                continue;
            }
            NSMutableAttributedString *percent = \
            [NSMutableAttributedString mutableAttributedStringWithString:[NSString stringWithFormat:@"%.f%%",(1.f - i * (1.f / (_hrLineCount - 1))) * 100.f] config:^(NSString *string, NSMutableArray<AttributedStringConfig *> *configs) {
                [configs addObject:[FontAttributeConfig configWithFont:[UIFont AvenirWithFontSize:10.f] range:NSMakeRange(0, string.length - 1)]];
                [configs addObject:[FontAttributeConfig configWithFont:[UIFont AvenirLightWithFontSize:6.f] range:NSMakeRange(string.length - 1, 1)]];
                [configs addObject:[ForegroundColorAttributeConfig configWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.75f] range:NSMakeRange(0, string.length)]];
            }];
            [self.manager drawAttributeString:percent atPoint:CGPointMake(_leftGap, _topGap + i * hrGridGap) centerAlignment:DrawContentCenterAlignmentLeftSide offsetX:-3.f offsetY:0];
        }
        // 计算并存储需要显示的点位
        NSMutableArray <NSValue *> *centerPoints = [NSMutableArray array];
        [self.model.times enumerateObjectsUsingBlock:^(StudyTimeModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            [centerPoints addObject:CGPointValue(self -> _leftGap + idx * vtGridGap, self -> _areaHeight - model.percent * self -> _areaHeight + self -> _topGap)];
        }];
        // 绘制坐标轴中的折线
        // 应用折线的配置
        [self.manager useDrawingAttribute:self.attributes[@"line"]];
        // 画一条线block需要一个点位的数组返回值
        [self.manager strokeLinePathWithPointValueArrayBlock:^NSArray<NSValue *> *{
            return centerPoints;
        } closePath:NO];
        // 画折线上的圆点block需要返回一个点位数组
        [self.manager fillCirclesWithRadius:2.f centerPointValueArrayBlock:^NSArray<NSValue *> *{
            // 去掉点位的第一个点
            return [centerPoints subarrayWithRange:NSMakeRange(1, centerPoints.count - 1)];
        }];
        // 绘制折线上的文本值
        [centerPoints enumerateObjectsUsingBlock:^(NSValue * _Nonnull point, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx != 0) {// 去除第一个点
                [self.manager drawAttributeString:self.model.times[idx].percentString atPoint:point.CGPointValue
                                  centerAlignment:DrawContentCenterAlignmentTopSide offsetX:0 offsetY:-3.f];
            }
        }];
    }
}


@end
