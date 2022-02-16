//
//  ViewController.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/24.
//

#import "ViewController.h"
#import "PZHTTPManager.h"
#import "PZMacro.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [[PZHTTPManager defaultManager] getLatestStoriesWithSuccess:^(PZMainPageModel * _Nonnull mainPageModel) {
            NSLog(@"yes");
        PZStoryModel *storyModel = mainPageModel.stories[0];
        [PZFavoriteModel addToFav:storyModel];
        NSArray<PZFavoriteModel *> *favs = [PZFavoriteModel getAllFavs];
        NSLog(favs[0].title);
        } error:^(NSError * _Nonnull error) {
            
        }];
}


@end
