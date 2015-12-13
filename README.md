# BLSortAndSearch
排序搜索
搜索排序整理
```
   当没有匹配的结果时，默认会在tableView上显示一个“No Result”的标签，如果说想自定义这个标签，可以在tableview中循环遍历出该标签，然后按照你的想法去设置：
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
[self filterContentForSearchText:searchString];
if ([filteredListPinYin count] == 0) {
UITableView *tableView1 = self.searchDisplayController.searchResultsTableView;
for( UIView *subview in tableView1.subviews ) {
if( [subview class] == [UILabel class] ) {
UILabel *lbl = (UILabel*)subview; // sv changed to subview.
lbl.text = @”没有结果”;
}
}
}
```
当使用UISearchDisplayController之后，你是否发现，当键盘弹出来的时候，会默认把navagationBar给隐藏起来，如果说不需要隐藏navagationBar，最好的处理方式就是重写UISearchDisplayController的-(void)setActive:(BOOL)visible animated:(BOOL)animated方法：

```
#import "CustomSearchDisplayController.h"
 
    @implementation CustomSearchDisplayController
 
    -(void)setActive:(BOOL)visible animated:(BOOL)animated
   {
     [super setActive:visible animated:animated];
     [self.searchContentsController.navigationController setNavigationBarHidden: NO animated: NO];
   }
 
   @end
```
