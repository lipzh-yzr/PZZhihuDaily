//
//  PZAccessoryButton.h
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PZButtonAccessoryPosition) {
    PZButtonAccessoryPositionTopLeft,
    PZButtonAccessoryPositionTopRight,
    PZButtonAccessoryPositionBotLeft,
    PZButtonAccessoryPositionBotRight
};

@interface PZAccessoryButton : UIButton
@property(nonatomic) NSInteger num;

-(void) configWithImageSize:(CGSize) size;
-(void) configWithAccesoryNumber:(NSInteger) num position:(PZButtonAccessoryPosition) pos imageSize:(CGSize) size fontSize:(CGFloat) fontSize;

@end

NS_ASSUME_NONNULL_END
