//
//  PZMineViewController.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/2/5.
//

#import "PZMineViewController.h"
#import "PZMacro.h"
#import "PZFavViewController.h"

@interface PZMineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic) UIImageView *avatarView;
@property(nonatomic) UILabel *nameLabel;
@property(nonatomic) UITableView *optionTableView;
@property(nonatomic) UIButton *themeButton;
@end

static NSArray<NSString *> *optionList() {
    return @[@"我的收藏",@"消息中心"];
}

#define AVATAR_HEIGHT 120

@implementation PZMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.pz_themeBlock = ^(UIView * _Nullable view, PZTheme * _Nullable theme) {
        view.backgroundColor = theme.pz_bgColor;
    };
    _avatarView = [[UIImageView alloc] init];
    [self.view addSubview:_avatarView];
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.centerX.offset(0);
                make.width.height.mas_equalTo(AVATAR_HEIGHT);
    }];
    _avatarView.layer.cornerRadius = AVATAR_HEIGHT/2;
    _avatarView.clipsToBounds = YES;
    _avatarView.contentMode = UIViewContentModeScaleToFill;
    _avatarView.image = [UIImage imageNamed:@"avatar"];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = @"XOXO";
    _nameLabel.font = [UIFont systemFontOfSize:24];
    _nameLabel.pz_themeBlock = ^(UIView * _Nullable view, PZTheme * _Nullable theme) {
        ((UILabel *) view).textColor = theme.pz_textColor;
    };
    [self.view addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.avatarView.mas_bottom).offset(8);
        make.centerX.offset(0);
    }];
    
    _optionTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_optionTableView];
    [_optionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.nameLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(optionList().count * 55);
        make.leading.trailing.offset(0);
    }];
    _optionTableView.rowHeight = 55;
    _optionTableView.delegate = self;
    _optionTableView.dataSource = self;
    [_optionTableView registerClass:UITableViewCell.class forCellReuseIdentifier:CELLKEY(UITableViewCell)];
    
    _themeButton = [[UIButton alloc] init];
    [_themeButton setImage:[UIImage imageNamed:@"lightMode"] forState:UIControlStateNormal];
    [_themeButton setImage:[UIImage imageNamed:@"nightMode"] forState:UIControlStateSelected];
    [self.view addSubview:_themeButton];
    [_themeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.centerX.offset(0);
        make.width.height.mas_equalTo(100);
    }];
    [_themeButton addTarget:self action:@selector(clickThemeButton:) forControlEvents:UIControlEventTouchUpInside];
    if ([[PZThemeManager sharedManager].pz_theme isEqualToString: PZThemeNight]) {
        _themeButton.selected = YES;
    }
}

#pragma mark - private
-(void) clickThemeButton:(UIButton *) sender {
    sender.selected = !sender.selected;
    [[PZThemeManager sharedManager] pz_changeToTheme:sender.selected? PZThemeNight:PZThemeDay];
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return optionList().count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLKEY(UITableViewCell) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.pz_themeBlock = ^(UIView * _Nullable view, PZTheme * _Nullable theme) {
        view.backgroundColor = theme.pz_bgColor;
    };
    UILabel *label = [[UILabel alloc] init];
    label.text = optionList()[indexPath.row];
    label.font = [UIFont systemFontOfSize:24];
    label.pz_themeBlock = ^(UIView * _Nullable view, PZTheme * _Nullable theme) {
        ((UILabel *) view).textColor = theme.pz_textColor;
    };
    [cell addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.offset(10);
        make.centerY.offset(0);
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        PZFavViewController *favController = [[PZFavViewController alloc] init];
        
        [self.navigationController pushViewController:favController animated:YES];
    }
}

@end
