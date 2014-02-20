//
//  SKECMAttahController.m
//  NewZhongYan
//
//  Created by lilin on 13-11-21.
//  Copyright (c) 2013年 surekam. All rights reserved.
//
#import "SKECMAttahController.h"
#import "SKViewController.h"
#import "SKAttachManger.h"
#import "UIImageView+Addition.h"
#import "GTMNSString+HTML.h"
#import "NSString+HTML.h"

#import "DDXML.h"
#import "Element.h"
#import "Content.h"
#import "SKECMDetail.h"
#import "SKAttachButton.h"

@interface SKECMAttahController ()
{
    NSMutableArray* attachmentItem;
    SKAttachManger *AM;//附件管理
    CGFloat height;
    NSMutableArray* h;
}
@end

@implementation SKECMAttahController

-(void)viewDidLayoutSubviews
{
    if (IS_IPHONE_5) {
        if (!_isSearch) {
            [_bgscrollview setFrame:CGRectMake(0, 0, 320, 504)];
        }
    }
}
-(NSMutableArray*) analysisXmlElement:(DDXMLElement *) element
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:[element childCount]];
    for (DDXMLElement* eleContent in [element children] ) {
        Content *content = [[Content alloc] init];
        DDXMLNode *idatta = [eleContent attributeForName:@"id"];
        if (idatta != nil) {
            content.idatta = [idatta stringValue];
        }
        DDXMLNode *name = [eleContent attributeForName:@"name"];
        if (name != nil) {
            content.name = [name stringValue];
        }
        DDXMLNode *type = [eleContent attributeForName:@"type"];
        if (type != nil) {
            content.type = [type stringValue];
        }
        content.value = [eleContent stringValue];
        [array addObject:content];
    }
    return array;
}

-(void) analysisXml:(NSString *) contentPath
{
    NSData *data=[NSData dataWithContentsOfFile:contentPath];
    NSString* xml = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",xml);
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:data options:0 error:0];
    _detail = [[SKECMDetail alloc] init];

    DDXMLElement  *head= (DDXMLElement*)[[doc nodesForXPath:@"//head" error:nil] objectAtIndex:0];
    DDXMLElement  *title= (DDXMLElement*)[[head nodesForXPath:@"//title" error:nil] objectAtIndex:0];
        _detail.title = [title stringValue];
    
    DDXMLElement  *author= (DDXMLElement*)[[head nodesForXPath:@"//author" error:nil] objectAtIndex:0];
    _detail.author = [author stringValue];

    DDXMLElement  *time = (DDXMLElement*)[[head nodesForXPath:@"//time" error:nil] objectAtIndex:0];
    _detail.time = [time stringValue];

    DDXMLElement  *body= (DDXMLElement*)[[doc nodesForXPath:@"//body" error:nil] objectAtIndex:0];
    _detail.body = [self analysisXmlElement:body];

    DDXMLElement  *attachment= (DDXMLElement*)[[doc nodesForXPath:@"//attachment" error:nil] objectAtIndex:0];
    _detail.attachment = [self analysisXmlElement:attachment];

    DDXMLElement  *inscribe= (DDXMLElement*)[[doc nodesForXPath:@"//inscribe" error:nil] objectAtIndex:0];
    _detail.inscribe = [self analysisXmlElement:inscribe];
 
    DDXMLElement  *addition= (DDXMLElement*)[[doc nodesForXPath:@"//addition" error:nil] objectAtIndex:0];
    _detail.addition = [self analysisXmlElement:addition];
}

-(void)loadContent
{
    NSString* contentPath = [AM ecmContentPathWithOwnerApp:self.channel.OWNERAPP];
    NSURL*    contentUrl =  [NSURL URLWithString:@"http://10.159.30.88/aaa-agents/xml/ECMDetail.xml"];
    contentUrl = [NSURL URLWithString:_news[@"URL"]];
    if ([AM ecmContentExistedWithOwnerApp:self.channel.OWNERAPP])
    {
        [self analysisXml:contentPath];
        [self createAttachView];
        return;
    }
    SKHTTPRequest* Request = [[SKHTTPRequest alloc] initWithURL:contentUrl];
    __weak SKHTTPRequest* contentRequest = Request;
    [contentRequest setDownloadDestinationPath:contentPath];
    [contentRequest setCompletionBlock:^{
        if ([contentRequest responseStatusCode] != 200) {
            [ASIHTTPRequest removeFileAtPath:contentPath error:0];
        }else{
            [self analysisXml:contentPath];
            [self createAttachView];
        }
    }];
    [contentRequest setFailedBlock:^{
        [ASIHTTPRequest removeFileAtPath:contentPath error:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [BWStatusBarOverlay showMessage:[NetUtils userInfoWhenRequestOccurError:contentRequest.error] duration:1 animated:1];
        });
    }];
    [Request startAsynchronous];
}

