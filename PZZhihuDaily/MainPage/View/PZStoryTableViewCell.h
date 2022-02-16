//
//  PZStoryTableViewCell.h
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/27.
//

#import <UIKit/UIKit.h>

@class PZStoryModel;
NS_ASSUME_NONNULL_BEGIN

@interface PZStoryTableViewCell : UITableViewCell
@property(nonatomic) UIImageView *coverView;
-(void) configWithStoryModel:(PZStoryModel *) storyModel;
-(void) setImageWithUrl:(NSString *) url;
@end

NS_ASSUME_NONNULL_END
