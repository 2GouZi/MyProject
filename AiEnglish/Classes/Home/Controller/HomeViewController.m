//
//  HomeViewController.m
//  kangEnglish
//
//  Created by kangGG on 16/7/9.
//  Copyright © 2016年 Kong....... All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCell.h"
#import "AFHTTPSessionManager.h"
#import "HomeModel.h"
#import "HomeDetailController.h"
#import "RDVTabBarController.h"
#import "DetailCell.h"
#import "StudyViewController.h"
#import "HomeHeaderCell.h"
#import "UIImageView+WebCache.h"
#import "WordViewController.h"
#import "TestViewController.h"
@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView *collectionView;
//@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation HomeViewController

//-(NSMutableArray *)dataArray{
//
//    if (_dataArray ==nil) {
//        _dataArray = [NSMutableArray array];
//        
//    }
//    return _dataArray;
//    
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"首页";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self createUI];
    [self requesetData];
    
    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:NO];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    self.studyTitle = [userDef objectForKey:kTitle];
    NSData *imgData = [userDef objectForKey:kStudyImage];
    self.studyImage = [NSKeyedUnarchiver unarchiveObjectWithData:imgData];
    self.senceid = [userDef objectForKey:kSenceid];
    [self.collectionView reloadData];
    
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
    
}
-(void)createUI{
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowlayout.minimumLineSpacing = 5;
    flowlayout.minimumInteritemSpacing = 5;
    flowlayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    flowlayout.itemSize = CGSizeMake((kScreenWidth -20)/3, (kScreenWidth - 20)/2);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.collectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-40) collectionViewLayout:flowlayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview: self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeHeaderCell" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
}
-(void)requesetData{

    NSString *url = @"http://app.ekaola.com/app/home";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *array = responseObject[2];
        
        _dataArray = [NSMutableArray array];
        
        for (NSArray *array1  in array) {
            
            NSString *title = array1[2];
            if (![title containsString:@"配套练习"]) {
                HomeModel *model = [[HomeModel alloc] init];
                
                model.uid = array1[0];
                model.pic = array1[1];
                model.title = array1[2];
                [_dataArray addObject:model];
            }
            
            
        }
        
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        NSLog(@"error:---%@",error.localizedDescription);
        
    }];
    
    
}
#pragma collectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return _dataArray.count;
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.model =_dataArray[indexPath.row];
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    HomeHeaderCell *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(studing)];
    header.studyImage.userInteractionEnabled = YES;
    
    [header.studyImage addGestureRecognizer:tap];
    
    if (self.studyTitle ==nil) {
        header.studyLabel.hidden = YES;
        header.studyImage.hidden = YES;
        header.titleLabel.hidden = YES;
        header.recommendLabel.text = @"推荐课程";
        header.markView.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
        return header;
        
    }else{
        header.studyLabel.hidden = NO;
        header.studyImage.hidden = NO;
        header.titleLabel.hidden = NO;
        [header.studyImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.ekaola.com/%@",self.studyImage]]];
        header.titleLabel.text =self.studyTitle;

        header.model =self.model;
        return header;
    }
}




-(void)studing{
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *titleName = [userDef objectForKey:kTitleName];
    
    if ([titleName containsString:@"课本点读"]) {
        StudyViewController *vc = [[StudyViewController alloc] init];
        
        vc.senceid = self.senceid;
        
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/category"];
        
        NSData *data2 = [NSData dataWithContentsOfFile:path];
        if (data2){
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data2];
            
            NSMutableArray *arr2 = [unarchiver decodeObject];
            
            vc.categoryArray = arr2;
            
            [unarchiver finishDecoding];
        }
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([titleName containsString:@"词汇练习"]){
    
        WordViewController *wordVC = [[WordViewController alloc] init];
        wordVC.senceid = self.senceid;
        [self.navigationController pushViewController:wordVC animated:YES];
        
    }else{
    
        TestViewController *testVc = [[TestViewController alloc] init];
        testVc.senceId =self.senceid;
        [self.navigationController pushViewController:testVc animated:YES];
    }
    
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    if (self.studyTitle==nil) {
        return CGSizeMake(0, 44);
    }else{
    
        return CGSizeMake(0, 186);
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    HomeDetailController *detVc = [[HomeDetailController alloc] init];
    
    HomeModel *model = self.dataArray[indexPath.row];

    detVc.uid =model.uid;
    detVc.titleName = model.title;
    
    [self.navigationController pushViewController:detVc animated:YES];
    
    
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
