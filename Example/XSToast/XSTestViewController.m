//
//  MEDViewController.m
//  MEDToast
//
//  Created by shun on 11/10/2022.
//  Copyright (c) 2022 shun. All rights reserved.
//

#import "XSTestViewController.h"
#import <XSToast/XSToastTool.h>

@interface XSTestViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataAry;

@end

@implementation XSTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"cellid" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellid"];
    
    self.dataAry = @[
        @"多实例，互不影响，按顺序依次执行）",
        @"单一实例，如果上一个没结束，会先结束上一个",
        @"自动计算消失时间",
        @"显示单实例loading",
        @"移除单实例loading",
        @"成功",
        @"失败",
        @"设置位置-中间",
        @"设置位置-顶部"
    ];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            NSString *str = [NSString stringWithFormat:@"多实例：%ld",random()];
            [[XSToastTool share] showToast:str second:1];
        }
            break;
        case 1:
        {
            [[XSToastTool share] showSingleToast:self.dataAry[indexPath.row] second:2];
        }
            break;
        case 2:
        {
            [[XSToastTool share] showToast:self.dataAry[indexPath.row]];
        }
            break;
        case 3:
        {
            [[XSToastTool share] showSingleLoading:@"Loading" view:self.view];
        }
            break;
        case 4:
        {
            [[XSToastTool share] removeSingleLoading];
        }
            break;
        case 5:
        {
            [[XSToastTool share] showSuccess:@"yes"];
        }
            break;
        case 6:
        {
            [[XSToastTool share] showError:@"no"];
        }
            break;
        case 7:
        {
            [[XSToastTool share] setGlobalPosition:XSToastPositionCenter];
            [[XSToastTool share] showToast:@"设置成功"];
        }
            break;
        case 8:
        {
            [[XSToastTool share] setGlobalPosition:XSToastPositionTop];
            [[XSToastTool share] showToast:@"设置成功"];
        }
            break;
            
        default:
            break;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell_id" forIndexPath:indexPath];
    cell.textLabel.text = self.dataAry[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


@end
