//
//  ViewController.m
//  imageDemo
//
//  Created by jiang on 15/12/22.
//  Copyright © 2015年 jiang. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "YYImage.h"



@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic,strong)YYAnimatedImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(50,300, 80, 20)];
    
    [selectBtn setTitle:@"选择照片" forState:UIControlStateNormal];
    
    [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [selectBtn addTarget:self action:@selector(selectedImg) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(250,300, 80, 20)];
    
    [saveBtn setTitle:@"保存照片" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveImg) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:selectBtn];
    [self.view addSubview:saveBtn];
    
    self.imageView = [[YYAnimatedImageView alloc]initWithFrame:CGRectMake(50, 50, 300, 200)];
    
    self.imageView.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:self.imageView];
    
}

- (void)selectedImg{
    
    UIImagePickerController *pickCtrl = [[UIImagePickerController alloc]init];
    //设置资源类型
    pickCtrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickCtrl.delegate = self;
    
    [self presentViewController:pickCtrl animated:YES completion:nil];
    
}

- (void)saveImg{
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://up.toumiao.net/uploads/allimg/201509/29-090547_613.gif"]];
    
    //把image以data保存到相册
    ALAssetsLibrary *assets = [[ALAssetsLibrary alloc]init];
    [assets writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIImagePickerController代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //获取选择的照片url
   NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    NSLog(@"%@",imageURL);
    __weak typeof(self) weakSelf = self;
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
        NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
        //********  获取到照片的data,在这 里进行上传等操作
        YYImage *image = [YYImage imageWithData:data];
        weakSelf.imageView.image = image;
        
        //写入到文件
//      BOOL status = [data writeToFile:@"/Users/jiang/Desktop/xxx.gif" atomically:YES];
        
//        NSLog(@"%d",status);

    } failureBlock:nil];

    [picker dismissViewControllerAnimated:YES completion:nil];

}



@end
