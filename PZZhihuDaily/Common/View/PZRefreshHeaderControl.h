//
//  PZRefreshControl.h
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/2/4.
//

#import <UIKit/UIKit.h>

#define PZREFRESH_ROTATE_SUCCESS @"PZRefreshRotateSuccess"
#define PZREFRESH_ROTATE_FAIL @"PZRefreshRotateFail"

NS_ASSUME_NONNULL_BEGIN

@interface PZRefreshHeaderControl : UIView

+(instancetype) refreshControlWithTarget:(id) target action:(SEL) sel;

@end

NS_ASSUME_NONNULL_END
