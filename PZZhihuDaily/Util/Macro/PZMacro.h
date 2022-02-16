//
//  PZMacro.h
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/27.
//

#import <Foundation/Foundation.h>

#import "PZMainPageModel.h"
#import "PZCommentModel.h"
#import "PZExtraModel.h"
#import "PZFavoriteModel.h"
#import "PZDBManager.h"
#import "PZHTTPManager.h"

#import "Masonry.h"
#import "SDWebImage.h"
#import "PZScreen.h"
#import "UIScrollView+PullRefresh.h"
#import "PZRefreshHeaderControl.h"
#import "PZThemeHeaders.h"

#define CELLKEY(CLASS) (NSStringFromClass(CLASS.class))

#define WEAK_SELF weakSelf
#define WEAKIFY(SELF) __weak typeof(self) WEAK_SELF = SELF;

#define MID_X(VIEW) CGRectGetMidX(VIEW.bounds)
#define MID_Y(VIEW) CGRectGetMidY(VIEW.bounds)
