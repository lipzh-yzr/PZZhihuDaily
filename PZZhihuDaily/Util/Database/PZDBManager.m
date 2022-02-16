//
//  PZDBManager.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/26.
//

#import "PZDBManager.h"
#import "PZMainPageModel.h"
#import <FMDB.h>
#import "NSObject+YYModel.h"

#define DB_NAME @"PZDatabase.db"
#define SQL_NAME @"PZDBCreate.sql"

@interface PZDBManager ()
@property(nonatomic) FMDatabaseQueue *queue;
@end

@implementation PZDBManager

+(instancetype) sharedManager {
    static PZDBManager *dbManager = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        dbManager = [[PZDBManager alloc] init];
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        dbManager.queue = [[FMDatabaseQueue alloc] initWithPath:[path stringByAppendingPathComponent:DB_NAME]];
        
        [dbManager createTabel];
        
    });
    return dbManager;
}

-(NSArray<PZStoryModel *> *) loadNews {
    NSString *sql = @"select title, hint, type, newsId from News where 1 LIMIT 20;";
    NSArray *res = [self executeWith:sql];
    NSMutableArray *stories = [@[] mutableCopy];
    [res enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [stories addObject:[PZStoryModel yy_modelWithJSON:obj]];
    }];
    return [stories copy];
}

-(void) updateNewsWith:(NSArray<PZStoryModel *> *) news {
    NSString *sql = @"INSERT OR REPLACE INTO News (title, hint, type, newsId) VALUES (?, ?, ?, ?);";
    NSString *deleteSql = @"DELETE FROM NEWS WHERE 1;";
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:deleteSql];
    }];
    for (PZStoryModel *storyModel in news) {
        [_queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
            if ([db executeUpdate:sql, storyModel.title, storyModel.hint, storyModel.type, storyModel.newsId]) {
                NSLog(@"insert succeed");
            } else {
                NSLog(@"insert failed");
                *rollback = YES;
            }
        }];
    }
}

#pragma mark - private

-(NSArray<NSDictionary *> *) executeWith:(NSString *) sql {
    NSMutableArray<NSDictionary *> *result = [@[] mutableCopy];
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
            FMResultSet *set = [db executeQuery:sql];
            while ([set next]) {
                [result addObject:[set resultDictionary]];
            }
    }];
    return result;
}

-(void) createTabel {
    NSString *path = [[NSBundle mainBundle] pathForResource:SQL_NAME ofType:nil];
    NSString *sql = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
            if ([db executeStatements:sql]) {
                NSLog(@"created");
            } else {
                NSLog(@"create failed");
            }
    }];
}

@end
