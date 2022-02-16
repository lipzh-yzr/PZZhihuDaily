//
//  PZCommentTableHeaderView.h
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/2/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PZCommentTableHeaderView : UITableViewHeaderFooterView

-(void) configNum:(NSInteger) num isLongComment:(BOOL) isLong;
@end

NS_ASSUME_NONNULL_END
