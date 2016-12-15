# HKRoundCell
快速实现UITableViewCell的圆角效果
在UITableView的回调方法中加入hk_roundCellWithTableView:forRowAtIndexPath:即可实现UITableViewCell的圆角

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //只需要在此调用圆角显示方法
    [cell hk_roundCellWithTableView:tableView forRowAtIndexPath:indexPath];
}
