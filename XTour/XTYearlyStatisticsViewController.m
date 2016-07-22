//
//  XTYearlyStatisticsViewController.m
//  XTour
//
//  Created by Manuel Weber on 11/10/15.
//  Copyright © 2015 Manuel Weber. All rights reserved.
//

#import "XTYearlyStatisticsViewController.h"

@interface XTYearlyStatisticsViewController ()

@end

@implementation XTYearlyStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    data = [XTDataSingleton singleObj];
}

- (void) LoadData
{
    if (!data.loggedIn) {return;}
    
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    
    float marginLeft = 15;
    float marginRight = 0;
    float marginTop = 0;
    float marginBottom = 15;
    
    float spaceBetweenWeeks = 1;
    //float spaceBetweenMonths = 2;
    
    float viewWidth = (width-marginLeft-marginRight-51*spaceBetweenWeeks)/52;
    
    NSArray *months = [NSArray arrayWithObjects:@"Jan",@"Feb",@"Mär",@"Apr",@"Mai",@"Jun",@"Jul",@"Aug",@"Sep",@"Okt",@"Nov",@"Dez", nil];
    
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:currentDate];
    
    NSInteger currentMonth = [components month];
    
    _weekViews = [[NSMutableArray alloc] init];
    
    NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/get_yearly_statistics.php?uid=%@", data.userID];
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionTask *sessionTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSData *responseData, NSURLResponse *URLResponse, NSError *error) {
        XTServerRequestHandler *request = [[[XTServerRequestHandler alloc] init] autorelease];
        
        NSMutableArray *yearlyStatistics = [request GetYearlyStatistics:responseData];
        
        if ([yearlyStatistics count] < 52) {return;}
        
        for (int i = 0; i < 52; i++) {
            float currentHeight = [[yearlyStatistics objectAtIndex:i] floatValue];
            
            UIView *currentView = [[UIView alloc] initWithFrame:CGRectMake(marginLeft+i*(viewWidth+spaceBetweenWeeks), (height-marginTop-marginBottom)*(1-currentHeight/5), viewWidth, (height-marginTop-marginBottom)/5*currentHeight)];
            
            currentView.backgroundColor = [UIColor grayColor];
            
            [_weekViews addObject:currentView];
            
            [self.view addSubview:currentView];
            
            [currentView release];
        }
        
        UIView *xAxis = [[UIView alloc] initWithFrame:CGRectMake(marginLeft-2, height-marginBottom, width-marginLeft-marginRight+2, 1)];
        
        UIView *yAxis = [[UIView alloc] initWithFrame:CGRectMake(marginLeft-2, marginTop, 1, height-marginTop-marginBottom)];
        
        xAxis.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
        
        yAxis.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
        
        [self.view addSubview:xAxis];
        [self.view addSubview:yAxis];
        
        [xAxis release];
        [yAxis release];
        
        float monthLength = (width-marginLeft-marginRight)/12;
        int k = (int)currentMonth-1;
        for (int i = 0; i < 12; i++) {
            NSString *monthString = [months objectAtIndex:k];
            
            UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(width-marginRight-(i+1)*monthLength, height-marginBottom, monthLength, marginBottom)];
            
            monthLabel.text = monthString;
            monthLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
            monthLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
            monthLabel.textAlignment = NSTextAlignmentCenter;
            
            [self.view addSubview:monthLabel];
            
            [monthLabel release];
            
            k--;
            
            if (k < 0) {k = 12+k;}
        }
        
        float max = [self GetMax:yearlyStatistics];
        
        int nDivisions = ceil(max/5)+1;
        
        if (nDivisions == 1) {nDivisions = 2;}
        
        float yAxisLength = (height-marginTop-marginBottom)/(nDivisions-1);
        
        for (int i = 0; i < nDivisions; i++) {
            float yPosition = height-marginBottom-i*yAxisLength-5;
            if (i == nDivisions-1) {yPosition += 5;}
            
            UILabel *yAxisLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yPosition, marginLeft-2, 10)];
            
            yAxisLabel.text = [NSString stringWithFormat:@"%.0f",i*5.0];
            yAxisLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
            yAxisLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
            yAxisLabel.textAlignment = NSTextAlignmentRight;
            
            [self.view addSubview:yAxisLabel];
            
            [yAxisLabel release];
        }
    }];
    
    [sessionTask resume];
    
    /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        XTServerRequestHandler *request = [[[XTServerRequestHandler alloc] init] autorelease];
        
        NSMutableArray *yearlyStatistics = [request GetYearlyStatistics:data.userID];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([yearlyStatistics count] < 52) {return;}
            
            for (int i = 0; i < 52; i++) {
                float currentHeight = [[yearlyStatistics objectAtIndex:i] floatValue];
                
                UIView *currentView = [[UIView alloc] initWithFrame:CGRectMake(marginLeft+i*(viewWidth+spaceBetweenWeeks), (height-marginTop-marginBottom)*(1-currentHeight/5), viewWidth, (height-marginTop-marginBottom)/5*currentHeight)];
                
                currentView.backgroundColor = [UIColor grayColor];
                
                [_weekViews addObject:currentView];
                
                [self.view addSubview:currentView];
                
                [currentView release];
            }
            
            UIView *xAxis = [[UIView alloc] initWithFrame:CGRectMake(marginLeft-2, height-marginBottom, width-marginLeft-marginRight+2, 1)];
            
            UIView *yAxis = [[UIView alloc] initWithFrame:CGRectMake(marginLeft-2, marginTop, 1, height-marginTop-marginBottom)];
            
            xAxis.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
            
            yAxis.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
            
            [self.view addSubview:xAxis];
            [self.view addSubview:yAxis];
            
            [xAxis release];
            [yAxis release];
            
            float monthLength = (width-marginLeft-marginRight)/12;
            int k = (int)currentMonth-1;
            for (int i = 0; i < 12; i++) {
                NSString *monthString = [months objectAtIndex:k];
                
                UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(width-marginRight-(i+1)*monthLength, height-marginBottom, monthLength, marginBottom)];
                
                monthLabel.text = monthString;
                monthLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
                monthLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
                monthLabel.textAlignment = NSTextAlignmentCenter;
                
                [self.view addSubview:monthLabel];
                
                [monthLabel release];
                
                k--;
                
                if (k < 0) {k = 12+k;}
            }
            
            float max = [self GetMax:yearlyStatistics];
            
            int nDivisions = ceil(max/5)+1;
            
            float yAxisLength = (height-marginTop-marginBottom)/(nDivisions-1);
            
            for (int i = 0; i < nDivisions; i++) {
                float yPosition = height-marginBottom-i*yAxisLength-5;
                if (i == nDivisions-1) {yPosition += 5;}
                
                UILabel *yAxisLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yPosition, marginLeft-2, 10)];
                
                yAxisLabel.text = [NSString stringWithFormat:@"%.0f",i*5.0];
                yAxisLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
                yAxisLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
                yAxisLabel.textAlignment = NSTextAlignmentRight;
                
                [self.view addSubview:yAxisLabel];
                
                [yAxisLabel release];
            }
        });
    });*/
}

- (float) GetMax:(NSMutableArray*)dataArray
{
    float max = -1e6;
    for (int i = 0; i < [dataArray count]; i++) {
        if ([[dataArray objectAtIndex:i] floatValue] > max) {max = [[dataArray objectAtIndex:i] floatValue];}
    }
    
    return max;
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
