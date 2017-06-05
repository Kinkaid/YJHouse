//
//  YJPersonInfoViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/5.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJPersonInfoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "YJSystemHeaderViewController.h"
#import "YJNickEditViewController.h"
@interface YJPersonInfoViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (nonatomic,strong) UIImagePickerController *picker;
@end

@implementation YJPersonInfoViewController

- (UIImagePickerController *)picker {
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
        _picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        _picker.allowsEditing = YES;
    }
    return _picker;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"我的个人信息"];
    [self.headerImg sd_setImageWithURL:[NSURL URLWithString:[LJKHelper getUserHeaderUrl]] placeholderImage:[UIImage imageNamed:@"icon_header_11"]];
    self.nickLabel.text = [LJKHelper getUserName];
}

- (IBAction)headerImgAction:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == 1) {
        UIActionSheet * act =[[UIActionSheet alloc]initWithTitle:@"请选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机",@"挑选推荐头像", nil];
        [act showInView:self.view];
    } else {
        YJNickEditViewController *vc = [[YJNickEditViewController alloc] init];
        vc.nickName = self.nickLabel.text;
        [vc returnNickName:^(NSString *nickName) {
            self.nickLabel.text = nickName;
        }];
        PushController(vc);
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
            
        case 0:
            //判断系统是否允许选择 相册
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                self.picker.delegate=self;
                //模态显示界面
                [self presentViewController:self.picker animated:YES completion:nil];
            }
            break;
        case 1://判断系统是否允许选择 相机
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                //图片选择是相册（图片来源自相册）
                self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                //设置代理
                self.picker.delegate=self;
                //模态显示界面
                [self presentViewController:self.picker animated:YES completion:nil];
            } else {
                
            }
            break;
            case 2:
        {
            YJSystemHeaderViewController *vc = [[YJSystemHeaderViewController alloc] init];
            [vc returnHeaderImgBlock:^(UIImage *headerImg) {
                [SVProgressHUD show];
                [self postHeaderImg:headerImg];
            }];
            PushController(vc);
        }
            break;
        default:
            break;
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
//    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    UIImage *userImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self postHeaderImg:userImage];
}
- (void)postHeaderImg:(UIImage *)image {
    [SVProgressHUD showWithStatus:@"正在上传"];
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"multipart/form-data",
                                                             @"text/html",
                                                             @"image/jpeg",
                                                             @"image/png",
                                                             @"application/octet-stream",
                                                             @"text/json",
                                                             nil];
    [sessionManager POST:@"https://youjar.com/you/frontend/web/app/user/set-avatar" parameters:@{@"auth_key":[LJKHelper getAuth_key]} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 上传文件
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        [formData appendPartWithFileData:imageData name:@"avatar_image" fileName:fileName mimeType:@"image/jpg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            self.headerImg.image = image;
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            [LJKHelper saveUserHeader:[NSString stringWithFormat:@"https://youjar.com%@",[responseObject[@"result"] lastObject]]];
        } else {
            [SVProgressHUD showErrorWithStatus:@"上传失败,请重试"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"上传失败,请重试"];
    }];
}


@end
