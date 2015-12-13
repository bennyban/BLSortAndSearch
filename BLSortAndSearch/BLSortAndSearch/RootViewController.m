//
//  RootViewController.m
//  BLSortAndSearch
//
//  Created by 班磊 on 15/12/11.
//  Copyright © 2015年 bennyban. All rights reserved.
//

#import "RootViewController.h"
#import "BLSortAndSearchController.h"

@interface RootViewController ()

@property (nonatomic, strong) UIButton *btnSelected;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"排序和搜索列表";
    [self initView];
}

- (void)initView
{
    _btnSelected = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSelected.backgroundColor = [UIColor grayColor];
    _btnSelected.frame = CGRectMake(100, 100, ScreenWidth - 200, ScreenWidth - 200);
    [_btnSelected setTitle:@"品牌\n不限" forState:UIControlStateNormal];
    _btnSelected.titleLabel.numberOfLines = 0;
    [_btnSelected addTarget:self action:@selector(doActionToSelect) forControlEvents:UIControlEventTouchUpInside];
    _btnSelected.layer.cornerRadius = 3.0;
    _btnSelected.layer.masksToBounds = YES;
    _btnSelected.layer.borderColor = [UIColor cyanColor].CGColor;
    _btnSelected.layer.borderWidth = 1.0f;
    [self.view addSubview:_btnSelected];
}

- (void)doActionToSelect
{
    __weak typeof(self) weakSelf = self;
    BLSortAndSearchController *selectCtrl = [[BLSortAndSearchController alloc] init];
    selectCtrl.sortTapAction = ^ (BLBrandModel *brandModel){
        [weakSelf updateSelectedBrand:brandModel];
    };
    UINavigationController         *navCtrl = [[UINavigationController alloc] initWithRootViewController:selectCtrl];
    [self presentViewController:navCtrl animated:YES completion:nil];
}

- (void)updateSelectedBrand:(BLBrandModel *)brandModel
{
    [_btnSelected setTitle:brandModel.brand_name forState:UIControlStateNormal];
}

@end
