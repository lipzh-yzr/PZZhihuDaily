//
//  PZFavoriteModel.h
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PZStoryModel;

@interface PZFavoriteModel : NSObject

@property(nonatomic) NSString *newsId;
@property(nonatomic) NSString *title;
@property(nonatomic) NSString *imageUrl;

+(void) dealWithFav:(PZStoryModel *) storyModel;
+(void) addToFav:(PZStoryModel *) storyModel;
+(void) deleteFromFav:(PZStoryModel *) storyModel;
+(BOOL) isInFavList:(PZStoryModel *) storyModel;
+(NSArray<PZFavoriteModel *> *) getAllFavs;
-(PZStoryModel *) toStoryModel;

@end

NS_ASSUME_NONNULL_END
