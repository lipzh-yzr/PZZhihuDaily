//
//  PZCommentTableViewCell.h
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/30.
//

#import <UIKit/UIKit.h>
@class PZCommentModel;
@class PZCommentTableViewCell;
//typedef void(^PZCommentCellBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@protocol PZCommentTableViewCellDelegate <NSObject>
@optional
-(void) didClickLikeButton:(UIButton *) button;
-(void) didClickCommentButton:(UIButton *) button;
@required
-(void) didClickUnfoldReplyLabelForCell:(PZCommentTableViewCell *) cell;

@end

@interface PZCommentTableViewCell : UITableViewCell
//@property(nonatomic) PZCommentCellBlock likeBlock;
//@property(nonatomic) PZCommentCellBlock replyBlock;
//@property(nonatomic) PZFoldClickBlock foldClickBlock;
@property(nonatomic,weak) id<PZCommentTableViewCellDelegate> delegate;

-(void) configWithCommentModel:(PZCommentModel *) commentModel should:(BOOL) isUnfolded withCellWidth:(CGFloat) width;
-(void) handleFoldLabelWith:(BOOL) isUnfolded;

@end

NS_ASSUME_NONNULL_END
