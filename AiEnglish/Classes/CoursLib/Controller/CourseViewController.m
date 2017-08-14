//
//  CourseViewController.m
//  kangEnglish
//
//  Created by kangGG on 16/7/9.
//  Copyright © 2016年 Kong....... All rights reserved.
//

#import "CourseViewController.h"
#import "CourseCell.h"
#import "MJRefresh.h"
#import "HomeDetailController.h"
#import "AFHTTPSessionManager.h"
#import "RDVTabBarController.h"
#import "HomeModel.h"
@interface CourseViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation CourseViewController

-(NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"课程库";

    [self createUI];
    [self requestData];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:NO];
    
}
-(void)createUI{
    
    _sp= 1;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.itemSize = CGSizeMake((kScreenWidth - 30)/2, (kScreenHeight - 64-40-30)/2);
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64-44) collectionViewLayout:layout];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
//    注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"CourseCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
//    上啦加载
    self.collectionView.footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        if (_sp<9) {
       
        _sp ++;
        
        [self requestData];
        
        }
    }];
}

-(void)requestData{
    
    NSString *url = [NSString stringWithFormat:@"http://app.ekaola.com/app/v2/get_pkgs?p=1&sp=%ld&version=2",_sp];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict= responseObject[@"data"];
        
        NSArray *array1 = dict[@"rlist"];
        
        if (_sp==1) {
            
            [self.dataArray removeAllObjects];
        }
        
        [self.dataArray addObjectsFromArray:[CourseModel arrayOfModelsFromDictionaries:array1]];
        
        [self.collectionView reloadData];
        
//        [self.collectionView.header endRefreshing];
        [self.collectionView.footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataArray.count;
    
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    CourseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    HomeDetailController *detVC = [[HomeDetailController alloc] init];
    CourseModel *model = self.dataArray[indexPath.row];
    
    detVC.uid =model.pkgid;
    detVC.titleName = model.title;
    
    NSLog(@"%@........%@",model.pkgid,model.title);
    
    [self.navigationController pushViewController:detVC animated:YES];
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
