//
//  UIScrollView+PullRefresh.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/2/4.
//

#import "UIScrollView+PullRefresh.h"
#import "PZRefreshHelper.h"
#import "Masonry.h"
#import "PZRefreshHeaderControl.h"
#import "PZRefreshFooter.h"
#import <objc/runtime.h>

@interface UIScrollView ()
@property(nonatomic) PZRefreshHelper *refreshHelper;
@end

static const char *refreshHelperKey = "refreshHelperKey";
static const char *refreshControlKey = "refreshControlKey";
static const char *refreshFooterKey = "refreshFooterKey";
#define CIRCLE_WIDTH 30

@implementation UIScrollView (PZRefreshControl)

//- (void)setRefreshHelper:(PZRefreshHelper *)refreshHelper {
//
//    objc_setAssociatedObject(self, refreshHelperKey, refreshHelper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//
//}

- (PZRefreshHelper *)refreshHelper {
    PZRefreshHelper *refreshHelper = objc_getAssociatedObject(self, refreshHelperKey);
    if (refreshHelper) {
        return refreshHelper;
    }
    refreshHelper = [[PZRefreshHelper alloc] init];
    objc_setAssociatedObject(self, refreshHelperKey, refreshHelper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return refreshHelper;
}

- (void)setPz_refreshControl:(PZRefreshHeaderControl *)pz_refreshControl {
    if (pz_refreshControl != self.pz_refreshControl) {
        // 删除旧的，添加新的
        [self.refreshControl removeFromSuperview];
        
        if (pz_refreshControl) {
            
//            [self addSubview:pz_refreshControl];
//            [pz_refreshControl mas_makeConstraints:^(MASConstraintMaker *make) {
//                            make.centerX.offset(0);
//                            make.centerY.equalTo(self.mas_top).offset(-15);
//            }];
            [self.refreshHelper setScrollView:self andRefreshControl:pz_refreshControl];
        }
        // 存储新的
        objc_setAssociatedObject(self, refreshControlKey,
                                 pz_refreshControl, OBJC_ASSOCIATION_RETAIN);
    }
}

- (PZRefreshHeaderControl *)pz_refreshControl {
    return objc_getAssociatedObject(self, refreshControlKey);
}

#pragma mark - footer

- (void)setPz_refreshFooter:(PZRefreshFooter *)pz_refreshFooter {
    if (pz_refreshFooter != self.pz_refreshFooter) {
        // 删除旧的，添加新的
        [self.pz_refreshFooter removeFromSuperview];
        
        if (pz_refreshFooter) {
            [self insertSubview:pz_refreshFooter atIndex:0];
            [pz_refreshFooter setHidden:YES];
        }
        // 存储新的
        objc_setAssociatedObject(self, refreshFooterKey,
                                 pz_refreshFooter, OBJC_ASSOCIATION_RETAIN);
    }
}

- (PZRefreshFooter *)pz_refreshFooter {
    return objc_getAssociatedObject(self, refreshFooterKey);
}

- (void)setMj_offsetX:(CGFloat)mj_offsetX
{
    CGPoint offset = self.contentOffset;
    offset.x = mj_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)mj_offsetX
{
    return self.contentOffset.x;
}

- (void)setMj_offsetY:(CGFloat)mj_offsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = mj_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)mj_offsetY
{
    return self.contentOffset.y;
}

- (void)setMj_contentW:(CGFloat)mj_contentW
{
    CGSize size = self.contentSize;
    size.width = mj_contentW;
    self.contentSize = size;
}

- (CGFloat)mj_contentW
{
    return self.contentSize.width;
}

- (void)setMj_contentH:(CGFloat)mj_contentH
{
    CGSize size = self.contentSize;
    size.height = mj_contentH;
    self.contentSize = size;
}

- (CGFloat)mj_contentH
{
    return self.contentSize.height;
}

@end
