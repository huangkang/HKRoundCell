//
//  ViewController.m
//  HKRoundCell
//
//  Created by 黄康 on 16/12/15.
//  Copyright © 2016年 黄康. All rights reserved.
//

#import "ViewController.h"
#import "UITableViewCell+HKRound.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //设置背景色
    [self.tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    //取消线条
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.cells = [NSMutableArray array];
    for (int i=0; i<10; i++) {
        NSMutableArray *array = [NSMutableArray array];
        for (int j=0; j<=i; j++) {
            [array addObject:[NSNumber numberWithFloat:50]];
        }
        [self.cells addObject:array];
    }
    [self.tableView setEditing:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cells.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.cells objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell.textLabel setText:[NSString stringWithFormat:@"第%ld行 第%ld列",indexPath.section+1,indexPath.row+1]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //只需要在此调用圆角显示方法
    [cell hk_roundCellWithTableView:tableView forRowAtIndexPath:indexPath];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < 4) {
        return UITableViewCellEditingStyleDelete;
    } else if(indexPath.row==1){
        return UITableViewCellEditingStyleInsert;
    }else{
        return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray *array = _cells[indexPath.section];
    CGFloat height = [array[indexPath.row] floatValue] + 20;
    [array replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithFloat:height]];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = _cells[indexPath.section];
    return [array[indexPath.row] floatValue];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 4;
}

@end
