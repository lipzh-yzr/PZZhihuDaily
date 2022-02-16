//
//  PZExtraModel.h
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PZExtraModel : NSObject

@property (nonatomic, copy) NSString *long_comments;
@property (nonatomic, copy) NSString *popularity;
@property (nonatomic, copy) NSString *short_comments;
@property (nonatomic, copy) NSString *comments;
@property(nonatomic) BOOL isStared;

@end

NS_ASSUME_NONNULL_END
