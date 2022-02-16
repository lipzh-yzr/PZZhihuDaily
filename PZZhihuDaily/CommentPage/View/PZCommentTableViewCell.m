//
//  PZCommentTableViewCell.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/30.
//

#import "PZCommentTableViewCell.h"
#import "PZMacro.h"
#import "PZAccessoryButton.h"

#define AVATAR_HEIGHT 36
#define AVATAR_INSET 15

@interface PZCommentTableViewCell ()
@property(nonatomic) UIImageView *avatarImage;
@property(nonatomic) UILabel *userNameLabel;
@property(nonatomic) UILabel *commentLabel;
@property(nonatomic) UILabel *replyLabel;
@property(nonatomic) UILabel *timeLabel;
@property(nonatomic) PZAccessoryButton *likeButton;
@property(nonatomic) PZAccessoryButton *replyButton;
@property(nonatomic) UILabel *foldLabel;

+(NSString *) displayStrForTimeLabel:(NSDate *) date;
@end

//static NSString *displayStrForTimeLabel(NSDate *date) {
//
//}

@implementation PZCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _avatarImage = [[UIImageView alloc] init];
        _avatarImage.layer.cornerRadius = AVATAR_HEIGHT/2;
        _avatarImage.clipsToBounds = YES;
        _avatarImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_avatarImage];
        [_avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.height.mas_equalTo(AVATAR_HEIGHT);
                    make.top.leading.offset(AVATAR_INSET);
        }];
        
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.font = [UIFont boldSystemFontOfSize:17];
        _userNameLabel.textColor = [UIColor labelColor];
        [self.contentView addSubview:_userNameLabel];
        [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.equalTo(self.avatarImage).offset(2);
            make.leading.equalTo(self.avatarImage.mas_trailing).offset(10);
        }];
        
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.font = [UIFont systemFontOfSize:17];
        _commentLabel.textColor = [UIColor labelColor];
        _commentLabel.numberOfLines = 0;
        [self.contentView addSubview:_commentLabel];
        [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.equalTo(self.userNameLabel.mas_bottom).offset(3);
            make.leading.equalTo(self.userNameLabel);
            make.trailing.offset(-AVATAR_INSET);
        }];
        
        _replyLabel = [[UILabel alloc] init];
        _replyLabel.font = [UIFont systemFontOfSize:15];
        _replyLabel.textColor = [UIColor grayColor];
        
        [self.contentView addSubview:_replyLabel];
        [_replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.equalTo(self.commentLabel.mas_bottom).offset(3);
            make.leading.trailing.equalTo(self.commentLabel);
            
        }];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.equalTo(self.replyLabel.mas_bottom).offset(10);
            make.leading.equalTo(self.userNameLabel);
            make.bottom.offset(-10);
        }];
        
        _foldLabel = [[UILabel alloc] init];
        _foldLabel.font = [UIFont systemFontOfSize:14];
        _foldLabel.textColor = [UIColor lightGrayColor];
        
        [self.contentView addSubview:_foldLabel];
        [_foldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.equalTo(self.timeLabel);
            make.leading.equalTo(self.timeLabel.mas_trailing).offset(2);
        }];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(foldLabelClicked:)];
        [_foldLabel addGestureRecognizer:tapGesture];
        
        _replyButton = [[PZAccessoryButton alloc] init];
        [_replyButton setImage:[UIImage imageNamed:@"reply"] forState:UIControlStateNormal];
        [self.contentView addSubview:_replyButton];
        [_replyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(22);
            make.trailing.equalTo(self.commentLabel);
            make.centerY.equalTo(self.timeLabel);
        }];
        [_replyButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _likeButton = [[PZAccessoryButton alloc] init];
        [_likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        _likeButton.clipsToBounds = NO;
        [self.contentView addSubview:_likeButton];
        [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    
            make.width.height.mas_equalTo(22);
            
            make.trailing.equalTo(self.replyButton.mas_leading).offset(-30);
            make.centerY.equalTo(self.replyButton);
        }];
        [_likeButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
    
}

-(void) configWithCommentModel:(PZCommentModel *) commentModel should:(BOOL) isUnfolded withCellWidth:(CGFloat) width {
    [_avatarImage sd_setImageWithURL:[NSURL URLWithString:commentModel.avatar]];
    
    _userNameLabel.text = commentModel.author;
    _commentLabel.text = commentModel.content;
    
    [_likeButton configWithAccesoryNumber:commentModel.likes.integerValue position:PZButtonAccessoryPositionTopLeft imageSize:CGSizeMake(22, 22) fontSize:13];
    
    _timeLabel.text = [PZCommentTableViewCell displayStrForTimeLabel:commentModel.date];
    
    if (commentModel.reply_to == nil) {
        _replyLabel.hidden = YES;
    } else {
        _replyLabel.hidden = NO;
        NSString *replyText;
        if (commentModel.reply_to.author == nil || commentModel.reply_to.content == nil) {
            replyText = @"抱歉，原点评已经被删除";
        } else {
            replyText = [NSString stringWithFormat:@"// %@ : %@", commentModel.reply_to.author, commentModel.reply_to.content];
        }
        _replyLabel.text = replyText;
    }
    
    if ([self heightForText:commentModel.reply_to.content withWidth:width - 76 fontSize:15]/_replyLabel.font.lineHeight <= 2) {
        _foldLabel.hidden = YES;
    } else {
        _foldLabel.hidden = NO;
        _foldLabel.userInteractionEnabled = YES;
    }
    [self handleFoldLabelWith:isUnfolded];
}

#pragma mark - private

-(void) buttonClicked:(UIButton *) button {
    if (button == _likeButton) {
        if ([self.delegate respondsToSelector:@selector(didClickLikeButton:)]) {
            [self.delegate didClickLikeButton:button];
        }
    } else if (button == _replyButton) {
        if ([self.delegate respondsToSelector:@selector(didClickCommentButton:)]) {
            [self.delegate didClickCommentButton:button];
        }
    }
}

-(void) foldLabelClicked:(UITapGestureRecognizer *) tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(didClickUnfoldReplyLabelForCell:)]) {
            [self.delegate didClickUnfoldReplyLabelForCell:self];
//            [self setNeedsLayout];
//            [self layoutIfNeeded];
        }
    }
}

-(void) handleFoldLabelWith:(BOOL) isUnfolded {
    if (isUnfolded) {
        _foldLabel.text = @"· 收起";
        _replyLabel.numberOfLines = 0;
    } else {
        _foldLabel.text = @"· 展开全文";
        _replyLabel.numberOfLines = 2;
        _replyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
}

-(NSInteger) heightForText:(NSString *) text withWidth:(CGFloat) width fontSize:(NSInteger) fontSize {
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.height;
}
    

+(NSString *) displayStrForTimeLabel:(NSDate *) date  {
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *todayComponents = [calendar components:unit fromDate:today];
    NSDateComponents *targetDateComponents = [calendar components:unit fromDate:date];
    
    if (todayComponents.year == targetDateComponents.year && todayComponents.month == targetDateComponents.month && todayComponents.day == targetDateComponents.day) {
        return [@"今天 " stringByAppendingString: [[self todayDateFormatter] stringFromDate:date]];
    } else {
        return [[self beforeDateFormatter] stringFromDate:date];
    }
}

+(NSDateFormatter *) todayDateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH':'mm"];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    return dateFormatter;
}

+(NSDateFormatter *) beforeDateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM'-'dd' 'HH':'mm"];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    return dateFormatter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
