//
//  PZMainPageHeaderView.h
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/28.
//

#import <UIKit/UIKit.h>
typedef void(^ClickAvatarBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface PZMainPageHeaderView : UIView
@property(nonatomic) ClickAvatarBlock avatarBlock;
-(void) configWithDate:(NSString *) date;

@end

NS_ASSUME_NONNULL_END
