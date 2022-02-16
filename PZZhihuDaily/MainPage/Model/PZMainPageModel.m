//
//  PZMainPageModel.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/25.
//

#import "PZMainPageModel.h"
#import "NSObject+YYModel.h"

@interface PZStoryModel ()<YYModel>

@end
@implementation PZStoryModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
        @"newsId":@"id"
    };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if (dic[@"images"]) {
        self.image = dic[@"images"][0];
    }
    return YES;
}

@end

//@implementation PZTopStoryModel
//+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
//    return @{
//        @"newsId":@"id"
//    };
//}
//@end

@interface PZMainPageModel ()<YYModel>
@property(nonatomic) NSDateFormatter *dateFormatter;
@property(nonatomic) NSDateFormatter *dateStrFormatter;
@end

@implementation PZMainPageModel



+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"stories":[PZStoryModel class],
        @"top_stories":[PZStoryModel class]
    };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if(dic[@"date"]) {
        NSString *rawDate = dic[@"date"];
        _formattedDate = [self.dateFormatter dateFromString:rawDate];
        _dateStr = [self.dateStrFormatter stringFromDate:_formattedDate];
    }
    return YES;
}

-(NSDateFormatter *) dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
//        [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        _dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
        [_dateFormatter setDateFormat:@"yyyyMMdd"];
    }
    return _dateFormatter;
}

-(NSDateFormatter *) dateStrFormatter {
    if (!_dateStrFormatter) {
        _dateStrFormatter = [[NSDateFormatter alloc] init];
        _dateStrFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
        [_dateStrFormatter setDateFormat:@"MM 月 dd 日"];
    }
    return _dateStrFormatter;
}

@end
