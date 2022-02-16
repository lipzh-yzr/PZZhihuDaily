//
//  PZMainPageHeaderView.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/28.
//

#import "PZMainPageHeaderView.h"
#import "Masonry.h"
#import "PZScreen.h"
#import "PZMacro.h"

#define PZHEADER_HEIGHT 60

@interface PZMainPageHeaderView ()
@property(nonatomic) UILabel *monthLabel;
@property(nonatomic) UILabel *dateLabel;
@property(nonatomic) UIImageView *avatarView;
@end


/// return month string formatted "X月"
/// @param date date string formatted "yyyyMMdd"
static NSString *displayStr(NSString *date, BOOL isMonth) {
    static NSDictionary *dict = @{
        @"01":@"一月",
        @"02":@"二月",
        @"03":@"三月",
        @"04":@"四月",
        @"05":@"五月",
        @"06":@"六月",
        @"07":@"七月",
        @"08":@"八月",
        @"09":@"九月",
        @"10":@"十月",
        @"11":@"十一月",
        @"12":@"十二月",
    };
    if (isMonth) {
    
        NSString *month = [date substringWithRange:(NSMakeRange(4, 2))];
        return dict[month];
    } else {
        NSString *day = [date substringWithRange:(NSMakeRange(6, 2))];
        return day;
    }
}

@implementation PZMainPageHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:22];
        _dateLabel.pz_themeBlock = ^(UIView * _Nullable view, PZTheme * _Nullable theme) {
            ((UILabel *) view).textColor = theme.pz_textColor;
        };
        [self addSubview:_dateLabel];
        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.leading.offset(9);
                    
        }];
        
        self.monthLabel = [[UILabel alloc] init];
        _monthLabel.font = [UIFont systemFontOfSize:13];
        _monthLabel.pz_themeBlock = ^(UIView * _Nullable view, PZTheme * _Nullable theme) {
            ((UILabel *) view).textColor = theme.pz_textColor;
        };
        [self addSubview:_monthLabel];
        [_monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.dateLabel.mas_bottom);
            make.leading.trailing.equalTo(self.dateLabel);
            make.bottom.lessThanOrEqualTo(self.mas_bottom);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(self.dateLabel.mas_trailing).offset(9);
                    make.top.equalTo(self.dateLabel.mas_top);
                    make.bottom.equalTo(self.monthLabel.mas_bottom);
                    make.width.mas_equalTo(1);
        }];
        lineView.backgroundColor = [UIColor grayColor];
        
        UILabel *appTitle = [[UILabel alloc] init];
        appTitle.font = [UIFont systemFontOfSize:25];
        appTitle.pz_themeBlock = ^(UIView * _Nullable view, PZTheme * _Nullable theme) {
            ((UILabel *) view).textColor = theme.pz_textColor;
        };
        [self addSubview:appTitle];
        [appTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(lineView.mas_leading).offset(9);
            make.top.equalTo(self.dateLabel.mas_top);
            make.bottom.equalTo(self.monthLabel.mas_bottom);
            
        }];
        appTitle.text = @"知乎日报";
//        [appTitle sizeToFit];
        
        _avatarView = [[UIImageView alloc] init];
        [self addSubview:_avatarView];
        [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.offset(0);
                    make.trailing.offset(-9);
                    make.width.mas_equalTo(self.mas_height);
        }];
        _avatarView.layer.cornerRadius = PZHEADER_HEIGHT/2;
        _avatarView.clipsToBounds = YES;
        _avatarView.contentMode = UIViewContentModeScaleToFill;
        _avatarView.image = [UIImage imageNamed:@"avatar"];
        _avatarView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAvatar:)];
        [_avatarView addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)configWithDate:(NSString *)date {
    _dateLabel.text = displayStr(date, NO);
    _monthLabel.text = displayStr(date, YES);
    
//    [_dateLabel sizeToFit];
//    [_monthLabel sizeToFit];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, PZHEADER_HEIGHT);
    
}

-(void) clickAvatar:(UITapGestureRecognizer *) sender {
    if (self.avatarBlock) {
        self.avatarBlock();
    }
}


@end
