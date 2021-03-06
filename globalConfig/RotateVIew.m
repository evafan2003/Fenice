//
//  RotateVIew.m
//  mao
//
//  Created by mosh on 13-9-13.
//  Copyright (c) 2013年 com.mosh. All rights reserved.
//

#import "RotateView.h"
#import "GlobalConfig.h"
#import "UIImageView+AFNetworking.h"

static CGFloat pageControlWidth = 100;
static CGFloat pageControlHeight = 20;

@implementation RotateView

- (id) initWithFrame:(CGRect)rect andImageFrame:(CGRect)imageRect andDataArray:(NSArray *)array defaultImage:(NSString *)image pageControl:(BOOL)pageControl
{
    if (self = [super initWithFrame:rect]) {
        self.dataArray = array;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:image]];
        [self createScrollViewWithFrame:imageRect dataArray:array defaultImage:image];
        
        if (pageControl) {
            [self createPageControl];
        }
    }
    return self;
}

//创建scrollView和imageview
- (void) createScrollViewWithFrame:(CGRect)rect dataArray:(NSArray *)array defaultImage:(NSString *)defaultImage
{
    if (!array) {
        return;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.scrollView addGestureRecognizer:tap];
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * array.count, self.frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = CLEARCOLOR;
    self.scrollView.pagingEnabled  = YES;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    if (self.dataArray.count>0) {
        self.backgroundColor = CLEARCOLOR;
    }
    for (int i=0;i<self.dataArray.count;i++) {
        
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake( rect.origin.x + i * (rect.size.width + rect.origin.x * 2), rect.origin.y,rect.size.width, rect.size.height)];
            image.contentMode = UIViewContentModeScaleAspectFit;

        [image setImageWithURL:[NSURL URLWithString:[GlobalConfig convertToString:self.dataArray[i]]] placeholderImage:[UIImage imageNamed:defaultImage]];
            image.contentMode = UIViewContentModeScaleAspectFit;
            image.userInteractionEnabled = YES;
            [self.scrollView addSubview:image];
        }
}

//创建pageControl
- (void) createPageControl
{
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.frame.size.width - pageControlWidth)/2, self.frame.size.height - 20, pageControlWidth, pageControlHeight)];
    self.pageControl.numberOfPages = self.dataArray.count;
    self.pageControl.currentPage = 0;
    self.pageControl.hidesForSinglePage = YES;
    [self addSubview:self.pageControl];
}

////设置page的大小 图片 （自定义pageControl使用）
//- (void) changePageControlWithFrame:(CGRect)rect selectImage:(NSString *)selectImage unSelectImage:(NSString *)unSelectImage
//{
//    if (!CGRectIsNull(rect)) {
//        self.pageControl.frame = rect;
//    }
//    [self.pageControl setImagePageStateNormal:[UIImage imageNamed:unSelectImage]];
//    [self.pageControl setImagePageStateHighlighted:[UIImage imageNamed:selectImage]];
//    self.pageControl.currentPage = 0;
//}

//开启图片自动滚动功能
- (void) startAutoRotate
{
     [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(scrollIndexImage) userInfo:nil repeats:YES];
}

- (void) scrollIndexImage
{
    CGFloat x = self.scrollView.contentOffset.x + self.frame.size.width;
    if (x >= self.frame.size.width * self.dataArray.count) {
        x = 0;
//        self.pageControl.currentPage = 0;
        [self.scrollView scrollRectToVisible:CGRectMake(x, 0,self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:NO];
    }
    [self.scrollView scrollRectToVisible:CGRectMake(x, 0,self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
//    self.pageControl.currentPage = x/(self.frame.size.width);
}

#pragma UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pageControl.currentPage = scrollView.contentOffset.x/(self.frame.size.width);    
}


#pragma  mark showimageViewDelegate -
#pragma UIScrollViewDelegate
//点击轮播图

- (void) tap:(UIGestureRecognizer *)ges
{
    if ([self.delegate respondsToSelector:@selector(rotateViewPressedWith:)]) {
        [self.delegate rotateViewPressedWith:self.scrollView.contentOffset.x/self.frame.size.width];
    }
}

@end
