//
//  UIScrollView+PullRefresh.h
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/2/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PZRefreshHeaderControl;
@class PZRefreshFooter;

@interface UIScrollView (PZRefreshControl)
@property(nonatomic) PZRefreshHeaderControl *pz_refreshControl;
@property(nonatomic) PZRefreshFooter *pz_refreshFooter;

@property (assign, nonatomic) CGFloat mj_offsetX;
@property (assign, nonatomic) CGFloat mj_offsetY;

@property (assign, nonatomic) CGFloat mj_contentW;
@property (assign, nonatomic) CGFloat mj_contentH;

@end

NS_ASSUME_NONNULL_END
