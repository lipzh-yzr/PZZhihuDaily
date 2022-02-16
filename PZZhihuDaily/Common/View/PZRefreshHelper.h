//
//  PZRefreshHelper.h
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/2/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class PZRefreshHeaderControl;

@interface PZRefreshHelper : NSObject
@property(nonatomic, weak, readonly) UIScrollView *scrollView;
@property(nonatomic, weak, readonly) PZRefreshHeaderControl *refreshControl;

-(void) setScrollView:(UIScrollView * _Nullable)scrollView andRefreshControl:(PZRefreshHeaderControl *) refreshControl;
@end

NS_ASSUME_NONNULL_END
