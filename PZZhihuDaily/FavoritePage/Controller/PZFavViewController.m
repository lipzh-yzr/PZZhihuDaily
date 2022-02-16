//
//  PZFavViewController.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/2/6.
//

#import "PZFavViewController.h"
#import "PZMacro.h"
#import "PZFavTableViewCell.h"
#import "PZFavoriteModel.h"
#import "PZNewsViewController.h"

@interface PZFavViewController () <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic) UITableView *favTableView;
@property(nonatomic) NSArray<PZFavoriteModel *> *favModels;
@end

#define FAV_ROWHEIGHT 110

@implementation PZFavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _favModels = [PZFavoriteModel getAllFavs];
    
    _favTableView = [[UITableView alloc] init];
    _favTableView.delegate = self;
    _favTableView.dataSource = self;
    [_favTableView registerClass:PZFavTableViewCell.class forCellReuseIdentifier:CELLKEY(PZFavTableViewCell)];
    _favTableView.rowHeight = FAV_ROWHEIGHT;
    [self.view addSubview:_favTableView];
    [_favTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.height.mas_equalTo(_favModels.count * FAV_ROWHEIGHT);
        make.leading.trailing.offset(0);
    }];
    
    UILabel *endLabel = [[UILabel alloc] init];
    endLabel.text = @"没有更多内容";
    endLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:endLabel];
    [endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.favTableView.mas_bottom);
            make.leading.trailing.offset(0);
    }];
}

#pragma mark - tabelView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _favModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PZFavTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLKEY(PZFavTableViewCell) forIndexPath:indexPath];
    [cell configWithFavModel:_favModels[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PZFavoriteModel *favModel = _favModels[indexPath.row];
    PZStoryModel *storyModel = [favModel toStoryModel];
    
    PZNewsViewController *newsController = [[PZNewsViewController alloc] initWithStoryModel:storyModel];
    self.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:newsController animated:YES completion:nil];
}

@end
