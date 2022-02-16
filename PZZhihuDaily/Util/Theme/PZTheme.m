//
//  PZTheme.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/2/7.
//

#import "PZTheme.h"

static PZTheme *pz_dayTheme() {
    PZTheme *dayTheme = [[PZTheme alloc] init];
    dayTheme.pz_bgColor = [UIColor whiteColor];
    dayTheme.pz_textColor = [UIColor labelColor];
    dayTheme.pz_grayTextColor = [UIColor lightGrayColor];
    dayTheme.pz_tintColor = [UIColor whiteColor];
    dayTheme.pz_tabBarColor = [UIColor whiteColor];
    dayTheme.pz_navBarColor = [UIColor whiteColor];
    return dayTheme;
};

static PZTheme *pz_nightTheme() {
    PZTheme *nightTheme = [[PZTheme alloc] init];
    nightTheme.pz_bgColor = [UIColor darkGrayColor];
    nightTheme.pz_textColor = [UIColor whiteColor];
    nightTheme.pz_grayTextColor = [UIColor lightGrayColor];
    nightTheme.pz_tintColor = [UIColor darkGrayColor];
    nightTheme.pz_tabBarColor = [UIColor darkGrayColor];
    nightTheme.pz_navBarColor = [UIColor darkGrayColor];
    return nightTheme;
};

@implementation PZTheme
+(instancetype) pz_themeWithPZThemeId:(PZThemeId) themeId {
    if ([themeId isEqualToString: PZThemeDay]) {
        return pz_dayTheme();
    } else if ([themeId isEqualToString: PZThemeNight]) {
        return pz_nightTheme();
    } else {
        return [[PZTheme alloc] init];
    }
}
@end
