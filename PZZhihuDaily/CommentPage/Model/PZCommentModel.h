//
//  PZCommentModel.h
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/25.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
#import <CoreGraphics/CGBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface PZReplyModel : NSObject
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) long status;
@property (nonatomic, copy) NSString *replyId;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *error_msg;
@end

@interface PZCommentModel : NSObject <YYModel>
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *commentId;
@property (nonatomic, copy) NSString *likes;
@property (nonatomic) PZReplyModel *reply_to;
@property(nonatomic) NSDate *date;
@property(nonatomic) CGFloat foldHeight;
@property(nonatomic) CGFloat unfoldHeight;
@end

NS_ASSUME_NONNULL_END
