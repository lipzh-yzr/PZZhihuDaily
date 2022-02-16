//
//  PZCommentModel.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/25.
//

#import "PZCommentModel.h"

@implementation PZReplyModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
        @"replyId":@"id"
    };
}

@end

@implementation PZCommentModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
        @"commentId":@"id"
    };
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"reply_to":[PZReplyModel class]
    };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    self.date = [NSDate dateWithTimeIntervalSince1970:[(NSString *)dic[@"time"] doubleValue]];
    return YES;
}

@end
