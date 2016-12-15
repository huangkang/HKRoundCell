//
//  UITableViewCell+HKRound.m
//  HKRoundCell
//
//  Created by 黄康 on 16/12/15.
//  Copyright © 2016年 黄康. All rights reserved.
//

#import "UITableViewCell+HKRound.h"
#import <objc/runtime.h>

@implementation UITableViewCell (HKRound)

@dynamic hk_position;
@dynamic hk_rect;
@dynamic hk_horizontalMargins;
@dynamic hk_verticalMargins;
@dynamic hk_cornerRadius;
@dynamic hk_color;
@dynamic hk_selectedColor;
@dynamic hk_multipleSelectionColor;

CGFloat const kHKHorizontalMargins = 4.f;
CGFloat const kHKVerticalMargins   = 0.3f;
CGFloat const kHKCornerRadius      = 8.f;

NSInteger const kHKColor = 0xFFFFFF;
NSInteger const kHKSelectedColor = 0xC9C9C9;
NSInteger const kHKMultipleSelectionColor = 0xBBFFFF;

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

//打印
#ifdef DEBUG
#define HKLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);

#else
#define HKLog(s, ...)
#endif

//#define kHKColor = [UIColor whiteColor];
//#define kHKSelectedColor = [UIColor lightGrayColor];
//#define kHKMultipleSelectionColor = [UIColor lightGrayColor];

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        method_exchangeImplementations(class_getInstanceMethod(class,@selector(layoutSubviews)), class_getInstanceMethod(class,@selector(hk_layoutSubviews)));
    });
}


- (void)hk_layoutSubviews{
    [self hk_layoutSubviews];
    for (UIView *subview in self.subviews){
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"])
        {
            if(self.hk_cornerRadius>0){
                [subview.layer setCornerRadius:self.hk_cornerRadius];
            }
            if(self.hk_horizontalMargins){
                [subview setBounds:CGRectMake(CGRectGetMinX(subview.bounds), CGRectGetMinY(subview.bounds), CGRectGetWidth(subview.bounds) - self.hk_horizontalMargins, CGRectGetHeight(subview.bounds))];
            }
        }
    }
}

-(void)hk_roundCellWithTableView:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hk_roundCellWithTableView:tableView forRowAtIndexPath:indexPath andHorizontalMargins:kHKHorizontalMargins andVerticalMargins:kHKVerticalMargins andCornerRadius:kHKCornerRadius andColor:UIColorFromRGB(kHKColor) andSelectedColor:UIColorFromRGB(kHKSelectedColor) andMultipleSelection:UIColorFromRGB(kHKMultipleSelectionColor)];
}

-(void)hk_roundCellWithTableView:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath andHorizontalMargins:(CGFloat)horizontalMargins andVerticalMargins:(CGFloat)verticalMargins andCornerRadius:(CGFloat)cornerRadius{
    [self hk_roundCellWithTableView:tableView forRowAtIndexPath:indexPath andHorizontalMargins:horizontalMargins andVerticalMargins:verticalMargins andCornerRadius:cornerRadius andColor:UIColorFromRGB(kHKColor) andSelectedColor:UIColorFromRGB(kHKSelectedColor) andMultipleSelection:UIColorFromRGB(kHKMultipleSelectionColor)];
}

-(void)hk_roundCellWithTableView:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath andColor:(UIColor *)color andSelectedColor:(UIColor *)selectedColor andMultipleSelection:(UIColor *)multipleSelectionColor{
    [self hk_roundCellWithTableView:tableView forRowAtIndexPath:indexPath andHorizontalMargins:kHKHorizontalMargins andVerticalMargins:kHKVerticalMargins andCornerRadius:kHKCornerRadius andColor:color andSelectedColor:selectedColor andMultipleSelection:multipleSelectionColor];
}

