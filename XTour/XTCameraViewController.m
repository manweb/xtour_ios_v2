//
//  XTCameraViewController.m
//  XTour
//
//  Created by Manuel Weber on 21/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import "XTCameraViewController.h"

@interface XTCameraViewController ()

@end

@implementation XTCameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    float tabBarHeight = [UITabBarController new].tabBar.frame.size.height;
    
    data = [XTDataSingleton singleObj];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 69)];
    UIView *header_shadow = [[UIView alloc] initWithFrame:CGRectMake(0, 69, width, 1)];
    
    header.backgroundColor = [UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f];
    header_shadow.backgroundColor = [UIColor colorWithRed:24.f/255.f green:71.f/255.f blue:111.f/255.f alpha:0.9f];
    
    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(width-50, 25, 40, 40)];
    [_loginButton setImage:[UIImage imageNamed:@"profile_icon.png"] forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(LoadLogin:) forControlEvents:UIControlEventTouchDown];
    
    _CameraIcon = [[UIButton alloc] initWithFrame:CGRectMake(width/2-40, height-tabBarHeight-80, 80, 80)];
    [_CameraIcon setImage:[UIImage imageNamed:@"camera_button@3x.png"] forState:UIControlStateNormal];
    [_CameraIcon addTarget:self action:@selector(LoadCamera:) forControlEvents:UIControlEventTouchDown];
    
    [header addSubview:_loginButton];
    [self.view addSubview:_CameraIcon];
    
    [self.view addSubview:header];
    [self.view addSubview:header_shadow];
    
    [header release];
    [header_shadow release];
    
    _didPickImage = false;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDismissImageDetailView) name:@"ImageDetailViewDismissed" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self LoginViewDidClose:nil];
    
    if (!_didPickImage) {[self.collectionView reloadData];}
}

- (void) didDismissImageDetailView
{
    [self.collectionView reloadData];
}

- (void) LoadCamera:(id)sender
{
    if (!data.tourID) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message: @"Photos können nur während einer Tour aufgenommen werden." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    if (!_ImagePicker) {_ImagePicker = [[UIImagePickerController alloc] init];}
    _ImagePicker.delegate = self;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [_ImagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self.view.window.rootViewController presentViewController:_ImagePicker animated: YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message: @"Camera is not available. Choose existing?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
        
    }
    
    [_ImagePicker release];
    _ImagePicker = nil;
}

- (void) LoadLogin:(id)sender
{
    if (login) {[login.view removeFromSuperview];}
    
    login = [[XTLoginViewController alloc] initWithNibName:nil bundle:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginViewDidClose:) name:@"LoginViewDismissed" object:nil];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:login.view];
    [login animate];
}

- (void)ShowLoginOptions:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginViewDidClose:) name:@"LoginViewDismissed" object:nil];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Du bist eingelogged %@",data.userInfo.userName] delegate:self cancelButtonTitle:@"Abbrechen" destructiveButtonTitle:@"Ausloggen" otherButtonTitles:@"Profil anzeigen", nil];
    
    [actionSheet showInView:self.view];
}

