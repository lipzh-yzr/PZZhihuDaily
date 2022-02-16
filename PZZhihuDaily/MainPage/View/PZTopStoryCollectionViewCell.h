//
//  PZTopStoryCollectionViewCell.h
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/27.
//

#import <UIKit/UIKit.h>
@class PZStoryModel;

NS_ASSUME_NONNULL_BEGIN

@interface PZTopStoryCollectionViewCell : UICollectionViewCell

-(void) configWithStoryModel:(PZStoryModel *) storyModel;

@end

NS_ASSUME_NONNULL_END
