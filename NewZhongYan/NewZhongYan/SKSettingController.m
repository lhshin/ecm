//
//  SKSettingController.m
//  NewZhongYan
//
//  Created by lilin on 14-3-20.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKSettingController.h"
#import "SKAppConfiguration.h"
#import "SKNewMailController.h"
@implementation SKSettingController
-(void)viewDidLoad
{
    [self.view setBackgroundColor:COLOR(239, 239, 239)];
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
    [view setBackgroundColor:COLOR(239, 239, 239)];
    [self.tableView setTableFooterView:view];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 320, 21)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@"湖南中烟工业有限公司 版权所有"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:COLOR(194, 194, 194)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [view  addSubview:titleLabel];
    
    UILabel* subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(titleLabel.frame) + 2, 320, 21)];
    [subTitleLabel setBackgroundColor:[UIColor clearColor]];
    [subTitleLabel setText:@"copyright 2011-2014 All Rights Reserved"];
    [subTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [subTitleLabel setTextColor:COLOR(194, 194, 194)];
    [subTitleLabel setFont:[UIFont systemFontOfSize:14]];
    [view  addSubview:subTitleLabel];
    
    [self clearsSelectionOnViewWillAppear];
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return 0.00001;
    }
    return 15.0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(void)deselect
{
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSelector:@selector(deselect) withObject:0 afterDelay:1];
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                [_rootController performSegueWithIdentifier:@"userinfo" sender:0];
                break;
            }
            case 1:
            {
                [_rootController performSegueWithIdentifier:@"secret" sender:0];
                break;
            }
            case 2:
            {
                SKAppConfiguration *configure=[[SKAppConfiguration alloc] init];
                [[APPUtils visibleViewController].navigationController pushViewController:configure animated:YES];
                break;
            }
            case 3:
            {
                 [_rootController performSegueWithIdentifier:@"Maintain" sender:0];
                break;
            }
            case 4:
            {
                [UIAlertView showAlertString:@"该功能即将完善..."];
//                NSURL* appInstallUrl =  [NSURL URLWithString:[NSString stringWithFormat:@"http://tam.hngytobacco.com/d"]];
//                [[UIApplication sharedApplication] openURL:appInstallUrl];
                break;
            }
            default:
                break;
        }
    }else if(indexPath.section == 2){
        SKNewMailController* aEmail = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"SKNewMailController"];
        SKToken* token = [[SKToken alloc] initWithTitle:@"产品经理"
                                      representedObject:@"liuyang@hngytobacco.com"];
        [aEmail.toTokenField addToken:token];
        [aEmail setStatus:NewMailStatusWrite];
        [[APPUtils visibleViewController].navigationController pushViewController:aEmail animated:YES];
    }
}
@end