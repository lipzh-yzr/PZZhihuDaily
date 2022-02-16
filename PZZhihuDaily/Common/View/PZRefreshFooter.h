//
//  PZRefreshFooter.h
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/2/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PZRefreshFooter : UIView

+(instancetype) pz_refreshFooterWithTarget:(id) target action:(SEL) action;
-(void) endRefreshing;
@end

NS_ASSUME_NONNULL_END
