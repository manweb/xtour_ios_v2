//
//  XTSettingsViewController.m
//  XTour
//
//  Created by Manuel Weber on 21/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import "XTSettingsViewController.h"

@interface XTSettingsViewController ()

@end

@implementation XTSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView setContentInset:UIEdgeInsetsMake(70, 0, 50, 0)];
        self.tableView.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
        
        [self.view addSubview:_tableView];
        
        data = [XTDataSingleton singleObj];
    }
    return self;
}

- (void)viewDidLoad
{
    NSArray *tableItems1 = [NSArray arrayWithObjects:@"Ski",@"Snowboard",@"Splitboard", nil];
    NSArray *tableItems2 = [NSArray arrayWithObjects:@"Originalbild speichern",@"Anonym aufzeichnen", nil];
    NSArray *tableItems3 = [NSArray arrayWithObjects:@"Safety Modus",@"Batterie Sparmodus", nil];
    NSArray *tableItems4 = [NSArray arrayWithObjects:@"Warnungen",@"Touren", nil];
    
    _tableArrays = [[NSDictionary alloc] initWithObjectsAndKeys:tableItems1, @"Mein Sportgerät", tableItems2, @"Diverses", tableItems3, @"Safety", tableItems4, @"Suchradien", nil];
    
    _sectionTitles = [[NSArray alloc] initWithObjects:@"Mein Sportgerät",@"Diverses", @"Safety", @"Suchradien", nil];
    
    _sectionFooter = [[NSArray alloc] initWithObjects:@"",@"",@"Bei Aktivierung des Safety Modus stoppt die App automatisch das Aufzeichnen der GPS Daten wenn die Batterie unter 20% fällt.", @"", nil];
    
    _selectedIndex = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sectionTitles count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sectionTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionTitle = [_sectionTitles objectAtIndex:section];
    NSArray *sectionItems = [_tableArrays objectForKey:sectionTitle];
    
    return [sectionItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];
    
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableCell"] autorelease];
    
    NSString *sectionTitle = [_sectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionItems = [_tableArrays objectForKey:sectionTitle];
    
    cell.textLabel.text = [sectionItems objectAtIndex:indexPath.row];
    
    switch (indexPath.section) {
        case 0:
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            if (indexPath.row == data.profileSettings.equipment) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
            break;
            
        case 1:
        {
            UISwitch *switchGeneral = [[[UISwitch alloc] init] autorelease];
            
            switchGeneral.frame = CGRectMake(cell.frame.size.width-switchGeneral.frame.size.width-10, (cell.frame.size.height - switchGeneral.frame.size.height)/2, 50, switchGeneral.frame.size.height);
            [cell.contentView addSubview:switchGeneral];
            
            switch (indexPath.row) {
                case 0:
                    switchGeneral.on = data.profileSettings.saveOriginalImage;
                    [switchGeneral addTarget:self action:@selector(switchSaveImagesChanged:) forControlEvents:UIControlEventValueChanged];
                    break;
                case 1:
                    switchGeneral.on = data.profileSettings.anonymousTracking;
                    [switchGeneral addTarget:self action:@selector(switchAnonymousChanged:) forControlEvents:UIControlEventValueChanged];
                    break;
            }
        }
            break;
            
        case 2:
        {
            UISwitch *switchSafety = [[[UISwitch alloc] init] autorelease];
            
            switchSafety.frame = CGRectMake(cell.frame.size.width-switchSafety.frame.size.width-10, (cell.frame.size.height - switchSafety.frame.size.height)/2, 50, switchSafety.frame.size.height);
            [cell.contentView addSubview:switchSafety];
            
            switch (indexPath.row) {
                case 0:
                    switchSafety.on = data.profileSettings.safetyModus;
                    [switchSafety addTarget:self action:@selector(switchSafetyChanged:) forControlEvents:UIControlEventValueChanged];
                    break;
                case 1:
                    switchSafety.on = data.profileSettings.batterySafeMode;
                    [switchSafety addTarget:self action:@selector(switchBatterySafeModusChanged:) forControlEvents:UIControlEventValueChanged];
                    break;
                    
            }
        }
            break;
        case 3:
        {
            switch (indexPath.row) {
                case 0:
                {
                    if (!_sliderWarning) {_sliderWarning = [[UISlider alloc] initWithFrame:CGRectMake(120, 0, 130, cell.frame.size.height)];}
                    
                    _sliderWarning.minimumValue = 1.0f;
                    _sliderWarning.maximumValue = 100.0f;
                    _sliderWarning.value = data.profileSettings.warningRadius;
                    
                    [_sliderWarning addTarget:self action:@selector(WarningRadiusChanged:) forControlEvents:UIControlEventValueChanged];
                    
                    if (!_WarningValue) {_WarningValue = [[UILabel alloc] initWithFrame:CGRectMake(260, 5, 60, 30)];}
                    
                    _WarningValue.text = [NSString stringWithFormat:@"%.0f km",data.profileSettings.warningRadius];
                    
                    [cell.contentView addSubview:_sliderWarning];
                    [cell.contentView addSubview:_WarningValue];
                }
                    break;
                case 1:
                {
                    if (!_sliderTours) {_sliderTours = [[UISlider alloc] initWithFrame:CGRectMake(120, 0, 130, cell.frame.size.height)];}
                    
                    _sliderTours.minimumValue = 1.0f;
                    _sliderTours.maximumValue = 100.0f;
                    _sliderTours.value = data.profileSettings.toursRadius;
                    
                    [_sliderTours addTarget:self action:@selector(ToursRadiusChanged:) forControlEvents:UIControlEventValueChanged];
                    
                    if (!_ToursValue) {_ToursValue = [[UILabel alloc] initWithFrame:CGRectMake(260, 5, 60, 30)];}
                    
                    _ToursValue.text = [NSString stringWithFormat:@"%.0f km",data.profileSettings.toursRadius];
                    
                    [cell.contentView addSubview:_sliderTours];
                    [cell.contentView addSubview:_ToursValue];
                }
                    break;
            }
        }
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.section) {
        case 0:
            data.profileSettings.equipment = indexPath.row;
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
    }
    
    [tableView reloadData];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, 200, 20)];
    
    lblTitle.font = [UIFont fontWithName:@"Helvetica" size:16];
    lblTitle.textColor = [UIColor colorWithRed:150.0F/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.text = [_sectionTitles objectAtIndex:section];
    
    [viewHeader addSubview:lblTitle];
    
    [lblTitle release];
    
    return viewHeader;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 70)];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, tableView.frame.size.width-10, 70)];
    
    textView.font = [UIFont fontWithName:@"Helvetica" size:14];
    textView.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    textView.backgroundColor = [UIColor clearColor];
    textView.text = [_sectionFooter objectAtIndex:section];
    
    textView.scrollEnabled = false;
    
    textView.editable = false;
    
    [viewFooter addSubview:textView];
    
    [textView release];
    
    return viewFooter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {return 70.0;}
    else {return 0;}
}

