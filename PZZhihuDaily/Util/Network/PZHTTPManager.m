//
//  PZHTTPManager.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/25.
//

#import "PZHTTPManager.h"
#import "PZMainPageModel.h"
#import "PZExtraModel.h"
#import "PZCommentModel.h"
#import "PZFavoriteModel.h"
#import "NSObject+YYModel.h"

#define BASEURL @"http://news-at.zhihu.com/"

@implementation PZHTTPManager


+(instancetype) defaultManager {
    static PZHTTPManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PZHTTPManager alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
    });
    return manager;
}

-(void) getLatestStoriesWithSuccess:(StoriesSucceedBlock) successBlock error:(ErrorBlock) errorBlock {
    [self GET:@"api/4/news/latest" parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            PZMainPageModel *mainModel = [PZMainPageModel yy_modelWithJSON:responseObject];
            successBlock(mainModel);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            errorBlock(error);
        }];
}

-(void) getBeforeStoriesWithDate:(NSString *) date Success:(StoriesSucceedBlock) successBlock error:(ErrorBlock) errorBlock {
    [self GET:[NSString stringWithFormat:@"api/4/news/before/%@", date] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            PZMainPageModel *mainModel = [PZMainPageModel yy_modelWithJSON:responseObject];
            successBlock(mainModel);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            errorBlock(error);
        }];
}
-(void) getLongCommentsWithStory:(NSString *) story Success:(SucceedCommentsBlock) successBlock error:(ErrorBlock) errorBlock {
    
    [self GET:[NSString stringWithFormat:@"api/4/story/%@/long-comments", story] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray * commentModels = [@[] mutableCopy];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            for (id dict in (NSArray *)responseObject[@"comments"]) {
    
                PZCommentModel *longCommentModel = [PZCommentModel yy_modelWithJSON:dict];
                [commentModels addObject:longCommentModel];
            }
            successBlock(commentModels);
        }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            errorBlock(error);
        }];
}
-(void) getShortCommentsWithStory:(NSString *) story Success:(SucceedCommentsBlock) successBlock error:(ErrorBlock) errorBlock {
    [self GET:[NSString stringWithFormat:@"api/4/story/%@/short-comments", story] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray * commentModels = [@[] mutableCopy];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            for (id dict in (NSArray *)responseObject[@"comments"]) {
    
                PZCommentModel *shortCommentModel = [PZCommentModel yy_modelWithJSON:dict];
                [commentModels addObject:shortCommentModel];
            }
            successBlock(commentModels);
        }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            errorBlock(error);
        }];
}
-(void) getExtraWithStory:(NSString *) story Success:(SucceedExtraBlock) successBlock error:(ErrorBlock) errorBlock {
    
    [self GET:[NSString stringWithFormat:@"api/4/story-extra/%@", story] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            PZExtraModel *extraModel = [PZExtraModel yy_modelWithJSON:responseObject];
            successBlock(extraModel);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            errorBlock(error);
        }];
}
-(void) getFavoriteWithStory:(NSString *) story Success:(SucceedFavoriteBlock) successBlock error:(ErrorBlock) errorBlock {
    [self GET:[NSString stringWithFormat:@"api/4/news/%@", story] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            PZFavoriteModel *favoriteModel = [PZFavoriteModel yy_modelWithJSON:responseObject];
            successBlock(favoriteModel);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            errorBlock(error);
        }];
}


@end
