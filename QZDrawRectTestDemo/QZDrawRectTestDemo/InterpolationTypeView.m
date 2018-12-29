//
//  InterpolationTypeView.m
//  QZDrawRectTestDemo
//
//  Created by Stephen Hu on 2018/12/28.
//  Copyright © 2018 Stephen Hu. All rights reserved.
//

#import "InterpolationTypeView.h"
#import "CGContextManager.h"
#import "DrawingAttribute.h"
#import "HexColors.h"
#import "UIView+SetRect.h"
#import "UIBezierPath+Interpolation.h"
@interface InterpolationTypeView()
@property (nonatomic, strong) CGContextManager                                     *manger;
@property (nonatomic, strong) NSMutableDictionary <NSString *, DrawingAttribute *> *attributes;
@end
@implementation InterpolationTypeView {
    
    CGFloat _leftGap;  // 左边距
    CGFloat _rightGap; // 右边距
    CGFloat _topGap;   // 顶部边距
    // 绘图区域
    CGFloat _areaWidth;
    CGFloat _areaHeight;
    
}
- (void)drawRect:(CGRect)rect {
    [self.manger startDraw];
    [self.manger useDrawingAttribute:self.attributes[@"base"]];
    [self.manger shouldAntialias:NO];
    // 坐标轴绘制
    [self.manger strokeLinesPathWithPointValuesArraysBlock:^NSArray<NSArray<NSValue *> *> *{
        return @[
                 // y轴
                 @[CGPointValue(self->_leftGap, self->_topGap),CGPointValue(self->_leftGap, self->_topGap + self->_areaHeight)],
                 // X轴
                 @[CGPointValue(self->_leftGap, self->_topGap + self->_areaHeight / 2.f),CGPointValue(self->_leftGap + self->_areaWidth, self->_topGap + self->_areaHeight / 2.f)]
                 ];
    } closePath:NO];
    // 绘制曲线
    [self.manger shouldAntialias:YES];
    // 获取随机点位
    NSArray <NSValue *> *points = [self randomPoints];
    // 配置上下文属性
    [self.manger useDrawingAttribute:self.attributes[@"line"]];
    // 绘制直连各个点的虚线
    [self.manger strokeLinePathWithPointValueArrayBlock:^NSArray<NSValue *> *{
        return points;
    } closePath:NO];
    // 绘制圆滑链接各个点的实线曲线
    [self.manger useDrawingAttribute:self.attributes[@"path"]];
    // 大神的这个方法好牛逼😝
    UIBezierPath *path = [UIBezierPath interpolateCGPointsWithHermite:points closed:NO];
    [path stroke];
    // 绘制圆点
    [self.manger useDrawingAttribute:self.attributes[@"line"]];
    [self.manger fillCirclesWithRadius:2.f centerPointValueArrayBlock:^NSArray<NSValue *> *{
        return points;
    }];
}
- (NSArray <NSValue *> *)randomPoints {// 返回一个随机点位数组
    NSInteger count = 14;
    CGFloat   gap   = _areaWidth / (count - 1);
    NSMutableArray  *points = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        // 得到一个在绘图区域上下范围内的数值
        CGFloat randomValue = (arc4random() % 2 == 0 ? 1.f : -1.f) * (arc4random() % (NSInteger)(_areaHeight * 0.5f));
        [points addObject:CGPointValue(_leftGap + i * gap, _topGap + _areaHeight * 0.5f + randomValue)];
    }
    return points;
}
- (void)contextSetting {
    // 设定初始值和相关的绘图信息
    self.manger     = [CGContextManager contextManagerFromView:self];
    self.attributes = [NSMutableDictionary dictionary];
    _leftGap    = 20.f;
    _rightGap   = 20.f;
    _topGap     = 20.f;
    _areaWidth  = Width - _leftGap - _rightGap;
    _areaHeight = self.height - 40.f;
    {
        DrawingAttribute *attribute = [DrawingAttribute new];
        attribute.lineWidth     = 0.5f;
        attribute.strokeColor   = [UIColor colorWithHexString:@"#D2DFEC"];
        attribute.fillColor     = [UIColor colorWithHexString:@"#FFB03B"];
        self.attributes[@"base"]    = attribute;
    }
    {
        DrawingAttribute *attribute = [DrawingAttribute new];
        attribute.lineWidth         = 0.5f;
        attribute.lineCap           = kCGLineCapRound;
        // 具体含义待查（虚线）
        attribute.lineDashLengths   = @[@(4.f), @(2.f)];
        attribute.strokeColor       = [UIColor colorWithHexString:@"#404139"];
        attribute.fillColor         = [UIColor colorWithHexString:@"#FFB03B"];
        self.attributes[@"line"] = attribute;
    }
    {
        DrawingAttribute *attribute = [DrawingAttribute new];
        attribute.lineWidth         = 1.f;
        attribute.strokeColor       = [UIColor colorWithHexString:@"#FFB03B"];
        self.attributes[@"path"]    = attribute;
    }
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self contextSetting];
    }
    return self;
}

@end
