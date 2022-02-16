//
//  PZHTTPManager.h
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/25.
//

#import "AFHTTPSessionManager.h"
@class PZExtraModel;
@class PZCommentModel;
@class PZMainPageModel;
@class PZFavoriteModel;

typedef void (^StoriesSucceedBlock)(PZMainPageModel * _Nonnull mainPageModel);
typedef void (^SucceedCommentsBlock)(NSArray<PZCommentModel *> * _Nonnull commentModels);
typedef void (^SucceedFavoriteBlock)(PZFavoriteModel * _Nonnull favoriteModel);
typedef void (^SucceedExtraBlock)(PZExtraModel * _Nonnull extraModel);

typedef void (^ErrorBlock)(NSError * _Nonnull error);

NS_ASSUME_NONNULL_BEGIN

@interface PZHTTPManager : AFHTTPSessionManager

+(instancetype) defaultManager;
-(void) getLatestStoriesWithSuccess:(StoriesSucceedBlock) successBlock error:(ErrorBlock) errorBlock;
-(void) getBeforeStoriesWithDate:(NSString *) date Success:(StoriesSucceedBlock) successBlock error:(ErrorBlock) errorBlock;
-(void) getLongCommentsWithStory:(NSString *) story Success:(SucceedCommentsBlock) successBlock error:(ErrorBlock) errorBlock;
-(void) getShortCommentsWithStory:(NSString *) story Success:(SucceedCommentsBlock) successBlock error:(ErrorBlock) errorBlock;
-(void) getExtraWithStory:(NSString *) story Success:(SucceedExtraBlock) successBlock error:(ErrorBlock) errorBlock;
-(void) getFavoriteWithStory:(NSString *) story Success:(SucceedFavoriteBlock) successBlock error:(ErrorBlock) errorBlock;

@end

NS_ASSUME_NONNULL_END
