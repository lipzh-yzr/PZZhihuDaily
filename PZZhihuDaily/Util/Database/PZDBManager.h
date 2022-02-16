//
//  PZDBManager.h
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class PZStoryModel;

@interface PZDBManager : NSObject

+(instancetype) sharedManager;
-(NSArray<PZStoryModel *> *) loadNews;
-(void) updateNewsWith:(NSArray<PZStoryModel *> *) news;

@end

NS_ASSUME_NONNULL_END
