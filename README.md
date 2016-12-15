# HKRoundCell
快速实现UITableViewCell的圆角效果

在UITableView的回调方法中加入hk_roundCellWithTableView:forRowAtIndexPath:即可实现UITableViewCell的圆角

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //只需要在此调用圆角显示方法
    [cell hk_roundCellWithTableView:tableView forRowAtIndexPath:indexPath];
}

在实现Cell圆角的同时，将系统自带的左滑删除也添加了圆角效果。
