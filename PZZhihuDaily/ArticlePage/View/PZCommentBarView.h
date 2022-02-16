//
//  PZCommentBarView.h
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/29.
//

#import <UIKit/UIKit.h>
@class PZExtraModel;
typedef void(^PZCommentBarButtonBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface PZCommentBarView : UIView
@property(nonatomic) PZCommentBarButtonBlock backButtonBlock;
@property(nonatomic) PZCommentBarButtonBlock commentButtonBlock;
@property(nonatomic) PZCommentBarButtonBlock likeButtonBlock;
@property(nonatomic) PZCommentBarButtonBlock starButtonBlock;
@property(nonatomic) PZCommentBarButtonBlock shareButtonBlock;

-(instancetype) initWithExtraModel:(PZExtraModel *) extraModel;
@end

NS_ASSUME_NONNULL_END
