//
//  SKViewController.h
//  NewZhongYan
//
//  Created by lilin on 13-9-28.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDragButton.h"
#import "SKPatternLockController.h"
#import "SKNewsItemController.h"

#import "SMPageControl.h"
@interface SKViewController : UIViewController<UIDragButtonDelegate,drawPatternLockDelegate,SKDataDaemonHelperDelegate>
{
    NSMutableArray *upButtons;
    NSMutableArray* clientAppArray;
    BOOL isFirstLogin;
}

@property(nonatomic,weak)UIScrollView *bgScrollView;
@property(nonatomic,strong)SMPageControl* pageController;
- (void)scrollToPage:(int)page;
@end
