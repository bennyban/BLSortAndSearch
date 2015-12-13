//
//  BLSortAndSearchController.m
//  BLSortAndSearch
//
//  Created by 班磊 on 15/12/11.
//  Copyright © 2015年 bennyban. All rights reserved.
//

#import "BLSortAndSearchController.h"
#import "BLBrandModel.h"
#import "ChineseToPinyin.h"
#import "CustomSearchDisplayController.h"

@interface BLSortAndSearchController ()<UITableViewDataSource,
UITableViewDelegate,
UISearchBarDelegate,
UISearchDisplayDelegate>
{
    NSInteger           _currentIndex;
    NSMutableDictionary *_headerDict;
}


@property (nonatomic, strong) CustomSearchDisplayController   *searchDisplayController;  /**< 搜索控制器 */
@property (nonatomic, strong) UITableView               *tableView;                /**< 筛选表格 */
@property (nonatomic, strong) UISearchBar               *searchBar;                /**< 搜索条 */
@property (nonatomic, strong) NSMutableArray            *arrSortedDataSource;      /**< 有序的数组 */
@property (nonatomic, strong) NSMutableArray            *arrsearchResultData;      /**< 有序的数组 */
@property (nonatomic, strong) NSString                  *searchText;               /**< 搜索的内容 */

@end

@implementation BLSortAndSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"排序";
    self.view.backgroundColor = [UIColor whiteColor];
    if([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    _searchText = @"";
    [self initDefaultData];
    
    [self initView];
}

- (void)initDefaultData
{
    _arrsearchResultData = [[NSMutableArray alloc] init];
    /**
     * 数据请求之后添加
     */
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CarNameList" ofType:@"json"];
    NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *arrResults = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                          options:NSJSONReadingMutableContainers
                                                            error:nil];
    [self sortDataSourceToBrandWithArray:arrResults];
}

- (void)initView
{
    CGFloat orignX = 0;
    CGFloat orignY = 44;
    CGFloat width  = ScreenWidth;
    CGFloat height = ScreenHeight - StateBarHeight - NavigationBarHeight - orignY;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(orignX, orignY, width, height)
                                              style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索";
    _searchBar.showsScopeBar = YES;
    // 添加 searchbar 到 headerview
    [self.view addSubview:_searchBar];
    
    // 用 searchbar 初始化 SearchDisplayController
    // 并把 searchDisplayController 和当前 controller 关联起来
    _searchDisplayController = [[CustomSearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    // searchResultsDataSource 就是 UITableViewDataSource
    _searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    _searchDisplayController.searchResultsDelegate = self;
    _searchDisplayController.delegate = self;
    _searchDisplayController.searchResultsTableView.sectionIndexBackgroundColor = [UIColor clearColor];
}

#pragma mark -searchbar
#pragma mark
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //如果输入的是字母，判断是否合格
    BOOL isCharacter = [self isValidateLetterOrCharacter:searchBar.text];
    
    _searchText = (isCharacter) ? searchBar.text :[searchBar.text uppercaseString];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
    // 展示搜索框
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView
{
    // 搜索框消失
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(nullable NSString *)searchString
{
    // 搜索框的内容变化，会调用协议方法
    [_arrsearchResultData removeAllObjects];
    
    //如果检索是拼音字母，将会被转换成大写拼音
    searchString = [searchString uppercaseString];
    //去掉特殊情况带上的特殊字符
    searchString = [searchString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    searchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@""];
    searchString = [searchString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    searchString = [searchString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    searchString = [searchString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    for (NSArray *arrSections in _arrSortedDataSource) {
        for (BLBrandModel *model in arrSections) {
            
            //将银行名字转换成大写拼音
            NSString *pinyin = [[ChineseToPinyin pinyinFromChiniseString:model.brand_name] uppercaseString];
            /**
             *  [pinyin rangeOfString:searchPinyin]：根据拼音检索
             *  [model.Name rangeOfString:searchText]：根据汉字检索
             */
            if ([pinyin rangeOfString:searchString].length > 0 || [model.brand_name rangeOfString:searchString].length > 0) {
                [_arrsearchResultData addObject:model];
            }
        }
    }
    
    /*
    if ([_arrsearchResultData count] == 0) {
        UITableView *tableView1 = self.searchDisplayController.searchResultsTableView;
        for( UIView *subview in tableView1.subviews ) {
            if( [subview class] == [UILabel class] ) {
                UILabel *lbl = (UILabel*)subview; // sv changed to subview.
                lbl.text = @"没有结果";
            }
        }
    }
    */
    return YES;
}

#pragma mark - UITableViewDataSource
#pragma mark
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:_tableView]) {
        return _arrSortedDataSource.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_tableView]) {
        NSArray *arrDataSec = _arrSortedDataSource[section];
        return arrDataSec.count;
    }
    return _arrsearchResultData.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor grayColor];
    }
    
    if ([tableView isEqual:_tableView]) {
        NSArray *arrSec = _arrSortedDataSource[indexPath.section];
        if (arrSec.count > 0) {
            BLBrandModel *model = (BLBrandModel *)arrSec[indexPath.row];
            cell.textLabel.text = model.brand_name;
        }
    } else
    {
        if (_arrsearchResultData.count > 0) {
            BLBrandModel *model = (BLBrandModel *)_arrsearchResultData[indexPath.row];
            cell.textLabel.text = model.brand_name;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:_tableView]) {
        if ([_arrSortedDataSource[section] count] && _arrSortedDataSource.count > 0) {
            return 30;
        }
        return 0;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:_searchDisplayController.searchResultsTableView]) {
        return nil;
    }
    
    
    NSArray *datasource = [NSArray arrayWithArray:_arrSortedDataSource];
    
    UIView *header = _headerDict[@(section)];
    if ([datasource[section] count] && datasource.count) {
        if (header == nil) {
            header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
            header.backgroundColor = BGColor;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, header.bounds.size.width-15, header.bounds.size.height)];
            label.text = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
            label.font = [UIFont boldSystemFontOfSize:14];
            label.backgroundColor = BGColor;
            label.tag = 100;
            [header addSubview:label];
            
            [_headerDict setObject:header forKey:@(section)];
        }
        
        for (int i = 0; i < datasource.count; i++) {
            UIView *tabHeader = _headerDict[@(i)];
            UILabel *label = (UILabel *)[tabHeader viewWithTag:100];
            if (_currentIndex == i) {
                label.textColor = [UIColor lightGrayColor];
            }else{
                label.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
            }
        }
        return header;
    }
    return header;
}

