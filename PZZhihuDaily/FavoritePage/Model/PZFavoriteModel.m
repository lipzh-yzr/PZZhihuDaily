//
//  PZFavoriteModel.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/25.
//

#import "PZFavoriteModel.h"
#import "PZMainPageModel.h"

#define FAV_FILNAME @"favs.data"

@interface PZFavoriteModel ()<NSSecureCoding>

@end

static NSString *favFilePath() {
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:FAV_FILNAME];
    return filePath;
}

@implementation PZFavoriteModel

-(PZStoryModel *) toStoryModel {
    PZStoryModel *storyModel = [[PZStoryModel alloc] init];
    storyModel.newsId = self.newsId;
    storyModel.image = self.imageUrl;
    storyModel.title = self.title;
    return storyModel;
}
    
+(void) dealWithFav:(PZStoryModel *) storyModel {
    if ([self isInFavList:storyModel]) {
        [self deleteFromFav:storyModel];
    } else {
        [self addToFav:storyModel];
    }
}
+(void) addToFav:(PZStoryModel *) storyModel {
    NSString *filePath = favFilePath();
    NSData *data = [NSData dataWithContentsOfFile: filePath];
    PZFavoriteModel *favModel = [[self alloc] initWithStoryModel:storyModel];
    NSMutableDictionary *favModels = [NSKeyedUnarchiver unarchivedDictionaryWithKeysOfClass:NSString.class objectsOfClass:[PZFavoriteModel class] fromData:data error:nil].mutableCopy;
    
    if (!favModels || ![favModels count]) {
        favModels = @{}.mutableCopy;
    }
    [favModels setObject:favModel forKey:favModel.newsId];
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:favModels.copy requiringSecureCoding:YES error:nil];
    if([archivedData writeToFile:filePath atomically:YES]) {
        NSLog(@"writeFav success");
    } else {
        NSLog(@"writeFav fail");
    }
}
+(void) deleteFromFav:(PZStoryModel *) storyModel {
    NSString *filePath = favFilePath();
    NSData *data = [NSData dataWithContentsOfFile: filePath];
    PZFavoriteModel *favModel = [[self alloc] initWithStoryModel:storyModel];
    NSMutableDictionary *favModels = [NSKeyedUnarchiver unarchivedDictionaryWithKeysOfClass:NSString.class objectsOfClass:[PZFavoriteModel class] fromData:data error:nil].mutableCopy;
    
    if (!favModels || ![favModels count] || ![favModels objectForKey:favModel.newsId]) {
        return;
    }
    [favModels removeObjectForKey:favModel.newsId];
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:favModels.copy requiringSecureCoding:YES error:nil];
    
    if([archivedData writeToFile:filePath atomically:YES]) {
        NSLog(@"deleteFav success");
    } else {
        NSLog(@"deleteFav fail");
    }
}

+(BOOL) isInFavList:(PZStoryModel *) storyModel {
    NSString *filePath = favFilePath();
    NSData *data = [NSData dataWithContentsOfFile: filePath];
    PZFavoriteModel *favModel = [[self alloc] initWithStoryModel:storyModel];
    NSDictionary *favModels = [NSKeyedUnarchiver unarchivedDictionaryWithKeysOfClass:NSString.class objectsOfClass:[PZFavoriteModel class] fromData:data error:nil];
    return [favModels objectForKey:favModel.newsId] != nil;
}

+(NSArray<PZFavoriteModel *> *) getAllFavs {
    NSString *filePath = favFilePath();
    NSData *data = [NSData dataWithContentsOfFile: filePath];
    
    NSError *err;
    NSDictionary *favModels = [NSKeyedUnarchiver unarchivedDictionaryWithKeysOfClass:NSString.class objectsOfClass:[PZFavoriteModel class] fromData:data error:&err];
    
    if (err) {
        NSLog(@"error: %@",err);
    }
    NSArray *res = [favModels allValues];
    return res;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.newsId = [coder decodeObjectForKey:@"newsId"];
        self.title = [coder decodeObjectForKey:@"title"];
        self.imageUrl = [coder decodeObjectForKey:@"imageUrl"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.newsId forKey:@"newsId"];
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.imageUrl forKey:@"imageUrl"];
}

-(instancetype) initWithStoryModel:(PZStoryModel *) storyModel {
    self = [super init];
    if (self) {
        self.title = storyModel.title;
        self.imageUrl = storyModel.image;
        self.newsId = storyModel.newsId;
    }
    return self;
}

@end