- (void)switchSaveImagesChanged:(id)sender
{
    bool currentStatus = data.profileSettings.saveOriginalImage;
    
    data.profileSettings.saveOriginalImage = !currentStatus;
}

- (void)switchAnonymousChanged:(id)sender
{
    bool currentStatus = data.profileSettings.anonymousTracking;
    
    data.profileSettings.anonymousTracking = !currentStatus;
}

- (void)switchSafetyChanged:(id)sender
{
    bool currentStatus = data.profileSettings.safetyModus;
    
    data.profileSettings.safetyModus = !currentStatus;
}

- (void)switchBatterySafeModusChanged:(id)sender
{
    bool currentStatus = data.profileSettings.batterySafeMode;
    
    data.profileSettings.batterySafeMode = !currentStatus;
}

- (void)WarningRadiusChanged:(id)sender
{
    _WarningValue.text = [NSString stringWithFormat:@"%.0f km",_sliderWarning.value];
    
    data.profileSettings.warningRadius = _sliderWarning.value;
}

- (void)ToursRadiusChanged:(id)sender
{
    _ToursValue.text = [NSString stringWithFormat:@"%.0f km",_sliderTours.value];
    
    data.profileSettings.toursRadius = _sliderTours.value;
}

- (IBAction)LoadLogin:(id)sender {
}

- (void)dealloc {
    [super dealloc];
}
@end