-(void)hk_roundCellWithTableView:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath andHorizontalMargins:(CGFloat)horizontalMargins andVerticalMargins:(CGFloat)verticalMargins andCornerRadius:(CGFloat)cornerRadius andColor:(UIColor *)color andSelectedColor:(UIColor *)selectedColor andMultipleSelection:(UIColor *)multipleSelectionColor{
    UITableViewCellHKPosition position = [self hk_positionWithTableView:tableView forRowAtIndexPath:indexPath];
    
    if(self.hk_position == position&&CGRectEqualToRect(self.hk_rect, self.bounds)){
        //位置与大小无变化
        HKLog(@"位置与尺寸未发生变化");
        if(self.hk_horizontalMargins== horizontalMargins&&self.hk_verticalMargins==verticalMargins&&self.hk_cornerRadius == cornerRadius){
            //边距与圆弧无变化
            HKLog(@"边距与圆弧未发生变化");
            if([self compareRGBAColor1:self.hk_color withColor2:color]&&[self compareRGBAColor1:self.hk_selectedColor withColor2:selectedColor]&&[self compareRGBAColor1:self.hk_multipleSelectionColor withColor2:multipleSelectionColor]){
                //颜色无变化
                HKLog(@"颜色未发生变化");
                return;
            }
        }
    }
    
    [self setHk_position:position];
    [self setHk_rect:self.bounds];
    [self setHk_horizontalMargins:horizontalMargins];
    [self setHk_verticalMargins:verticalMargins];
    [self setHk_cornerRadius:cornerRadius];
    [self setHk_color:color];
    [self setHk_selectedColor:selectedColor];
    [self setHk_multipleSelectionColor:multipleSelectionColor];
    
    self.backgroundColor = UIColor.clearColor;
    //圆角层
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    //选中背景层
    CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init];
    //多选背景层
    CAShapeLayer *multipleSelectionBackgroundLayer = [[CAShapeLayer alloc] init];
    CGRect bounds = CGRectMake(CGRectGetMinX(self.bounds) + horizontalMargins, CGRectGetMinY(self.bounds) + verticalMargins, CGRectGetWidth(self.bounds) - 2*horizontalMargins, CGRectGetHeight(self.bounds) - 2*verticalMargins);
    UIBezierPath *bezierPath;
    if(position==UITableViewCellHKPositionTop){
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    }else if(position==UITableViewCellHKPositionMiddle){
        bezierPath = [UIBezierPath bezierPathWithRect:bounds];
    }else if(position==UITableViewCellHKPositionBottom){
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    }else{
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    }
    
    layer.path = bezierPath.CGPath;
    backgroundLayer.path = bezierPath.CGPath;
    multipleSelectionBackgroundLayer.path = bezierPath.CGPath;
    [bezierPath closePath];
    layer.fillColor = [UIColor whiteColor].CGColor;
    
    //圆角视图
    UIView *roundView = [[UIView alloc] initWithFrame:self.bounds];
    //设置在最底部
    [roundView.layer insertSublayer:layer atIndex:0];
    roundView.backgroundColor = UIColor.clearColor;
    self.backgroundView = roundView;
    
    //选中背景视图 也设置成了圆角
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    backgroundLayer.fillColor = [UIColor lightGrayColor].CGColor;
    [selectedBackgroundView.layer insertSublayer:backgroundLayer atIndex:0];
    selectedBackgroundView.backgroundColor = UIColor.clearColor;
    self.selectedBackgroundView = selectedBackgroundView;
    
    //多选背景视图
    UIView *multipleSelectionBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    multipleSelectionBackgroundLayer.fillColor = [UIColor lightGrayColor].CGColor;
    [multipleSelectionBackgroundView.layer insertSublayer:multipleSelectionBackgroundLayer atIndex:0];
    multipleSelectionBackgroundView.backgroundColor = UIColor.clearColor;
    self.multipleSelectionBackgroundView = multipleSelectionBackgroundView;
    
}



- (UITableViewCellHKPosition) hk_positionWithTableView:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断在第几行
    //总行数
    NSInteger rows = [tableView numberOfRowsInSection:indexPath.section];
    if (indexPath.row == 0){
        //顶部或者全部
        if (indexPath.row == rows-1){
            return UITableViewCellHKPositionAll;
        }else{
            return UITableViewCellHKPositionTop;
        }
    }else{
        //中间或者底部
        if (indexPath.row == rows-1){
            return UITableViewCellHKPositionBottom;
        }else{
            return UITableViewCellHKPositionMiddle;
        }
    }
}


