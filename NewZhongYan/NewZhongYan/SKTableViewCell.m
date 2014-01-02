//
//  SKRootCell.m
//  ZhongYan
//
//  Created by 李 林 on 4/12/13.
//  Copyright (c) 2013 surekam. All rights reserved.
//

#import "SKTableViewCell.h"
#import "utils.h"
@implementation SKTableViewCell
{
      UILabel *_titleLabel;
      UILabel *_crtmLabel;
      UIImageView *_stateView;
      UIImageView *_attachView;
}
//生命周期函数
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFrame:CGRectMake(25, 10, 280, 40)];
        [_titleLabel setFont: [UIFont fontWithName:@"Helvetica" size:16.]];
        [_titleLabel setNumberOfLines:0];
        [_titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [self addSubview:_titleLabel];
        
        _crtmLabel = [[UILabel alloc]init];
        [_crtmLabel setBackgroundColor:[UIColor clearColor]];
        [_crtmLabel setFont:[UIFont systemFontOfSize:12]];
        [_crtmLabel setTextAlignment:NSTextAlignmentRight];
        [_crtmLabel setTextColor:[UIColor lightGrayColor]];
        [self addSubview:_crtmLabel];
        
        _attachView = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"cms_attachment.png"]];
        [self addSubview:_attachView];
        
        _stateView = [[UIImageView alloc]init];
        [self addSubview:_stateView];
    }
    return self;
}

-(void)setCMSTestInfo
{
    _titleLabel.text =  @"公司开展兼职讲师集中备课 卢平对调查问卷进行点评思";
    
    [_crtmLabel setText:@"2013-11-20 16:50"];
    
    [_attachView setHidden:NO];
    [_stateView  setImage:
     [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_unread" ofType:@"png"]]];
    
}

-(void)setECMInfo:(NSDictionary*)info
{
    if ([info.allKeys containsObject:@"TITL"]) {
        _titleLabel.text =  [info objectForKey:@"TITL"];
    }
    
    if ([info.allKeys containsObject:@"CRTM"]) {
        [_crtmLabel setText:[info objectForKey:@"CRTM"]];
    }
    
    [_attachView setHidden:![self containAttachement:info]];
    if (![[info objectForKey:@"READED"] intValue]) {
        [_stateView  setImage:
         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_unread" ofType:@"png"]]];
    }else{
        [_stateView setImage:
         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_read" ofType:@"png"]]];
    }
}

-(void)setCMSInfo:(NSDictionary*)info
{
    if ([info.allKeys containsObject:@"TITL"]) {
        _titleLabel.text =  [info objectForKey:@"TITL"];
    }
    
    if ([info.allKeys containsObject:@"CRTM"]) {
        [_crtmLabel setText:[info objectForKey:@"CRTM"]];
    }
    
    [_attachView setHidden:![self containAttachement:info]];
    if (![[info objectForKey:@"READED"] intValue]) {
        [_stateView  setImage:
         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_unread" ofType:@"png"]]];
    }else{
        [_stateView setImage:
         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_read" ofType:@"png"]]];
    }
}

-(void)dealloc
{

}

-(BOOL)containAttachement:(NSDictionary*)dict
{
    if ([[dict allKeys] containsObject:@"ATTS"]) {
        return  [[[dict objectForKey:@"ATTS"] componentsSeparatedByString:@","] count] > 1;
    }else{
        return NO;
    }
}

-(void)setRemindInfo:(NSDictionary*)remind
{
    NSString* flowInstanceId = [remind objectForKey:@"FLOWINSTANCEID"];
    if ([[remind objectForKey:@"HANDLE"] intValue] == 0
        || [flowInstanceId isEqual:[NSNull null]]//不可处理
        || [flowInstanceId isEqualToString:@"0"]
        || [flowInstanceId isEqualToString:@""]) {
        [_attachView setImage:[UIImage imageNamed:@"undispose"]];
    }else if ([[remind objectForKey:@"HANDLE"] intValue] == 1){//仅阅读
        [_attachView setImage:[UIImage imageNamed:@"list_onlyread"]];
    }else if ([[remind objectForKey:@"HANDLE"] intValue] == 2){//可处理
        [_attachView setImage:[UIImage imageNamed:@"dispose"]];
    }else{
        [_attachView setImage:[UIImage imageNamed:@"undispose"]];
    }
    
    _titleLabel.text = [remind objectForKey:@"TITL"];
    _crtmLabel.text =  [[[remind objectForKey:@"CRTM"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:16];
}

//- (void)layoutSubviews
//{
////    [titleLabel setFrame:CGRectMake(25, 6, 275, 40)];
////    [titleLabel sizeToFit];
////    [stateView setFrame:CGRectMake(5, CGRectGetMidY(titleLabel.frame)-7.5, 15, 15)];
////    [attachView setFrame:CGRectMake(25,CGRectGetMaxY(titleLabel.frame)+5, 30, 15)];
////    [crtmLabel setFrame:CGRectMake(131, CGRectGetMaxY(titleLabel.frame)+2, 169, 21)];
//}

-(void)awakeFromNib
{
}

-(void)resizeTheHeight
{
    [titleLabel setFrame:CGRectMake(25, 6, 275, 40)];
    [titleLabel setBackgroundColor:[UIColor purpleColor]];
    [titleLabel sizeToFit];
    [stateView setFrame:CGRectMake(5, CGRectGetMidY(titleLabel.frame)-7.5, 15, 15)];
    [attachView setFrame:CGRectMake(25,CGRectGetMaxY(titleLabel.frame)+5, 30, 15)];
    [crtmLabel setFrame:CGRectMake(131, CGRectGetMaxY(titleLabel.frame)+2, 169, 21)];
}

-(void)resizeCellHeight
{
    CGFloat contentWidth = 280;
    CGFloat height = [_titleLabel.text sizeWithFont:_titleLabel.font
                                  constrainedToSize:CGSizeMake(contentWidth, 220)
                                      lineBreakMode:NSLineBreakByCharWrapping].height;
    
    [_titleLabel  setFrame:CGRectMake(25, 8, 280, height)];
    [_stateView   setFrame:CGRectMake(5, CGRectGetMidY(_titleLabel.frame) - 7.5, 15, 15)];
    [_attachView  setFrame:CGRectMake(25,CGRectGetMaxY(_titleLabel.frame)+5, 30, 15)];
    [_crtmLabel   setFrame:CGRectMake(205,CGRectGetMaxY(_titleLabel.frame)+5, 100, 21)];
}

//渲染该cell
-(void)setDataDictionary:(NSDictionary*)dictionary
{
    if ([dictionary.allKeys containsObject:@"TITL"]) {
        titleLabel.text =  [dictionary objectForKey:@"TITL"];
    }
    
    if ([dictionary.allKeys containsObject:@"CRTM"]) {
        [crtmLabel setText:[dictionary objectForKey:@"CRTM"]];
    }

    [attachView setHidden:![self containAttachement:dictionary]];
    if (![[dictionary objectForKey:@"READED"] intValue]) {
        [stateView  setImage:
         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_unread" ofType:@"png"]]];
    }else{
        [stateView setImage:
         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_read" ofType:@"png"]]];
    }
}
@end
