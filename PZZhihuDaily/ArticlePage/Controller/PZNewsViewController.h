//
//  PZNewsViewController.h
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/29.
//

#import <UIKit/UIKit.h>
@class PZStoryModel;

NS_ASSUME_NONNULL_BEGIN

@interface PZNewsViewController : UIViewController

-(instancetype) initWithStoryModel:(PZStoryModel *) storyModel;

@end

NS_ASSUME_NONNULL_END
