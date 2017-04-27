//
//  YJPersonInfoViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/5.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJPersonInfoViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface YJPersonInfoViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UITextField *nickTextField;
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
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)headerImgAction:(id)sender {
    UIActionSheet * act =[[UIActionSheet alloc]initWithTitle:@"请选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机",@"挑选推荐头像", nil];
    [act showInView:self.view];
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
    self.headerImg.image = userImage;
}
@end
