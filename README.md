说明
==============

最近项目中用需要实现保存Gif 图到本地并可以分享.自己研究几天做出了,现在和大家分享一下吧

就是一个简答的demo,希望能够给有需要的人有一点帮助吧。写的不好,勿喷。

主要思路来自 [ibireme](https://github.com/ibireme) 大神的博客  [iOS 处理图片的一些小 Tip](http://blog.ibireme.com/2015/11/02/ios_image_tips/)

如何把 GIF 动图保存到相册？<br/>

iOS 的相册是支持保存 GIF 和 APNG 动图的，只是不能直接播放。用 [ALAssetsLibrary writeImageDataToSavedPhotosAlbum:metadata:completionBlock] 可以直接把 APNG、GIF 的数据写入相册。如果图省事直接用 UIImageWriteToSavedPhotosAlbum() 写相册，那么图像会被强制转码为 PNG。

我这里用的是 ibireme的 [YYImage](https://github.com/ibireme/YYImage)
其实你项目中使用的是[SDWebImage](https://github.com/rs/SDWebImage)  直接使用 imageView sd_setImageWithURL: 即可显示Gif图, [SDWebImage]( https://github.com/rs/SDWebImage/blob/master/SDWebImage/UIImage%2BGIF.m)已经写了 UIImage+GIF分类



==============

###保存图片
	
	 
	NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://up.toumiao.net/uploads/allimg/201509/29-090547_613.gif"]];
    
    //把Image以data保存到相册
    ALAssetsLibrary *assets = [[ALAssetsLibrary alloc]init];
    [assets writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        
    }];


###从相册获取Gif图


    
    UIImagePickerController *pickCtrl = [[UIImagePickerController alloc]init];
    //设置资源类型
    pickCtrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickCtrl.delegate = self;
    
    [self presentViewController:pickCtrl animated:YES completion:nil];
    




###获取数据
  ```
   NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
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

    } failureBlock:nil];
    
    ```



