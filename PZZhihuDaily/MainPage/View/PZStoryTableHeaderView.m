//
//  PZStoryTableHeaderView.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/27.
//

#import "PZStoryTableHeaderView.h"
#import "Masonry.h"
#import "PZMacro.h"

@interface PZStoryTableHeaderView ()
@property(nonatomic) UILabel *dateLabel;
@end

@implementation PZStoryTableHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:16];
        _dateLabel.pz_themeBlock = ^(UIView * _Nullable view, PZTheme * _Nullable theme) {
            ((UILabel *) view).textColor = theme.pz_textColor;
        };
        [self addSubview:_dateLabel];
        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.leading.offset(15);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.trailing.offset(0);
            make.width.mas_equalTo(300);
            make.height.mas_equalTo(1);
        }];
        lineView.pz_themeBlock = ^(UIView * _Nullable view, PZTheme * _Nullable theme) {
            view.backgroundColor = theme.pz_grayTextColor;
        };
    }
    return self;
}

-(void) configWithDate:(NSString *) date {
    _dateLabel.text = date;
}

@end
