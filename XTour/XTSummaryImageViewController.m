//
//  XTSummaryImageViewController.m
//  XTour
//
//  Created by Manuel Weber on 14/05/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import "XTSummaryImageViewController.h"

@interface XTSummaryImageViewController ()

@end

@implementation XTSummaryImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    
    float boxWidth = width - 30;
    float boxMarginLeft = 5.0f;
    float boxMarginTop = 5.0f;
    
    self.view.frame = CGRectMake(boxMarginLeft, boxMarginTop, boxWidth, 190);
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:_collectionView];
    
    [layout release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDismissImageDetailView) name:@"ImageDetailViewDismissed" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_images release];
    [_selectedImageView release];
    [_background release];
    [_imgLongitudeLabel release];
    [_imgLatitudeLabel release];
    [_imgElevationLabel release];
    [_imgCommentLabel release];
    [_compassImage release];
    [_selectedIndexPath release];
    [super dealloc];
}

- (void) didDismissImageDetailView
{
    [_collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    XTImageInfo *imageInfo = [_images objectAtIndex:indexPath.row];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    
    if ([imageInfo.Filename containsString:@"http://www.xtour.ch"]) {
        [imageView setImageWithURL:[NSURL URLWithString:imageInfo.Filename]];
    }
    else {
        imageView.image = [UIImage imageNamed:imageInfo.Filename];
    }
    
    [cell addSubview:imageView];
    
    [imageView release];
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    _cellRect = attributes.frame;
    
    CGPoint p = [self.view.superview convertPoint:_cellRect.origin toView:nil];
    
    _cellRect.origin.x = p.x + 5;
    _cellRect.origin.y = p.y + 5;
    
    XTImageInfo *imageInfo = [_images objectAtIndex:indexPath.row];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    
    XTImageDetailView *imageDetailView = [[XTImageDetailView alloc] initWithFrame:screenBound fromPosition:_cellRect withImage:imageInfo andImageID:indexPath.row];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:imageDetailView];
    
    [imageDetailView animate];
    
    [imageDetailView release];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(90, 90);
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
