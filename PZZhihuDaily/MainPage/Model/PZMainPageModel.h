//
//  PZMainPageModel.h
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/25.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface PZStoryModel : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *hint;
@property (nonatomic, copy) NSString *ga_prefix;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *image_hue;
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *newsId;
@property(nonatomic) CGFloat height;
@end

//@interface PZTopStoryModel : NSObject
//@property (nonatomic, copy) NSString *url;
//@property (nonatomic, copy) NSString *title;
//@property (nonatomic, copy) NSString *hint;
//@property (nonatomic, copy) NSString *ga_prefix;
//@property (nonatomic, copy) NSString *type;
//@property (nonatomic, copy) NSString *image_hue;
//@property (nonatomic, copy) NSString *image;
//@property (nonatomic, copy) NSString *newsId;
//@end

@interface PZMainPageModel : NSObject

@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSArray<PZStoryModel *> *stories;
@property (nonatomic, copy) NSArray<PZStoryModel *> *top_stories;
@property(nonatomic) NSDate *formattedDate;
@property(nonatomic) NSString *dateStr;

@end

NS_ASSUME_NONNULL_END
