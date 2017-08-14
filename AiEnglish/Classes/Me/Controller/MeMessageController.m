//
//  MeMessageController.m
//  AiEnglish
//
//  Created by kangGG on 17/2/16.
//  Copyright © 2017年 Kong....... All rights reserved.
//

#import "MeMessageController.h"
#import "MessageHeaderCell.h"
#import "MessageNameViewController.h"
#import "RDVTabBarController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ImageTool.h"
@interface MeMessageController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation MeMessageController


-(void)viewWillAppear:(BOOL)animated{

    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    
    [self.rdv_tabBarController setTabBarHidden:YES];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    self.name = [userDef objectForKey:kName];
    
    NSData *imgData = [userDef objectForKey:kHeaderImage];
    
    self.headerImg = [NSKeyedUnarchiver unarchiveObjectWithData:imgData];

    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人信息";
    
    self.view.backgroundColor  = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageHeaderCell" bundle:nil] forCellReuseIdentifier:@"header"];
   
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section ==0) {
        
        MessageHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"header" forIndexPath:indexPath];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        cell.headerInageView.image =self.headerImg;
        return cell;
    }else{
    
        static NSString *ID = @"cell";
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell==nil) {
            cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.text = @"昵称";
        cell.detailTextLabel.text= self.name;
        cell.selectionStyle =UITableViewCellSelectionStyleNone;

        return cell;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0&&indexPath.row==0) {
        return 100;
    }else{
    
        return 44;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section ==0) {
        return 0;
    }else{
    
        return 20;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.section==0&&indexPath.row==0) {
//  点击头像  修改头像
        //打开相册
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *pickerContr = [[UIImagePickerController alloc] init];
            pickerContr.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
            pickerContr.delegate = self;
            pickerContr.allowsEditing = YES;
        
            [self presentViewController:pickerContr animated:YES completion:nil];
            
        }else{
        
            NSLog(@"打开相册失败");
        }
    }else{
//  点击昵称  修改昵称
        MessageNameViewController *nameVC = [[MessageNameViewController alloc] init];

        
        [self.navigationController pushViewController:nameVC animated:YES];
    
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark 选取相片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    NSString *type = info[UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerEditedImage];
        UIImage *smlImage = [[ImageTool shareTool]resizeImageToSize:CGSizeMake(100, 100)sizeOfImage:image];
    
        NSData *imgData = [NSKeyedArchiver archivedDataWithRootObject:smlImage];
        
        self.headerImg = smlImage;
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
        [userDef setObject:imgData forKey:kHeaderImage];
        
        [userDef synchronize];
        
        [self.tableView reloadData];
        
    }else{
    
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    

}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
