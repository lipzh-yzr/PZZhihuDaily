//
//  PZFavTableViewCell.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/2/6.
//

#import "PZFavTableViewCell.h"
#import "PZMacro.h"

@interface PZFavTableViewCell ()
@property(nonatomic) UIImageView *newsImage;
@property(nonatomic) UILabel *titleLabel;
@end

@implementation PZFavTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _newsImage = [[UIImageView alloc] init];
        _newsImage.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:_newsImage];
        [_newsImage mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.trailing.offset(-15);
                    make.centerY.offset(0);
            make.width.height.mas_equalTo(80);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = [UIColor labelColor];
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.offset(15);
            make.trailing.equalTo(self.newsImage.mas_leading).offset(-15).priorityHigh();
                    make.centerY.offset(0);
        }];
        
    }
    return self;
}

-(void) configWithFavModel:(PZFavoriteModel *) favModel {
    [_newsImage sd_setImageWithURL:[NSURL URLWithString:favModel.imageUrl]];
    
    _titleLabel.text = favModel.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