-(void)initData
{
    AM = [[SKAttachManger alloc] initWithECMInfo:_news];
    AM.doctype = SKECMInfo;
    height = 100;
    h = [NSMutableArray array];
}

-(void)createAttachView
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 40)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:19];
    _titleLabel.numberOfLines = 0;
    _titleLabel.text = _detail.title;
    [_titleLabel sizeToFit];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [_titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    
    [_bgscrollview addSubview:_titleLabel];

    _authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLabel.frame), 150, 20)];
    _authorLabel.font = [UIFont systemFontOfSize:14];
    _authorLabel.text = [NSString stringWithFormat:@"作者 : %@",_detail.author];
    _authorLabel.textColor = [UIColor lightGrayColor];
    [_bgscrollview addSubview:_authorLabel];

    _crtmLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, CGRectGetMaxY(_titleLabel.frame), 150, 20)];
    _crtmLabel.font = [UIFont systemFontOfSize:14];
    _crtmLabel.textAlignment = UITextAlignmentRight;
    _crtmLabel.text = _detail.time;
    _crtmLabel.textColor = [UIColor lightGrayColor];
    [_crtmLabel setBackgroundColor:[UIColor clearColor]];
    [_bgscrollview addSubview:_crtmLabel];
    
    UIImageView* DividingLines = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_line.png"]];
    [DividingLines setFrame:CGRectMake(10, CGRectGetMaxY(_crtmLabel.frame), 300, 2)];
    [_bgscrollview addSubview:DividingLines];
    _curHeight = CGRectGetMaxY(DividingLines.frame);

    for (Content *content in _detail.body) {
        [self showContent:content];
    }
    
    for (Content *content in _detail.attachment) {
        [self showContent:content];
    }

    for (Content *content in _detail.inscribe) {
        [self showContent:content];
    }
    
    for (Content *content in _detail.addition) {
        [self showContent:content];
    }
    
    [_bgscrollview setContentSize:CGSizeMake(320, [self scrollViewContentHeight])];
}



-(CGFloat)scrollViewContentHeight

{
    CGFloat maxheight = 0;
    for (UIView* view in _bgscrollview.subviews) {
        maxheight = MAX(maxheight, CGRectGetMaxY(view.frame));
    }
    return maxheight;
}

-(void) addText:(Content *) content{
    
    //    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, _curHeight, 300, 1)];
    
    //    webView.delegate = self;
    
    //    webView.dataDetectorTypes = UIDataDetectorTypeNone;
    
    //    UIScrollView* webScrollView =  (UIScrollView*)[[webView subviews] objectAtIndex:0];
    
    //    [webScrollView setScrollEnabled:NO];
    
    //    [_bgscrollview addSubview:webView];
    
    //    [webView loadHTMLString:content.value baseURL:0];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, _curHeight, 300, 1)];
    [label setText:content.value];
    [label setNumberOfLines:0];
    [label setTextColor:[UIColor lightGrayColor]];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setTextAlignment:NSTextAlignmentRight];
    [label setTextAlignment:NSTextAlignmentRight];
    [label sizeToFit];
    [_bgscrollview addSubview:label];
    CGRect rect = label.frame;
    rect.size.width = 300;
    [label setFrame:rect];
    _curHeight = CGRectGetMaxY(label.frame);
}

-(void) addImage:(Content *) content{
    EGOImageView *imageView = [[EGOImageView alloc] initWithFrame:CGRectMake(20, _curHeight, 280, 200)];
    NSString* urlstring = [[content.value gtm_stringByEscapingForHTML] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [imageView setPlaceholderImage:Image(@"reload")];
    [imageView setImageURL:[NSURL URLWithString:urlstring]];
    [imageView setCaption:_detail.title];
    [imageView addDetailShow];
    [_bgscrollview addSubview:imageView];
    _curHeight += 202;
}

-(void) addHtml:(Content *) content{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, _curHeight, 300,1)];
    webView.delegate = self;
    webView.dataDetectorTypes = UIDataDetectorTypeNone;
    [(UIScrollView*)[[webView subviews] objectAtIndex:0] setScrollEnabled:NO];
    [_bgscrollview addSubview:webView];
    NSString *webviewText = @"<style>body{margin:0;background-color:#clear;font:16px/24px Custom-Font-Name}</style>";
    NSString *htmlString = [webviewText stringByAppendingFormat:@"%@",content.value];
    [webView loadHTMLString:htmlString baseURL:Nil];
    UIPinchGestureRecognizer* pinchRecognizer= [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [webView addGestureRecognizer:pinchRecognizer];
};

