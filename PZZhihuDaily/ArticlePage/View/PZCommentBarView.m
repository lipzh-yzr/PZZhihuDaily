//
//  PZCommentBarView.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/29.
//

#import "PZCommentBarView.h"
#import "PZAccessoryButton.h"
#import "Masonry.h"
#import "PZExtraModel.h"

@interface PZCommentBarView ()
//@property(nonatomic) UISegmentedControl *segmentedControl;
@property(nonatomic) PZAccessoryButton *backButton;
@property(nonatomic) PZAccessoryButton *commentButton;
@property(nonatomic) PZAccessoryButton *likeButton;
@property(nonatomic) PZAccessoryButton *starButton;
@property(nonatomic) PZAccessoryButton *shareButton;
@end

@implementation PZCommentBarView


- (instancetype)initWithExtraModel:(PZExtraModel *)extraModel {
    self = [super init];
    if (self) {
        _backButton = [[PZAccessoryButton alloc] init];
        [_backButton configWithImageSize:CGSizeMake(32, 32)];
        [_backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _commentButton = [PZAccessoryButton buttonWithType:UIButtonTypeSystem];
        [_commentButton configWithAccesoryNumber:extraModel.comments.integerValue position:PZButtonAccessoryPositionTopRight imageSize:CGSizeMake(32, 32) fontSize:22];
        [_commentButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _likeButton = [PZAccessoryButton buttonWithType:UIButtonTypeSystem];
        [_likeButton configWithAccesoryNumber:extraModel.popularity.integerValue position:PZButtonAccessoryPositionTopRight imageSize:CGSizeMake(32, 32) fontSize:22];
        [_likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [_likeButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _starButton = [PZAccessoryButton buttonWithType:UIButtonTypeCustom];
        [_starButton configWithImageSize:CGSizeMake(32, 32)];
        [_starButton setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
        [_starButton setImage:[UIImage imageNamed:@"stared"] forState:(UIControlStateNormal | UIControlStateHighlighted)];
        [_starButton setImage:[UIImage imageNamed:@"stared"] forState:(UIControlStateSelected)];
        [_starButton setImage:[UIImage imageNamed:@"star"] forState:(UIControlStateSelected | UIControlStateHighlighted)];
        
        _starButton.selected = extraModel.isStared;
        
        [_starButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _shareButton = [[PZAccessoryButton alloc] init];
        [_shareButton configWithImageSize:CGSizeMake(32, 32)];
        [_shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
        
        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_backButton,_commentButton,_likeButton,_starButton,_shareButton]];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.alignment = UIStackViewAlignmentFill;
        stackView.distribution = UIStackViewDistributionFillEqually;
        
        [self addSubview:stackView];
        [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.offset(0);
        }];
        
    }
    return self;
    
}

-(void) buttonClicked:(UIButton *) button {
    if (button == _backButton) {
        _backButtonBlock();
    } else if (button == _commentButton) {
        _commentButtonBlock();
    } else if (button == _likeButton) {
        _likeButtonBlock();
        _likeButton.num = _likeButton.num + 1;
    } else if (button == _starButton) {
        _starButtonBlock();
        _starButton.selected = !_starButton.selected;
    } else if (button == _shareButton) {
        _shareButtonBlock();
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
