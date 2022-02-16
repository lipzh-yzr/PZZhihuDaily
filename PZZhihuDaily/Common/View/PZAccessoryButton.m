//
//  PZAccessoryButton.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/29.
//

#import "PZAccessoryButton.h"
#import "Masonry.h"

@interface PZAccessoryButton ()

@property(nonatomic) UILabel *numLabel;
@property(nonatomic) CGSize imageSize;
@property(nonatomic) BOOL setSize;
@end

@implementation PZAccessoryButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        _setSize = NO;
    }
    return self;
}

-(void) configWithImageSize:(CGSize) size {
    _imageSize = size;
    _setSize = YES;
}
- (void)configWithAccesoryNumber:(NSInteger)num position:(PZButtonAccessoryPosition)pos imageSize:(CGSize) size fontSize:(CGFloat) fontSize {
    _imageSize = size;
    _setSize = YES;
    _num = num;
    _numLabel = [[UILabel alloc] init];
    _numLabel.text = [@(num) stringValue];
    _numLabel.textColor = [UIColor labelColor];
    _numLabel.font = [UIFont systemFontOfSize:fontSize];
    [self addSubview:_numLabel];
    switch (pos) {
        case PZButtonAccessoryPositionTopLeft:
            {[_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.imageView.mas_top);
                make.trailing.equalTo(self.imageView.mas_leading);
            }];
            break;}
            
        case (PZButtonAccessoryPositionTopRight):
            {[_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.imageView.mas_top);
                make.leading.equalTo(self.imageView.mas_trailing);
            }];
            break;}
            
        case PZButtonAccessoryPositionBotLeft:
            {[_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.imageView.mas_bottom);
                make.trailing.equalTo(self.imageView.mas_leading);
            }];
            break;}
            
        case PZButtonAccessoryPositionBotRight:
            {[_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.imageView.mas_bottom);
                make.leading.equalTo(self.imageView.mas_trailing);
            }];
            break;}
            
        default:
            break;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_setSize) {
    
        CGFloat x = (self.bounds.size.width - self.imageSize.width)/2;
        CGFloat y = (self.bounds.size.height - self.imageSize.height)/2;
        CGFloat width = self.imageSize.width;
        CGFloat height = self.imageSize.height;
        self.imageView.frame = CGRectMake(x, y, width, height);
    }
}

- (void)setNum:(NSInteger)num {
    _numLabel.text = [@(num) stringValue];
}

@end
