//
//  CGContextManager.h
//  CGContext
//
//  Created by YouXianMing on 2017/8/23.
//  Copyright © 2017年 TechCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+DrawRect.h"

@interface CGContextManager : NSObject

@property (nonatomic, readonly) CGContextRef context;

+ (instancetype)contextManagerFromView:(UIView *)view;

- (void)startDraw;

#pragma mark - 'UIView+DrawRect.h' 的壳(外观设计模式)

/**
 设置使用的属性设置

 @param drawingAttribute 属性对象
 */
- (void)useDrawingAttribute:(DrawingAttribute *)drawingAttribute;

/**
 在一个path上填充一个矩形区域

 @param rect CGRect值
 */
- (void)fillRect:(CGRect)rect;

/**
 在一个path上填充多个矩形区域(注意:不管填充多少个矩形区域,都只是一个path)
 
 @param rectValueArrayBlock 提供CGRect参数的一维数组的block
 */
- (void)fillWithRectValueArrayBlock:(NSArray <NSValue *> * (^)(void))rectValueArrayBlock;

/**
 在一个path上描绘一条线条
 
 @param pointValueArrayBlock 提供线条参数一维数组的block
 @param closePath 是否闭合线条
 */
- (void)strokeLinePathWithPointValueArrayBlock:(NSArray <NSValue *> * (^)(void))pointValueArrayBlock closePath:(BOOL)closePath;

/**
 在一个path上描绘多条线条(注意:不管绘制多少条线条,都只是一个path)

 @param pointValuesArraysBlock 提供线条参数二维数组的block
 @param closePath 是否闭合线条
 */
- (void)strokeLinesPathWithPointValuesArraysBlock:(NSArray <NSArray <NSValue *> *> * (^)(void))pointValuesArraysBlock closePath:(BOOL)closePath;

/**
 根据给定的圆心在一个path上进行圆形区域的填充
 
 @param radius 圆的半径
 @param centerPoint 圆心点
 */
- (void)fillCircleWithRadius:(CGFloat)radius centerPoint:(CGPoint)centerPoint;

/**
 根据给定的圆心点组成的数组,在多个path上进行圆形区域的填充
 
 @param radius 圆的半径
 @param centerPointValueArrayBlock 提供圆心点组成数组的block
 */
- (void)fillCirclesWithRadius:(CGFloat)radius centerPointValueArrayBlock:(NSArray <NSValue *> * (^)(void))centerPointValueArrayBlock;

/**
 根据给定的圆心点,在一个path上进行圆的描绘
 
 @param radius 圆的半径
 @param centerPoint 圆心点
 */
- (void)strokeCircleRadius:(CGFloat)radius centerPoint:(CGPoint)centerPoint;

/**
根据给定的圆心点的数组,在多个path上进行圆的描绘

@param radius 圆的半径
@param centerPointValueArrayBlock 提供圆心数组的block
*/
- (void)strokeCirclesRadius:(CGFloat)radius centerPointValueArrayBlock:(NSArray <NSValue *> * (^)(void))centerPointValueArrayBlock;

/**
 在一个特殊的设置下绘制,绘制结束后,恢复到之前的设置
 
 @param specialStateBlock 特殊绘制上下文的block
 */
- (void)drawInSpecialState:(void (^)(CGContextRef context))specialStateBlock;

/**
 将富文本绘制到指定的点上
 
 @param attributedString 富文本
 @param point 绘制的点
 @param offsetX 偏移量x
 @param offsetY 偏移量y
 */
- (void)drawAttributeString:(NSAttributedString *)attributedString atPoint:(CGPoint)point offsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY;

/**
 将富文本绘制到指定的点上,并相对指定的点,进行偏移
 
 @param attributedString 富文本
 @param point 绘制的点
 @param centerAlignment 偏移方向
 @param offsetX 偏移量x
 @param offsetY 偏移量y
 */
- (void)drawAttributeString:(NSAttributedString *)attributedString
                    atPoint:(CGPoint)point centerAlignment:(EDrawContentCenterAlignmentPosition)centerAlignment
                    offsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY;

/**
 将富文本绘制到指定的区域
 
 @param attributedString 富文本
 @param rect 绘制区域
 */
- (void)drawAttributeString:(NSAttributedString *)attributedString inRect:(CGRect)rect;

/**
 绘制图片

 @param image 要绘制的image
 @param point 绘制的点
 @param offsetX 偏移量x
 @param offsetY 偏移量y
 */
- (void)drawImage:(UIImage *)image atPoint:(CGPoint)point offsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY;

/**
 将image绘制到指定的点上,并相对指定的点,进行偏移

 @param image 要绘制的image
 @param point 绘制的点
 @param blendMode blendMode
 @param alpha alpha description
 @param offsetX 偏移量x
 @param offsetY 偏移量y
 */
- (void)drawImage:(UIImage *)image atPoint:(CGPoint)point blendMode:(CGBlendMode)blendMode
            alpha:(CGFloat)alpha offsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY;

/**
 在rect内绘制image

 @param image 要绘制的image
 @param rect 绘制区域
 */
- (void)drawImage:(UIImage *)image inRect:(CGRect)rect;

/**
 在rect内绘制image并设置alpha和blendMode

 @param image 要绘制的image
 @param rect rect description
 @param blendMode blendMode description
 @param alpha alpha description
 */
- (void)drawImage:(UIImage *)image inRect:(CGRect)rect blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;

/**
 在rect内平铺绘制image

 @param image 要绘制的image
 @param rect rect description
 */
- (void)drawImage:(UIImage *)image asPatternInRect:(CGRect)rect;
/**
 是否使用抗锯齿(对于画线条时候的虚线有效)
 
 @param shouldAntialias 是否开启抗锯齿
 */
- (void)shouldAntialias:(BOOL)shouldAntialias;

@end
