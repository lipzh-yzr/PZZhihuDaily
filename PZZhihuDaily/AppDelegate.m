//
//  AppDelegate.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/24.
//

#import "AppDelegate.h"
#import "PZMainPageViewController.h"
#import "PZThemeManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    id pzTheme = [[NSUserDefaults standardUserDefaults] objectForKey:PZThemeKey];
    if (pzTheme) {
        [[PZThemeManager sharedManager] pz_setDefaultTheme:(PZThemeId) pzTheme];
    } else {
        
        [[PZThemeManager sharedManager] pz_setDefaultTheme:PZThemeDay];
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    PZMainPageViewController *mainPageVC = [[PZMainPageViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainPageVC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}



@end
