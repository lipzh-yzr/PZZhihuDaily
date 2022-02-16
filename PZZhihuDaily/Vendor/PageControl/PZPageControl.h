//
//  PZPageControl.h
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/28.
//

#import <UIKit/UIKit.h>
#import "CWCarousel.h"

@interface PZPageControl : UIView <CWCarouselPageControlProtocol>

@property (nonatomic, assign) NSInteger pageNumbers;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIColor *otherDotColor;
@property (nonatomic, strong) UIColor *currentDotColor;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat currentDotWidth;
@property (nonatomic, assign) CGFloat otherDotWidth;
@property (nonatomic, assign) CGFloat dotHeight;
@property (nonatomic, assign) CGFloat spacing;

@end
