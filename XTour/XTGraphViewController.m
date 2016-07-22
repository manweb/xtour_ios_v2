//
//  XTGraphViewController.m
//  XTour
//
//  Created by Manuel Weber on 05/08/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import "XTGraphViewController.h"

@interface XTGraphViewController ()

@end

@implementation XTGraphViewController

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
    
    _graphLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100, 20)];
    
    _graphLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    _graphLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    
    _graph = [[UIImageView alloc] initWithFrame:CGRectMake(0, 25, self.view.frame.size.width-40, (self.view.frame.size.width-40)/2)];
    
    [self.view addSubview:_graphLabel];
    [self.view addSubview:_graph];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_graphLabel release];
    [_graph release];
    [super dealloc];
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
