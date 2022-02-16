//
//  PZThemeManager.h
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/2/7.
//

#import <Foundation/Foundation.h>
#import "PZThemeMacro.h"
@class PZTheme;

NS_ASSUME_NONNULL_BEGIN

@interface PZThemeManager : NSObject
@property(nonatomic, readonly) PZThemeId pz_theme;

-(void) pz_setDefaultTheme:(PZThemeId) pz_theme;
+(instancetype) sharedManager;
-(void) pz_changeToTheme:(PZThemeId) pz_theme;
@end

NS_ASSUME_NONNULL_END