//响应点击索引时的委托方法
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (index > 0) {
        index -= 1;
    }
    _currentIndex = index;
    
    [tableView reloadData];
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
            [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([tableView isEqual:_tableView]) {
        NSArray *datasource = ([tableView isEqual:_tableView]) ? [NSArray arrayWithArray:_arrSortedDataSource] : [NSArray arrayWithArray:_arrsearchResultData];
        
        BLBrandModel *brandModel = (BLBrandModel *)datasource[indexPath.section][indexPath.row];
        _sortTapAction ( brandModel );
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        BLBrandModel *brandModel = (BLBrandModel *)_arrsearchResultData[indexPath.row];
        _sortTapAction ( brandModel );
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}

#pragma mark - 排序
#pragma mark
- (void)sortDataSourceToBrandWithArray:(NSArray *)dataArray
{
    NSMutableArray *itemArr = [NSMutableArray array];
    
    NSMutableArray *totalArray = [NSMutableArray array];
    //取出所有数据，封装进model
    for (NSDictionary *dict in dataArray) {
        BLBrandModel *model = [[BLBrandModel alloc] initWithDictionary:dict];
        [totalArray addObject:model];
    }
    
    //索引排序
    UILocalizedIndexedCollation* collation = [UILocalizedIndexedCollation currentCollation];
    for (BLBrandModel* model in totalArray) {
        NSInteger section = [collation sectionForObject:model collationStringSelector:@selector(brand_name)];//获取索引字母所在的分组
        model.section = section;//保存分组index
    }
    
    NSInteger sectionCount = [[collation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:sectionCount];
    //有多少个索引字，创建多少个分组
    for (int i = 0; i <= sectionCount; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:0];
        [sectionArrays addObject:sectionArray];
    }
    
    for (BLBrandModel* model in totalArray) {
        //按索引字母分组，对号入座
        [sectionArrays[model.section] addObject:model];
    }
    
    for (NSArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [collation sortedArrayFromArray:sectionArray collationStringSelector:@selector(brand_name)];
        [itemArr addObject:sortedSection];
    }
    for (int i = 0; i < itemArr.count; i++) {
        NSArray *array = itemArr[i];
        if ([array count]) {
            _currentIndex = i;
            break;
        }
    }
    _arrSortedDataSource = [NSMutableArray arrayWithArray:itemArr];
}

#pragma mark - 判断输入字符还是汉字
#pragma mark
- (BOOL)isValidateLetterOrCharacter:(NSString *)text
{
    if(self){
        for (int i=0; i<text.length; i++) {
            NSRange range=NSMakeRange(i,1);
            NSString *subString=[text substringWithRange:range];
            const char *cString=[subString UTF8String];
            if (strlen(cString)==3)
            {
                NSLog(@"昵称是汉字");
                return 1;
            }else if(strlen(cString)==1)
            {
                NSLog(@"昵称是字母");
                return 0;
            }
        }
    }
    return 0;
}

@end
