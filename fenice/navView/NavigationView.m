//
//  NavigationView.m
//  fenice
//
//  Created by 魔时网 on 13-12-2.
//  Copyright (c) 2013年 mosh. All rights reserved.
//

#import "NavigationView.h"
#import "GlobalConfig.h"
#import "FontLabel.h"


static CGFloat fontsize = 17;
static CGFloat navHeight = 65;
static CGFloat logoHeight = 34;
const static NSInteger buttonExtendTag = 100;


@implementation NavigationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        [self createView];
    }
    return self;
}


- (void) createView
{
    
    //创建news Collect Store
    [self createFontLabel];
    [self changeLabelColorWithIndex:1];
    
    //创建logo
    [self createLogoView];
    
    
    //创建红线
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, navHeight - 1, SCREENWIDTH, 1)];
    redView.backgroundColor = REDCOLOR;
    [self addSubview:redView];
    
    //创建backVIew
    [self createBackView];
    [self showNavBackButton:NO];
}

#pragma  mark createView

- (void) createFontLabel
{
    _navLabelArray = [NSMutableArray array];
    for (int i = 0;i < 3;i++) {
        FontLabel *label = [self createFontLabelWithFrame:CGRectMake(SCREENWIDTH/3 * i, logoHeight, SCREENWIDTH/3, navHeight - logoHeight) fontName:REQUIREFONTNAME pointSize:fontsize text:@""];
        label.textColor = TEXTGRAYCOLOR;
        [self addSubview:label];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = label.frame;
        button.tag = buttonExtendTag + i;
        [button addTarget:self action:@selector(navButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        [_navLabelArray addObject:label];
    }
}

- (FontLabel *) createFontLabelWithFrame:(CGRect)rect fontName:(NSString *)name pointSize:(CGFloat)size text:(NSString *)text
{
    FontLabel *label = [[FontLabel alloc] initWithFrame:rect fontName:name pointSize:size];
    label.userInteractionEnabled = NO;
    label.backgroundColor = CLEARCOLOR;
    label.text = text;
    label.textColor = WHITECOLOR;
    label.textAlignment = UITextAlignmentCenter;
    
    return label;
}

- (void) createLogoView
{
    UIImageView *image = [GlobalConfig createImageViewWithFrame:CGRectMake((SCREENWIDTH - logoHeight)/2, 0, logoHeight, logoHeight) ImageName:@"logo"];
    [self addSubview:image];
    
    UIButton *button = [GlobalConfig createButtonWithFrame:image.frame ImageName:@"" highLightImage:@"" Title:@"" Target:self Action:@selector(logoClick)];
    [self addSubview:button];
}

- (void) createBackView
{
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, logoHeight, SCREENWIDTH, navHeight - logoHeight - 1)];
    _backView.backgroundColor = CLEARCOLOR;
    [self addSubview:_backView];
    
    UIImageView *image = [GlobalConfig createImageViewWithFrame:CGRectMake(20, (navHeight - logoHeight - 17)/2, 15, 17) ImageName:@"back"];
    [_backView addSubview:image];
    
    UIButton *button = [GlobalConfig createButtonWithFrame:CGRectMake(0, 0, 120, _backView.frame.size.height) ImageName:@"" highLightImage:@"" Title:nil Target:self Action:@selector(backbuttonClick)];
    [_backView addSubview:button];
}

#pragma  mark self.action

- (void) changeLabelColorWithIndex:(NSInteger)index
{
    for (UILabel *label in _navLabelArray) {
        if ([_navLabelArray indexOfObject:label] == index) {
            label.textColor = REDCOLOR;
        }
        else {
            label.textColor = TEXTGRAYCOLOR;
        }
    }
}

- (void) setLabelText:(NSArray *)array
{
    if (_navLabelArray.count == array.count) {
        for (UILabel *label in _navLabelArray) {
            NSInteger i = [_navLabelArray indexOfObject:label];
            label.text = [GlobalConfig convertToString:array[i]];
        }
    }
}

- (void) showNavBackButton:(BOOL)show
{
    _backView.hidden = !show;
    for (UIView *view in _navLabelArray) {
        view.hidden = show;
    }
}

#pragma mark buttonClick

// 点击news Collect Store 调用
- (void) navButtonClick:(UIButton *)button
{
    [self.delegate labelClickWithIndex:(button.tag - buttonExtendTag)];
    //改变label颜色
    [self changeLabelColorWithIndex:(button.tag - buttonExtendTag)];
}

- (void) backbuttonClick
{
    [self.delegate backButtonClick];
}

- (void) logoClick
{
    [self.delegate logoButtonClick];
}

@end
