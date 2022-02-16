//
//  UIView+PZTheme.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/2/7.
//

#import "UIView+PZTheme.h"
#import <objc/runtime.h>
#import "PZThemeManager.h"
#import "PZTheme.h"

static const char *PZThemeBlockKey = "pzThemeBlockKey";

@implementation UIView (PZTheme)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (PZSetThemeBlock)pz_themeBlock {
    return objc_getAssociatedObject(self, PZThemeBlockKey);
//    return nil;
}

- (void)pz_setThemeBlock:(PZSetThemeBlock)pz_themeBlock {
    if (pz_themeBlock) {
        
        objc_setAssociatedObject(self, PZThemeBlockKey, pz_themeBlock, OBJC_ASSOCIATION_COPY);
        PZTheme *theme = [PZTheme pz_themeWithPZThemeId:[PZThemeManager sharedManager].pz_theme];
        pz_themeBlock(self, theme);
        __weak typeof(self) weakSelf = self;
        [[NSNotificationCenter defaultCenter] addObserverForName:PZThemeChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            PZTheme *theme = [PZTheme pz_themeWithPZThemeId:[PZThemeManager sharedManager].pz_theme];
            weakSelf.pz_themeBlock(weakSelf, theme);
        }];
        
    }
}

@end
