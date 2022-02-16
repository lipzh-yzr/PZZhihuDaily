//
//  PZFavTableViewCell.h
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/2/6.
//

#import <UIKit/UIKit.h>
@class PZFavoriteModel;

NS_ASSUME_NONNULL_BEGIN

@interface PZFavTableViewCell : UITableViewCell

-(void) configWithFavModel:(PZFavoriteModel *) favModel;
@end

NS_ASSUME_NONNULL_END
