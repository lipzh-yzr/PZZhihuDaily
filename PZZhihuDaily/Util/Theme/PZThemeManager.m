//
//  PZThemeManager.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/2/7.
//

#import "PZThemeManager.h"

@interface PZThemeManager ()
@property(nonatomic, readwrite) PZThemeId pz_theme;
@end

@implementation PZThemeManager
+(instancetype) sharedManager {
    static PZThemeManager *themeManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        themeManager = [[PZThemeManager alloc] init];
    });
    
    return themeManager;
}
-(void) pz_changeToTheme:(PZThemeId) pz_theme {
    self.pz_theme = pz_theme;
    [[NSNotificationCenter defaultCenter] postNotificationName:PZThemeChangeNotification object:nil];
    [[NSUserDefaults standardUserDefaults] setObject:pz_theme forKey:PZThemeKey];
}

-(void) pz_setDefaultTheme:(PZThemeId) pz_theme {
    self.pz_theme = pz_theme;
}
@end