#pragma mark - set get 方法
static char HKRectKey;//类似于一个中转站,参考
- (void) setHk_rect:(CGRect)hk_rect{
    objc_setAssociatedObject(self, &HKRectKey, NSStringFromCGRect(hk_rect), OBJC_ASSOCIATION_COPY);
}

- (CGRect) hk_rect{
    id str = objc_getAssociatedObject(self, &HKRectKey);
    if(str){
        return CGRectFromString(str);
    }else{
        return CGRectZero;
    }
}

static char HKPositionKey;
- (void) setHk_position:(UITableViewCellHKPosition)hk_position{
    objc_setAssociatedObject(self, &HKPositionKey, [NSNumber numberWithInteger:hk_position], OBJC_ASSOCIATION_COPY);
}

- (UITableViewCellHKPosition) hk_position {
    return [objc_getAssociatedObject(self, &HKPositionKey) integerValue];
}

static char HKHorizontalMarginsKey;
- (void) setHk_horizontalMargins:(CGFloat)hk_horizontalMargins{
    objc_setAssociatedObject(self, &HKHorizontalMarginsKey, [NSNumber numberWithFloat:hk_horizontalMargins], OBJC_ASSOCIATION_COPY);
}

- (CGFloat) hk_horizontalMargins {
    return [objc_getAssociatedObject(self, &HKHorizontalMarginsKey) floatValue];
}

static char HKVerticalMarginsKey;
- (void) setHk_verticalMargins:(CGFloat)hk_verticalMargins{
    objc_setAssociatedObject(self, &HKVerticalMarginsKey, [NSNumber numberWithFloat:hk_verticalMargins], OBJC_ASSOCIATION_COPY);
}

- (CGFloat) hk_verticalMargins {
    return [objc_getAssociatedObject(self, &HKVerticalMarginsKey) floatValue];
}



static char HKCornerRadiusKey;
- (void) setHk_cornerRadius:(CGFloat)hk_cornerRadius{
    objc_setAssociatedObject(self, &HKCornerRadiusKey, [NSNumber numberWithFloat:hk_cornerRadius], OBJC_ASSOCIATION_COPY);
}

- (CGFloat) hk_cornerRadius {
    return [objc_getAssociatedObject(self, &HKCornerRadiusKey) floatValue];
}


static char HKColorKey;
- (void) setHk_color:(UIColor *)hk_color{
    objc_setAssociatedObject(self, &HKColorKey, hk_color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *) hk_color{
    return objc_getAssociatedObject(self, &HKColorKey);
}


static char HKSelectedColorKey;
- (void) setHk_selectedColor:(UIColor *)hk_selectedColor{
    objc_setAssociatedObject(self, &HKSelectedColorKey, hk_selectedColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *) hk_selectedColor{
    return objc_getAssociatedObject(self, &HKSelectedColorKey);
}



static char HKMultipleSelectionColorKey;
- (void) setHk_multipleSelectionColor:(UIColor *)hk_multipleSelectionColor{
    objc_setAssociatedObject(self, &HKMultipleSelectionColorKey, hk_multipleSelectionColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *) hk_multipleSelectionColor{
    return objc_getAssociatedObject(self, &HKMultipleSelectionColorKey);
}


- (BOOL)compareRGBAColor1:(UIColor *)color1 withColor2:(UIColor *)color2 {
    
    CGFloat red1,red2,green1,green2,blue1,blue2,alpha1,alpha2;
    //取出color1的背景颜色的RGBA值
    [color1 getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    //取出color2的背景颜色的RGBA值
    [color2 getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    
    if ((red1 == red2)&&(green1 == green2)&&(blue1 == blue2)&&(alpha1 == alpha2)) {
        return YES;
    } else {
        HKLog(@"第1个颜色:%f %f %f %f",red1,green1,blue1,alpha1);
        HKLog(@"第2个颜色:%f %f %f %f",red2,green2,blue2,alpha2);
        return NO;
    }
}
@end
