//
//  UIView+PZTheme.h
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/2/7.
//

#import <UIKit/UIKit.h>
@class PZTheme;
typedef void(^PZSetThemeBlock)(UIView * _Nullable view, PZTheme * _Nullable theme);

NS_ASSUME_NONNULL_BEGIN

@interface UIView (PZTheme)
@property(nonatomic,setter=pz_setThemeBlock:) PZSetThemeBlock pz_themeBlock;

@end

NS_ASSUME_NONNULL_END
