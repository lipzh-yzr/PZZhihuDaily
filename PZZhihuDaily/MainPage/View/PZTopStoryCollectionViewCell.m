//
//  PZTopStoryCollectionViewCell.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/27.
//

#import "PZTopStoryCollectionViewCell.h"
#import "PZMacro.h"

@interface PZTopStoryCollectionViewCell ()
@property(nonatomic) UIImageView *imageView;
@property(nonatomic) UILabel *title;
@property(nonatomic) UILabel *author;
@end

@implementation PZTopStoryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.offset(0);
        }];
        
        _imageView.contentMode = UIViewContentModeScaleToFill;
        
        _title = [[UILabel alloc] init];
        _title.numberOfLines = 0;
        _title.font = [UIFont boldSystemFontOfSize:25];
        [_title setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_bottom).offset(-90);
            make.leading.equalTo(self.imageView.mas_leading).offset(20);
            make.trailing.equalTo(self.imageView.mas_leading).offset(-20);
        }];
        
        _author = [[UILabel alloc] init];
        _author.numberOfLines = 1;
        _author.font = [UIFont systemFontOfSize:18];
        [_author setTextColor:[UIColor lightTextColor]];
        [self.contentView addSubview:_author];
        [_author mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title.mas_bottom);
            make.leading.equalTo(self.title.mas_leading);
            
        }];
    }
    return self;
}

- (void)configWithStoryModel:(PZStoryModel *)storyModel {
    [_imageView sd_setImageWithURL:[NSURL URLWithString:storyModel.image]];
    _title.text = storyModel.title;
    _author.text = storyModel.hint;
}

@end
