//
//  PZStoryTableViewCell.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/27.
//

#import "PZStoryTableViewCell.h"
#import "PZMacro.h"

@interface PZStoryTableViewCell ()
@property(nonatomic) UILabel *title;
@property(nonatomic) UILabel *hint;

@end

@implementation PZStoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.pz_themeBlock = ^(UIView * _Nullable view, PZTheme * _Nullable theme) {
            view.backgroundColor = theme.pz_bgColor;
        };
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _coverView = [[UIImageView alloc] init];
        [self.contentView addSubview:_coverView];
        [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.offset(-15);
            make.centerY.offset(0);
            make.width.height.mas_equalTo(80);
        }];
        
        _title = [[UILabel alloc] init];
        _title.numberOfLines = 2;
        _title.font = [UIFont boldSystemFontOfSize:19];
        _title.pz_themeBlock = ^(UIView * _Nullable view, PZTheme * _Nullable theme) {
            ((UILabel *) view).textColor = theme.pz_textColor;
        };
        [self.contentView addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(21);
            make.leading.offset(15);
            make.trailing.equalTo(self.coverView.mas_leading).offset(-15);
        }];
        
        _hint = [[UILabel alloc] init];
        _hint.numberOfLines = 2;
        _hint.font = [UIFont systemFontOfSize:14];
        _hint.pz_themeBlock = ^(UIView * _Nullable view, PZTheme * _Nullable theme) {
            ((UILabel *) view).textColor = theme.pz_grayTextColor;
        };
        [self.contentView addSubview:_hint];
        [_hint mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title.mas_bottom);
            make.leading.equalTo(self.title.mas_leading);
            make.trailing.lessThanOrEqualTo(self.title.mas_trailing);
            make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom).offset(-20);
        }];
    }
    return self;
}

- (void)configWithStoryModel:(PZStoryModel *)storyModel {
    _title.text = storyModel.title;
    _hint.text = storyModel.hint;
//    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:storyModel.image] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
//
//    }];
    
//    [self performSelectorOnMainThread:@selector(setImageWithUrl:) withObject:storyModel.image waitUntilDone:NO modes:@[NSDefaultRunLoopMode]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setImageWithUrl:(NSString *) url {
//    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:url] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
//        self.coverView.image = image;
//    }];
    [_coverView sd_setImageWithURL:[NSURL URLWithString:url]];
}

@end
