//
//  UITableViewCell+HKRound.h
//  HKRoundCell
//
//  Created by 黄康 on 16/12/15.
//  Copyright © 2016年 黄康. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UITableViewCellHKPosition) {
    //顶部
    UITableViewCellHKPositionTop = 1,
    //中间
    UITableViewCellHKPositionMiddle,
    //底部
    UITableViewCellHKPositionBottom,
    //全部
    UITableViewCellHKPositionAll
    
};

@interface UITableViewCell (HKRound)
//横向边距
extern CGFloat const kHKHorizontalMargins;
//纵向边距
extern CGFloat const kHKVerticalMargins;
//圆角弧度
extern CGFloat const kHKCornerRadius;
//背景色
extern NSInteger const kHKColor;
//选中背景色
extern NSInteger const kHKSelectedColor;
//多选背景色
extern NSInteger const kHKMultipleSelectionColor;

/**
 cell所处的位置
 */
@property (nonatomic) UITableViewCellHKPosition hk_position;

/**
 cell的大小
 */
@property (nonatomic) CGRect hk_rect;

@property (nonatomic) CGFloat hk_horizontalMargins;

@property (nonatomic) CGFloat hk_verticalMargins;

@property (nonatomic) CGFloat hk_cornerRadius;

@property (strong, nonatomic) UIColor *hk_color;

@property (strong, nonatomic) UIColor *hk_selectedColor;

@property (strong, nonatomic) UIColor *hk_multipleSelectionColor;
/**
 设置圆角
 
 @param tableView 列表
 @param indexPath 坐标
 */
-(void)hk_roundCellWithTableView:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 设置圆角
 
 @param tableView 列表
 @param indexPath 坐标
 @param horizontalMargins 横向边距
 @param verticalMargins 纵向编剧
 @param cornerRadius 圆弧
 */
-(void)hk_roundCellWithTableView:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath andHorizontalMargins:(CGFloat)horizontalMargins andVerticalMargins:(CGFloat)verticalMargins andCornerRadius:(CGFloat)cornerRadius;

/**
 设置圆角
 
 @param tableView 列表
 @param indexPath 坐标
 @param color 背景色
 @param selectedColor 选中背景色
 @param multipleSelectionColor 多选背景色
 */
-(void)hk_roundCellWithTableView:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath andColor:(UIColor *)color andSelectedColor:(UIColor *)selectedColor andMultipleSelection:(UIColor *)multipleSelectionColor;

/**
 设置圆角
 
 @param tableView 列表
 @param indexPath 坐标
 @param horizontalMargins 横向边距
 @param verticalMargins 纵向编剧
 @param cornerRadius 圆弧
 @param color 背景色
 @param selectedColor 选中背景色
 @param multipleSelectionColor 多选背景色
 */
-(void)hk_roundCellWithTableView:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath andHorizontalMargins:(CGFloat)horizontalMargins andVerticalMargins:(CGFloat)verticalMargins andCornerRadius:(CGFloat)cornerRadius andColor:(UIColor *)color andSelectedColor:(UIColor *)selectedColor andMultipleSelection:(UIColor *)multipleSelectionColor;

@end
