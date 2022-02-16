//
//  PZCommentTableHeaderView.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/2/1.
//

#import "PZCommentTableHeaderView.h"
#import "Masonry.h"

@interface PZCommentTableHeaderView ()
@property(nonatomic) UILabel *commentNumLabel;
@end

@implementation PZCommentTableHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        _commentNumLabel = [[UILabel alloc] init];
        _commentNumLabel.font = [UIFont boldSystemFontOfSize:20];
        _commentNumLabel.textColor = [UIColor labelColor];
        _commentNumLabel.numberOfLines = 1;
        [self.contentView addSubview:_commentNumLabel];
        
        [_commentNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.centerY.offset(0);
            make.leading.offset(15);
        }];
    }
    return self;
}

-(void) configNum:(NSInteger) num isLongComment:(BOOL) isLong {
    if (isLong) {
        _commentNumLabel.text = [NSString stringWithFormat:@"%ld 条长评",num];
    } else {
        _commentNumLabel.text = [NSString stringWithFormat:@"%ld 条短评",num];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