-(void) addAttachement:(Content *) content{
    NSString* btnTitle = content.name;
    SKAttachButton* attachmentButton = [[SKAttachButton alloc] initWithFrame:CGRectMake(10,_curHeight, 300, 48)];
    attachmentButton.filePath = [AM ecmAttachmentPathWithOwnerApp:self.channel.OWNERAPP AttachName:content.name];
    attachmentButton.attachUrl = [NSURL URLWithString:content.value];
    attachmentButton.isAttachExisted = [AM fileExisted:attachmentButton.filePath];
    [attachmentButton setTitle:btnTitle forState:UIControlStateNormal];
    [_bgscrollview addSubview:attachmentButton];
    _curHeight =  CGRectGetMaxY(attachmentButton.frame);//48 button 的高度
}

-(void)addMark:(Content *) content
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, _curHeight, 300, 30)];
    UIImageView* imgview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 25, 25)];
    imgview.image = Image(@"check.png");
    [view addSubview:imgview];

    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 40, 25)];
    [label setText:content.name];
    [view addSubview:label];
    [_bgscrollview addSubview:view];
    _curHeight = CGRectGetMaxY(label.frame);
}

-(void) showContent:(Content *) content{
    //[content show];
    if (content.type == nil) {
        [self addText:content];
    }
    else if ([content.type rangeOfString:@"application/"].location != NSNotFound) {
        [self addAttachement:content];
    }
    //如果是图像
    else if([content.type isEqualToString:@"image"])
    {
        [self addImage:content];
    }
    //如果是html
    else if ([content.type isEqualToString:@"text/html"])
    {
        [self addHtml:content];
    }
    //如果是文字
    else if ([content.type isEqualToString:@"text/plain"])
    {
        [self addText:content];
    }//如果是文字
    else if ([content.type isEqualToString:@"mark"])
    {
        [self addMark:content];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self loadContent];
}

- (void)webViewDidFinishLoad:(UIWebView *) webView
{
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    CGRect newFrame = webView.frame;
    CGFloat diff = actualSize.height - newFrame.size.height;
    newFrame.size.height = actualSize.height;
    webView.frame = newFrame;
    for (UIView* view in _bgscrollview.subviews) {
        if (view.frame.origin.y > webView.frame.origin.y) {
            CGRect rect = view.frame;
            if (rect.origin.y > webView.frame.origin.y) {
                rect.origin.y += diff;
                view.frame = rect;
            }
        }
    }
    [_bgscrollview setContentSize:CGSizeMake(320, [self scrollViewContentHeight])];
}

-(void)handlePinch:(UIPinchGestureRecognizer*)pinchRecognizer
{
    UIWebView* web = (UIWebView*)pinchRecognizer.view;
    if (pinchRecognizer.state == UIGestureRecognizerStateBegan) {
        if (pinchRecognizer.velocity > 0) {
            height +=5;
            height =   height > 150 ? 150 :height;
        }else{
            height -=5;
            height =   height < 100 ? 100 :height;
            NSString* newframestring = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.height= '%f%%'",height];
            [web stringByEvaluatingJavaScriptFromString:newframestring];
        }
        NSString* newframestring = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'",height];
        [web stringByEvaluatingJavaScriptFromString:newframestring];
        CGRect newFrame = web.frame;
        CGFloat actualheight = [[web stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] floatValue];
        CGFloat diff = actualheight - web.frame.size.height;
        newFrame.size.height = actualheight;
        web.frame = newFrame;
        for (UIView* view in _bgscrollview.subviews) {
            if (view.frame.origin.y > web.frame.origin.y) {
                CGRect rect = view.frame;
                if (rect.origin.y > web.frame.origin.y) {
                    rect.origin.y += diff;
                    view.frame = rect;
                }
            }
        }
        _bgscrollview.contentSize = CGSizeMake(320,[self scrollViewContentHeight]);
    }
}

@end

