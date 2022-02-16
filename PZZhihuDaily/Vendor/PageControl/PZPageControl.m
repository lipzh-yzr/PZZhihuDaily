//
//  WOPageControl.m
//  WOPageControl-OC
//
//  Created by wayone on 2020/2/10.
//  Copyright © 2020 aaa. All rights reserved.
//

#import "PZPageControl.h"
#import "PZMacro.h"

@interface PZPageControl ()

@property (nonatomic, strong) NSMutableArray<UIView *> *dotViewArrayM;
@property (nonatomic, strong) NSMutableArray<MASViewConstraint *> *widthConstraints;
@property (nonatomic, assign) BOOL isInitialize;
//@property (nonatomic, assign) BOOL inAnimating;
@property(nonatomic) CGFloat totalWidth;
@property(nonatomic) UIView *bgView;
@end

@implementation PZPageControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.otherDotColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        self.currentDotColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        self.currentPage = 0;
        self.isInitialize = YES;
//        self.inAnimating = NO;
        self.dotViewArrayM = [NSMutableArray array];
//        [self setUpDots];
        self.clipsToBounds = NO;
    }
    return self;
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    [self updateUI];
//
//}

- (void)setUpDots {
    
    if (self.isInitialize) {
        self.isInitialize = NO;
        _totalWidth = self.currentDotWidth + (self.pageNumbers - 1) * (self.spacing + self.otherDotWidth);
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _totalWidth, self.frame.size.height)];
        _bgView.center = CGPointMake(MID_X(self), MID_Y(self));
        [self addSubview:_bgView];
        
        for (int i = 0; i < self.pageNumbers; i++) {
            UIView *dotView = [[UIView alloc] initWithFrame:CGRectZero];
            dotView.layer.cornerRadius = self.cornerRadius;
            [_bgView addSubview:dotView];
            [self.dotViewArrayM addObject:dotView];
            
            // 更新位置
            CGFloat width = (i == self.currentPage ? self.currentDotWidth : self.otherDotWidth);
            CGFloat height = self.dotHeight;
//            CGFloat x = currentX;
//            CGFloat y = (self.frame.size.height - height) / 2;
//            dotView.frame = CGRectMake(x, y, width, height);
//
//            currentX = currentX + width + self.spacing; // 走到下一个点开的开头位置
            
            if (i == 0) {
                
                [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
                    MASViewConstraint *widthConstraint = (MASViewConstraint *) make.width.mas_equalTo(width);
                    make.height.mas_equalTo(height);
                    [self.widthConstraints addObject:widthConstraint];
                    
                    make.left.offset(self.spacing);
                    make.centerY.offset(0);
                }];
            } else {
                UIView *preDotView = _dotViewArrayM[i-1];
                [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
                    MASViewConstraint *widthConstraint = (MASViewConstraint *) make.width.mas_equalTo(width);
                    make.height.mas_equalTo(height);
                    [self.widthConstraints addObject:widthConstraint];
                    
                    make.leading.equalTo(preDotView.mas_trailing).offset(self.spacing);
                    make.centerY.offset(0);
                }];
            }
            
            // 更新颜色
            dotView.backgroundColor = self.otherDotColor;
            if (i == self.currentPage) {
                dotView.backgroundColor = self.currentDotColor;
            }
        }
    }
}

//- (CGSize)intrinsicContentSize {
//    return CGSizeMake(_totalWidth + 10 * 2, _dotHeight + 10 * 2);
//}

#pragma mark - ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ Setter ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬

- (void)setPageNumbers:(NSInteger)pageNumbers {
    
    _pageNumbers = pageNumbers;
    [self setUpDots];
//    if (self.dotViewArrayM.count > 0) {
//        [self.dotViewArrayM enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
//         {
//             [(UIView *)obj removeFromSuperview];
//         }];
//        [self.dotViewArrayM removeAllObjects];
//    }
//
//    for (int i = 0; i < pageNumbers; i++) {
//
//    }
//
//    self.isInitialize = YES;
//    [self setNeedsLayout];
}

- (void)setCurrentPage:(NSInteger)currentPage {
    if (currentPage > _pageNumbers) {
        
    }
    
    NSInteger oldPage = _currentPage;
    if (_dotViewArrayM.count > 0) {
        UIView *preView = _dotViewArrayM[oldPage];
        preView.backgroundColor = _otherDotColor;
        [preView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(self.otherDotWidth);
        }];
        
        UIView *currView = _dotViewArrayM[currentPage];
        currView.backgroundColor = _currentDotColor;
        [currView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(self.currentDotWidth);
        }];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [self layoutIfNeeded];
                } completion:^(BOOL finished) {
                    
                }];
    }
    
    _currentPage = currentPage;
}

@end
