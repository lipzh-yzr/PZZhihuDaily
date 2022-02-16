//
//  PZTheme.h
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/2/7.
//

#import <UIKit/UIKit.h>
#import "PZThemeMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface PZTheme : NSObject
@property(nonatomic) UIColor *pz_bgColor;
@property(nonatomic) UIColor *pz_textColor;
@property(nonatomic) UIColor *pz_grayTextColor;
@property(nonatomic) UIColor *pz_tintColor;
@property(nonatomic) UIColor *pz_tabBarColor;
@property(nonatomic) UIColor *pz_navBarColor;
@property(nonatomic) PZThemeId pz_themeId;

+(instancetype) pz_themeWithPZThemeId:(PZThemeId) themeId;

@end

NS_ASSUME_NONNULL_END
