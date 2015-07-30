//
//  MoreViewController.m
//  XinRanApp
//
//  Created by tianbo on 14-12-5.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreDetailViewController.h"

@interface MoreViewController ()<UIActionSheetDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- uitableview delegate mothed
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  5;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UIImageView *imageView;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        //CGRect rt = CGRectInset(cell.bounds, 5, 3);
        imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imageView.image = [UIImage imageNamed:@"cell_backImage"];
        [cell.contentView addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(5);
            make.top.equalTo(5);
            make.bottom.equalTo(-5);
            
            make.right.equalTo(cell).offset(-5);
        }];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    
    if (indexPath.row==0) {
        cell.textLabel.text = @"支付方式";
    }
    else if (indexPath.row==1) {
        cell.textLabel.text = @"配送方式";
    }
    else if (indexPath.row==2) {
        cell.textLabel.text = @"正品保障";
    }
    else if (indexPath.row==3) {
        cell.textLabel.text = @"退换货政策";
    }
    else if (indexPath.row==4) {
        cell.textLabel.text = @"关于我们";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    UIViewController *mdvc1 = [[self storyboard] instantiateViewControllerWithIdentifier:@"MoreDetailViewController"];
    MoreDetailViewController *mdvc = (MoreDetailViewController *)mdvc1;
    if (indexPath.row==0) {
        mdvc.type = MoreDetailViewType_PayMethod;
    }
    else if (indexPath.row==1) {
        mdvc.type = MoreDetailViewType_DistributionMethod;
    }
    else if (indexPath.row==2) {
        mdvc.type = MoreDetailViewType_AuthenticGuarantee;
    }
    else if (indexPath.row==3) {
        mdvc.type = MoreDetailViewType_ReturnGoods;
    }
    else if (indexPath.row==4) {
        mdvc.type = MoreDetailViewType_AboutUs;
    }
    
    [self.navigationController pushViewController:mdvc1 animated:YES];
    
}


#pragma mark- http request handler
-(void)httpRequestFinished:(NSNotification *)notification
{
    
}

-(void)httpRequestFailed:(NSNotification *)notification
{
    
}

@end