- (void) LoginViewDidClose:(id)sender
{
    [_loginButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    
    if (data.loggedIn) {
        NSString *tempPath = [data GetDocumentFilePathForFile:@"/profile.png" CheckIfExist:NO];
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:tempPath];
        [_loginButton setImage:img forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(ShowLoginOptions:) forControlEvents:UIControlEventTouchUpInside];
        
        [img release];
    }
    else {
        [_loginButton setImage:[UIImage imageNamed:@"profile_icon.png"] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(LoadLogin:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Ausloggen"]) {[data Logout];}
    else if ([buttonTitle isEqualToString:@"Profil anzeigen"]) {
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        float width = screenBound.size.width;
        float height = screenBound.size.height;
        
        XTProfileViewController *profile = [[XTProfileViewController alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        
        [profile initialize];
        
        XTNavigationViewContainer *navigationView = [[XTNavigationViewContainer alloc] initWithNibName:nil bundle:nil view:profile title:data.userInfo.userName isFirstView:YES];
        
        [self.view addSubview:navigationView.view];
        
        [navigationView ShowView];
        
        [profile release];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginViewDismissed" object:nil userInfo:nil];
}

#pragma mark CollectionView methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [data GetNumImages];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSString *imageName = [data GetImageFilenameAt:indexPath.row];
    
    UIImageView *cellImageView = (UIImageView *)[cell viewWithTag:100];
    NSLog(@"Setting image: %@",imageName);
    UIImage *currentImage = [UIImage imageWithContentsOfFile:imageName];
    
    cellImageView.contentMode = UIViewContentModeScaleAspectFill;
    cellImageView.image = currentImage;
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected photo %li", (long)indexPath.row);
    
    UICollectionViewLayoutAttributes *attributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    _cellRect = attributes.frame;
    
    CGPoint p = [self.view.superview convertPoint:_cellRect.origin toView:nil];
    
    _cellRect.origin.x = p.x;
    _cellRect.origin.y = p.y;
    
    XTImageInfo *imageInfo = [[XTImageInfo alloc] init];
    imageInfo.userID = data.userID;
    imageInfo.tourID = data.tourID;
    imageInfo.Filename = [data GetImageFilenameAt:indexPath.row];
    imageInfo.Longitude = [data GetImageLongitudeAt:indexPath.row];
    imageInfo.Latitude = [data GetImageLatitudeAt:indexPath.row];
    imageInfo.Elevation = [data GetImageElevationAt:indexPath.row];
    imageInfo.Comment = [data GetImageCommentAt:indexPath.row];
    imageInfo.Date = [data GetImageDateAt:indexPath.row];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    
    XTImageDetailView *imageDetailView = [[XTImageDetailView alloc] initWithFrame:screenBound fromPosition:_cellRect withImage:imageInfo andImageID:indexPath.row];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:imageDetailView];
    
    [imageDetailView animate];
    
    [imageDetailView release];
}

- (UIImage *) GetSquareSubImage:(UIImage *)image
{
    CGFloat imgWidth = image.size.width;
    CGFloat imgHeight = image.size.height;
    CGFloat subImgWidth;
    CGFloat subImgHeight;
    CGFloat yOffset;
    CGFloat xOffset;
    
    if (imgHeight > imgWidth) {
        subImgHeight = imgWidth;
        subImgWidth = imgWidth;
        
        yOffset = floor(imgHeight/2. - imgWidth/2.);
        xOffset = 0;
    }
    else {
        subImgHeight = imgHeight;
        subImgWidth = imgHeight;
        
        yOffset = 0;
        xOffset = floor(imgWidth/2. - imgHeight/2.);
    }
    
    CGRect subImgRect = CGRectMake(xOffset, yOffset, subImgWidth, subImgHeight);
    
    CGImageRef newImage = CGImageCreateWithImageInRect(image.CGImage, subImgRect);
    UIImage *subImg = [UIImage imageWithCGImage:newImage scale:1 orientation:image.imageOrientation];
    CGImageRelease(newImage);
    
    return subImg;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!_ImagePicker) {_ImagePicker = [[UIImagePickerController alloc] init];}
    _ImagePicker.delegate = self;
    
    if (buttonIndex == 1) {
        [_ImagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:_ImagePicker animated: YES completion:nil];
    }
    
    [_ImagePicker release];
    _ImagePicker = nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"New image");
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (!pickedImage) {return;}
    
    _didPickImage = true;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        float imgHeight = pickedImage.size.height;
        float imgWidth = pickedImage.size.width;
        
        float newImgHeight = 0.;
        float newImgWidth = 0.;
        if (imgHeight > imgWidth) {newImgHeight = 1024.; newImgWidth = ceilf(imgWidth/imgHeight*1024.);}
        else {newImgWidth = 1024.; newImgHeight = ceilf(imgHeight/imgWidth*1024.);}
        
        CGRect rect = CGRectMake(0,0,newImgWidth,newImgHeight);
        UIGraphicsBeginImageContext(rect.size);
        [pickedImage drawInRect:rect];
        UIImage *newImg= UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSString *newImageName = [data GetNewPhotoName];
        NSString *newImageNameOriginal = [newImageName stringByReplacingOccurrencesOfString:@".jpg" withString:@"_original.jpg"];
        
        NSLog(@"Resizing image %@...",newImageName);
        
        NSData *ImageData = UIImageJPEGRepresentation(pickedImage, 0.9);
        NSData *imageResizedData = UIImageJPEGRepresentation(newImg, 0.9);
        
        if (data.profileSettings.saveOriginalImage) {[ImageData writeToFile:newImageNameOriginal atomically:YES];}
        [imageResizedData writeToFile:newImageName atomically:YES];
        
        XTImageInfo *imageInfo = [[XTImageInfo alloc] init];
        imageInfo.Filename = newImageNameOriginal;
        
        CLLocation *location = (CLLocation*)[data GetLastCoordinates];
        
        if (location) {
            imageInfo.Longitude = location.coordinate.longitude;
            imageInfo.Latitude = location.coordinate.latitude;
            imageInfo.Elevation = location.altitude;
            imageInfo.Date = location.timestamp;
        }
        
        UIImageWriteToSavedPhotosAlbum(pickedImage, nil, nil, nil);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Done");
            [data AddImage:imageInfo];
            [self.collectionView reloadData];
            [imageInfo release];
            
            _didPickImage = false;
        });
    });
}

- (void) LoadImagesForCurrentTour
{
    NSString *imagePath = [data GetTourImagePath];
    
    NSArray *imagesInDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:imagePath error:nil];
    for (int i = 0; i < [imagesInDirectory count]; i++) {
        NSString *img = [imagePath stringByAppendingString:[imagesInDirectory objectAtIndex:i]];
        if ([[img pathExtension] isEqualToString:@"jpg"] && [img containsString:data.tourID]) {[_ImageArray addObject:img];}
    }
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_ImageArray release];
    [_CameraIcon release];
    [_loginButton release];
    [_ImagePicker release];
    [_selectedImageView release];
    [_background release];
    [_imgLongitudeLabel release];
    [_imgLatitudeLabel release];
    [_imgElevationLabel release];
    [_imgCommentLabel release];
    [_compassImage release];
    [_selectedIndexPath release];
    [login release];
    [super dealloc];
}

@end
