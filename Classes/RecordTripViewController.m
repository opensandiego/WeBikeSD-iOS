/** Cycle Philly, 2013 Code For Philly
 *                                    Philadelphia, PA. USA
 *
 *
 *   Contact: Corey Acri <acri.corey@gmail.com>
 *            Lloyd Emelle <lemelle@codeforamerica.org>
 *
 *   Updated/Modified for Philadelphia's app deployment. Based on the
 *   Cycle Atlanta and CycleTracks codebase for SFCTA.
 *
 * Cycle Atlanta, Copyright 2012, 2013 Georgia Institute of Technology
 *                                    Atlanta, GA. USA
 *
 *   @author Christopher Le Dantec <ledantec@gatech.edu>
 *   @author Anhong Guo <guoanhong@gatech.edu>
 *
 *   Updated/Modified for Atlanta's app deployment. Based on the
 *   CycleTracks codebase for SFCTA.
 *
 ** CycleTracks, Copyright 2009,2010 San Francisco County Transportation Authority
 *                                    San Francisco, CA, USA
 *
 *   @author Matt Paul <mattpaul@mopimp.com>
 *
 *   This file is part of CycleTracks.
 *
 *   CycleTracks is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   CycleTracks is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with CycleTracks.  If not, see <http://www.gnu.org/licenses/>.
 */

//
//  RecordTripViewController.m
//  CycleTracks
//
//  Copyright 2009-2010 SFCTA. All rights reserved.
//  Written by Matt Paul <mattpaul@mopimp.com> on 8/10/09.
//	For more information on the project,
//	e-mail Billy Charlton at the SFCTA <billy.charlton@sfcta.org>


#import "constants.h"
#import "MapViewController.h"
#import "NoteViewController.h"
#import "PersonalInfoViewController.h"
#import "PickerViewController.h"
#import "RecordTripViewController.h"
#import "ReminderManager.h"
#import "TripManager.h"
#import "NoteManager.h"
#import "Trip.h"
#import "User.h"
#import "CycleAtlantaAppDelegate.h"

@import CoreLocation;

@interface RecordTripViewController () <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

//TODO: Fix incomplete implementation
@implementation RecordTripViewController

@synthesize tripManager;// reminderManager;
@synthesize noteManager;
@synthesize infoButton, saveButton, startButton, noteButton, parentView;
@synthesize timer, timeCounter, distCounter;
@synthesize recording, shouldUpdateCounter, userInfoSaved;
@synthesize appDelegate;
<<<<<<< HEAD
@synthesize saveActionSheet;
@synthesize window;
=======
//@synthesize saveActionSheet;
>>>>>>> master

#pragma mark CLLocationManagerDelegate methods

- (void)save:(UIButton *)sender {
    
}

- (void) createCounter {
    
}

- (UIButton *)createSaveButton {
    return [[UIButton alloc] init];
}

- (CLLocationManager *)getLocationManager {
    appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.locationManager != nil) {
        return appDelegate.locationManager;
    }
    
<<<<<<< HEAD
    appDelegate.locationManager = [[[CLLocationManager alloc] init] autorelease];
=======
    appDelegate.locationManager = [[CLLocationManager alloc] init];
>>>>>>> master
    appDelegate.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    appDelegate.locationManager.delegate = self;
    
    return appDelegate.locationManager;
}



- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    CLLocationDistance deltaDistance = [newLocation distanceFromLocation:oldLocation];
    
    if (!myLocation) {
        myLocation = newLocation;
    }
    else if ([myLocation distanceFromLocation:newLocation]) {
        myLocation = newLocation;
    }
    
    if ( !didUpdateUserLocation )
    {
        NSLog(@"zooming to current user location");
        MKCoordinateRegion region = { newLocation.coordinate, { 0.0078, 0.0068 } };
        [mapView setRegion:region animated:YES];
        
        didUpdateUserLocation = YES;
    }
    
    // only update map if deltaDistance is at least some epsilon
    else if ( deltaDistance > 1.0 )
    {
        //NSLog(@"center map to current user location");
        [mapView setCenterCoordinate:newLocation.coordinate animated:YES];
    }
    
<<<<<<< HEAD
    if ( !didUpdateUserLocation )
    {
        NSLog(@"zooming to current user location");
        MKCoordinateRegion region = { newLocation.coordinate, { 0.0078, 0.0068 } };
        [mapView setRegion:region animated:YES];
        
        didUpdateUserLocation = YES;
    }
    
    // only update map if deltaDistance is at least some epsilon
    else if ( deltaDistance > 1.0 )
    {
        //NSLog(@"center map to current user location");
        [mapView setCenterCoordinate:newLocation.coordinate animated:YES];
    }
    
=======
>>>>>>> master
    if ( recording )
    {
        // add to CoreData store
        CLLocationDistance distance = [tripManager addCoord:newLocation];
        self.distCounter.text = [NSString stringWithFormat:@"%.1f mi", distance / 1609.344];
    }
    
    // 	double mph = ( [trip.distance doubleValue] / 1609.344 ) / ( [trip.duration doubleValue] / 3600. );
    if ( newLocation.speed >= 0. )
        speedCounter.text = [NSString stringWithFormat:@"%.1f mph", newLocation.speed * 3600 / 1609.344];
    else
        speedCounter.text = @"0.0 mph";
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"locationManager didFailWithError: %@", error );
}


#pragma mark MKMapViewDelegate methods

- (void)initTripManager:(TripManager*)manager
{
    manager.dirty			= YES;
    self.tripManager		= manager;
    manager.parent          = self;
}


- (void)initNoteManager:(NoteManager*)manager
{
    self.noteManager = manager;
    manager.parent = self;
}


- (BOOL)hasUserInfoBeenSaved
{
    BOOL					response = NO;
    NSManagedObjectContext	*context = tripManager.managedObjectContext;
    NSFetchRequest			*request = [[NSFetchRequest alloc] init];
    NSEntityDescription		*entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error;
    NSInteger count = [context countForFetchRequest:request error:&error];
    //NSLog(@"saved user count  = %d", count);
    if ( count )
    {
        NSArray *fetchResults = [context executeFetchRequest:request error:&error];
        if ( fetchResults != nil )
        {
            User *user = (User*)[fetchResults objectAtIndex:0];
            if (user			!= nil &&
                (user.age		!= nil ||
                 user.gender	!= nil ||
                 user.email		!= nil ||
                 user.homeZIP	!= nil ||
                 user.workZIP	!= nil ||
                 user.schoolZIP	!= nil ||
                 ([user.cyclingFreq intValue] < 4 )))
            {
                NSLog(@"found saved user info");
                self.userInfoSaved = YES;
                response = YES;
            }
            else
                NSLog(@"no saved user info");
        }
        else
        {
            // Handle the error.
            NSLog(@"no saved user");
            if ( error != nil )
                NSLog(@"PersonalInfo viewDidLoad fetch error %@, %@", error, [error localizedDescription]);
        }
    }
    else
        NSLog(@"no saved user");
    
<<<<<<< HEAD
    [request release];
=======
>>>>>>> master
    return response;
}


- (void)hasRecordingBeenInterrupted
{
    if ( [tripManager countUnSavedTrips] )
    {
        [self resetRecordingInProgress];
    }
    else
        NSLog(@"no unsaved trips found");
}


- (void)infoAction:(id)sender
{
    if ( !recording )
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: kInfoURL]];
}


- (void)viewDidLoad
{
    NSLog(@"RecordTripViewController viewDidLoad");
    NSLog(@"Bundle ID: %@", [[NSBundle mainBundle] bundleIdentifier]);
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBarHidden = YES;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    self->mapView.showsUserLocation = YES;
    
    [self.locationManager startUpdatingLocation];
    
<<<<<<< HEAD
    // init map region to Philadelphia
    MKCoordinateRegion region = { { 39.954491, -75.163758 }, { 0.0078, 0.0068 } };
=======
    self->_locationManager.allowsBackgroundLocationUpdates = YES;
    
    // init map region to Petco Park
    MKCoordinateRegion region = { { 32.708282, -117.155739 }, { 0.0078, 0.0068 } };
>>>>>>> master
    [mapView setRegion:region animated:NO];
    
    // setup info button used when showing recorded trips
    infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    infoButton.showsTouchWhenHighlighted = YES;
    
    // Set up the buttons.
    [self.view addSubview:[self createStartButton]];
    [self.view addSubview:[self createNoteButton]];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.isRecording = NO;
    self.recording = NO;
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey: @"recording"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.shouldUpdateCounter = NO;
    
    // Start the location manager.
    [[self getLocationManager] startUpdatingLocation];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // setup the noteManager
<<<<<<< HEAD
    [self initNoteManager:[[[NoteManager alloc] initWithManagedObjectContext:context]autorelease]];
    
    // check if any user data has already been saved and pre-select personal info cell accordingly
    if ( [self hasUserInfoBeenSaved] )
        [self setSaved:YES];
    
    // check for any unsaved trips / interrupted recordings
    [self hasRecordingBeenInterrupted];
    
    NSLog(@"save");
=======
    [self initNoteManager:[[NoteManager alloc] initWithManagedObjectContext:context]];
    
    // check if any user data has already been saved and pre-select personal info cell accordingly
    if ( [self hasUserInfoBeenSaved] )
        [self setSaved:YES];
    
    // check for any unsaved trips / interrupted recordings
    [self hasRecordingBeenInterrupted];
    
    NSLog(@"save");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString( @"Please turn on location services.", @"" ) message:NSLocalizedString( @"This app requires location services to track your routes.", @"" ) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"Cancel", @"" ) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"Settings", @"" ) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                    UIApplicationOpenSettingsURLString]];
    }];
    
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusNotDetermined:
            // Ask the user for permission to use location.
            [self.locationManager requestWhenInUseAuthorization];
            break;
            
        case kCLAuthorizationStatusDenied:
            NSLog(@"Please authorize location services for this SDSU Library under Settings > Privacy.");

            [alertController addAction:cancelAction];
            [alertController addAction:settingsAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            break;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"Okay.  Location will be tracked.");
        case kCLAuthorizationStatusAuthorizedAlways:
            break;
        case kCLAuthorizationStatusRestricted:
            // Nothing to do.
            break;
    }
    
    
    
    
    
>>>>>>> master
}


- (UIButton *)createNoteButton
{
    UIImage *buttonImage = [[UIImage imageNamed:@"whiteButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"whiteButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    [noteButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [noteButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [noteButton setTitleColor:[[UIColor alloc] initWithRed:185.0 / 255 green:91.0 / 255 blue:47.0 / 255 alpha:1.0 ] forState:UIControlStateHighlighted];
    
    //    noteButton.backgroundColor = [UIColor clearColor];
    noteButton.enabled = YES;
    
    [noteButton setTitle:@"Note this..." forState:UIControlStateNormal];
    
    //    noteButton.titleLabel.font = [UIFont boldSystemFontOfSize: 24];
    [noteButton addTarget:self action:@selector(notethis:) forControlEvents:UIControlEventTouchUpInside];
    
    return noteButton;
    
}


// instantiate start button
- (UIButton *)createStartButton
{
    UIImage *buttonImage = [[UIImage imageNamed:@"greenButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"greenButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    [startButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [startButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    startButton.backgroundColor = [UIColor clearColor];
    startButton.enabled = YES;
    
    [startButton setTitle:@"Start" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    startButton.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
    startButton.titleLabel.shadowOffset = CGSizeMake (0, 0);
    startButton.titleLabel.textColor = [UIColor whiteColor];
    [startButton addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    
    return startButton;
}


- (void)displayUploadedTripMap
{
    Trip *trip = tripManager.trip;
    [self resetRecordingInProgress];
    
    //Write Uploaded Trip to Firebase
    // Create a reference to a Firebase location
    NSDateFormatter *formatter;
    NSString        *today;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd/"];
    today = [formatter stringFromDate:[NSDate date]];
    NSMutableString *fireURLC = [[NSMutableString alloc] initWithString:kFireDomain];
    [fireURLC appendString:@"trips-completed/"];
    [fireURLC appendString:today];
    
    Firebase* fEnd = [[Firebase alloc] initWithUrl:fireURLC];
    Firebase* completed = [fEnd childByAutoId];
    NSTimeInterval timeS = [[NSDate date] timeIntervalSince1970] * 1000;
    // NSTimeInterval is defined as double
    NSString *totalPoints = [NSString stringWithFormat: @"%d", (int)trip.coords.count];
    NSNumber *timeSObj = [NSNumber numberWithDouble: timeS];
    [completed setValue:@{@"deviceType": @"ios",@"distance": trip.distance,@"totalPoints": totalPoints,@"totalTime": trip.duration,@"purpose": trip.purpose,@"timestamp": timeSObj}];
    // load map view of saved trip
    MapViewController *mvc = [[MapViewController alloc] initWithTrip:trip];
    [[self navigationController] pushViewController:mvc animated:YES];
    NSLog(@"displayUploadedTripMap");
}


- (void)displayUploadedNote
{
    Note *note = noteManager.note;
    
    // load map view of note
    NoteViewController *mvc = [[NoteViewController alloc] initWithNote:note];
    [[self navigationController] pushViewController:mvc animated:YES];
    NSLog(@"displayUploadedNote");
}


- (void)resetTimer
{
    // invalidate timer
    if ( timer )
    {
        [timer invalidate];
        //[timer release];
        timer = nil;
    }
}


- (void)resetRecordingInProgress
{
    // reset button states
    appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.isRecording = NO;
    recording = NO;
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey: @"recording"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    startButton.enabled = YES;
    UIImage *buttonImage = [[UIImage imageNamed:@"greenButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"greenButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    [startButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [startButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [startButton setTitle:@"Start" forState:UIControlStateNormal];
    
    // reset trip, reminder managers
<<<<<<< HEAD
    [tripManager release];
    NSManagedObjectContext *context = tripManager.managedObjectContext;
    [self initTripManager:[[[TripManager alloc] initWithManagedObjectContext:context] autorelease]];
=======
    NSManagedObjectContext *context = tripManager.managedObjectContext;
    [self initTripManager:[[TripManager alloc] initWithManagedObjectContext:context]];
>>>>>>> master
    tripManager.dirty = YES;
    
    [self resetCounter];
    [self resetTimer];
}


#pragma mark UIActionSheet delegate methods


<<<<<<< HEAD
// NOTE: implement didDismissWithButtonIndex to process after sheet has been dismissed
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"actionSheet clickedButtonAtIndex %ld", (long)buttonIndex);
    switch ( buttonIndex )
    {
        case 0:
        {
            NSLog(@"Discard!!!!");
            
            // actually discard the trip
            [self.tripManager discardTrip];
            
            [self resetRecordingInProgress];
            
            break;
        }
        case 1:{
            [self save];
            break;
        }
        default:{
            NSLog(@"Cancel");
            // re-enable counter updates
            shouldUpdateCounter = YES;
            break;
        }
    }
}


=======
>>>>>>> master
// called if the system cancels the action sheet (e.g. homescreen button has been pressed)
- (void)actionSheetCancel:(UIAlertController *)actionSheet
{
    NSLog(@"actionSheetCancel");
}


#pragma mark UIAlertViewDelegate methods


// NOTE: method called upon closing save error / success alert
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 101:
        {
            NSLog(@"recording interrupted didDismissWithButtonIndex: %ld", (long)buttonIndex);
            switch (buttonIndex) {
                case 0:
                    // new trip => do nothing
                    break;
                case 1:
                default:
                    // continue => load most recent unsaved trip
                    [tripManager loadMostRecentUnSavedTrip];
                    
                    // update UI to reflect trip once loading has completed
                    [self setCounterTimeSince:tripManager.trip.start
                                     distance:[tripManager getDistanceEstimate]];
                    
                    startButton.enabled = YES;
                    
                    [startButton setTitle:@"Continue" forState:UIControlStateNormal];
                    break;
            }
        }
            break;
        case 201:
        {
            NSLog(@"save cancelled because no co-ordinates in trip");
            // discard the empty trip
            [self.tripManager discardTrip];
            [self resetRecordingInProgress];
        }
            break;
        default:
        {
            NSLog(@"saving didDismissWithButtonIndex: %ld", (long)buttonIndex);
            
            // keep a pointer to our trip to pass to map view below
            Trip *trip = tripManager.trip;
            [self resetRecordingInProgress];
            
            // load map view of saved trip
            MapViewController *mvc = [[MapViewController alloc] initWithTrip:trip];
            [[self navigationController] pushViewController:mvc animated:YES];
<<<<<<< HEAD
            [mvc release];
=======
>>>>>>> master
        }
            break;
    }
}


- (NSDictionary *)newTripTimerUserInfo
{
<<<<<<< HEAD
    return [[NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], @"StartDate",
             tripManager, @"TripManager", nil ] retain ];
=======
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], @"StartDate",
             tripManager, @"TripManager", nil ];
>>>>>>> master
}


//- (NSDictionary *)continueTripTimerUserInfo
//{
//	if ( tripManager.trip && tripManager.trip.start )
//		return [NSDictionary dictionaryWithObjectsAndKeys:tripManager.trip.start, @"StartDate",
//				tripManager, @"TripManager", nil ];
//	else {
//		NSLog(@"WARNING: tried to continue trip timer but failed to get trip.start date");
//		return [self newTripTimerUserInfo];
//	}
//
//}


// handle start button action
- (IBAction)start:(UIButton *)sender
{
    
    if(recording == NO)
    {
        NSLog(@"start");
        
        // start the timer if needed
        if ( timer == nil )
        {
            [self resetCounter];
            timer = [NSTimer scheduledTimerWithTimeInterval:kCounterTimeInterval
                                                     target:self selector:@selector(updateCounter:)
<<<<<<< HEAD
                                                   userInfo:[[self newTripTimerUserInfo] autorelease] repeats:YES];
=======
                                                   userInfo:[self newTripTimerUserInfo] repeats:YES];
>>>>>>> master
        }
        
        UIImage *buttonImage = [[UIImage imageNamed:@"blueButton.png"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
        UIImage *buttonImageHighlight = [[UIImage imageNamed:@"blueButtonHighlight.png"]
                                         resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
        [startButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [startButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
        [startButton setTitle:@"Save" forState:UIControlStateNormal];
        
        // set recording flag so future location updates will be added as coords
        appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.isRecording = YES;
        recording = YES;
        // Write to Firebase
        // Create a reference to a Firebase location
        NSDateFormatter *formatter;
        NSString        *today;
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd/"];
        today = [formatter stringFromDate:[NSDate date]];
        NSMutableString *fireURL = [[NSMutableString alloc] initWithString:kFireDomain];
        [fireURL appendString:@"trips-started/"];
        [fireURL appendString:today];
        
        Firebase* fStart = [[Firebase alloc] initWithUrl:fireURL];
        Firebase* timeStart = [fStart childByAutoId];
        //NSLog(@"%@",fireURL);
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
        // NSTimeInterval is defined as double
        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
        [timeStart setValue:timeStampObj];
        
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey: @"recording"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // set flag to update counter
        shouldUpdateCounter = YES;
    }
    // do the saving
    else
    {
        NSLog(@"User Press Save Button");
        
        if ([tripManager.coords count] < 1) {
            // no data to upload; bail now
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No data to upload" message:@"No co-ordinates have been logged for this trip yet." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            alert.tag = 201;
            [alert show];
            return;
        }
        
        UIAlertController* saveActionSheet = [UIAlertController alertControllerWithTitle:@"WEBIKESD SAVE"
                                                                             message:@"Upload Bike Trip?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* saveAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               [self save];
                                                           }];
        
        UIAlertAction* discardAction = [UIAlertAction actionWithTitle:@"Discard Trip" style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction * action) {
                                                                  [self.tripManager discardTrip];
                                                                  [self resetRecordingInProgress];
                                                              }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {
                                                                 shouldUpdateCounter = YES;
                                                             }];
        
        
        [saveActionSheet addAction:saveAction];
        [saveActionSheet addAction:discardAction];
        [saveActionSheet addAction:cancelAction];
        [self presentViewController:saveActionSheet animated:YES completion:nil];
    }
    
}
- (void)save
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey: @"pickerCategory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // go directly to TripPurpose, user can cancel from there
    if ( YES )
    {
        // Trip Purpose
        NSLog(@"INIT + PUSH");
        PickerViewController *tripPurposePickerView = [[PickerViewController alloc]
                                                       //initWithPurpose:[tripManager getPurposeIndex]];
                                                       initWithNibName:@"TripPurposePicker" bundle:nil];
        [tripPurposePickerView setDelegate:self];
        //[[self navigationController] pushViewController:pickerViewController animated:YES];
<<<<<<< HEAD
        [self.navigationController presentModalViewController:tripPurposePickerView animated:YES];
        [tripPurposePickerView release];
=======
        [self.navigationController presentViewController:tripPurposePickerView animated:YES completion:nil];
>>>>>>> master
    }
    
    // prompt to confirm first
    else
    {
        // pause updating the counter
        shouldUpdateCounter = NO;
        
        // construct purpose confirmation string
        NSString *purpose = nil;
        if ( tripManager != nil )
            purpose = [self getPurposeString:[tripManager getPurposeIndex]];
<<<<<<< HEAD
        
        NSString *confirm = [NSString stringWithFormat:@"Stop recording & save this trip?"];
        
        // present action sheet
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:confirm
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Save", nil];
        
        actionSheet.actionSheetStyle		= UIActionSheetStyleBlackTranslucent;
        UIViewController *pvc = self.parentViewController;
        UITabBarController *tbc = (UITabBarController *)pvc.parentViewController;
        
        [actionSheet showFromTabBar:tbc.tabBar];
        [actionSheet release];
=======

        UIAlertController* actionSheet = [UIAlertController alertControllerWithTitle:@"My Alert"
                                                                       message:@"This is an alert."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* saveAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self save];
                                                              }];
        
        UIAlertAction* discardAction = [UIAlertAction actionWithTitle:@"Discard Trip" style:UIAlertActionStyleDestructive
                                                           handler:^(UIAlertAction * action) {
                                                               [self.tripManager discardTrip];
                                                               [self resetRecordingInProgress];
                                                           }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * action) {
                                                                  shouldUpdateCounter = YES;
                                                              }];
        
        
        [actionSheet addAction:saveAction];
        [actionSheet addAction:discardAction];
        [actionSheet addAction:cancelAction];
        [self presentViewController:actionSheet animated:YES completion:nil];
        
>>>>>>> master
    }
    
}


-(IBAction)notethis:(id)sender{
    [[NSUserDefaults standardUserDefaults] setInteger:3 forKey: @"pickerCategory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"Note This");
    
    [noteManager createNote];
    
    if (myLocation){
        [noteManager addLocation:myLocation];
    }
    
    // go directly to TripPurpose, user can cancel from there
    if ( YES )
    {
        // Trip Purpose
        NSLog(@"INIT + PUSH");
<<<<<<< HEAD
        
        
        PickerViewController *notePickerView = [[PickerViewController alloc]
                                                //initWithPurpose:[tripManager getPurposeIndex]];
                                                initWithNibName:@"TripPurposePicker" bundle:nil];
        [notePickerView setDelegate:self];
        //[[self navigationController] pushViewController:pickerViewController animated:YES];
        [self.navigationController presentModalViewController:notePickerView animated:YES];
=======
        
>>>>>>> master
        
        PickerViewController *notePickerView = [[PickerViewController alloc]
                                                //initWithPurpose:[tripManager getPurposeIndex]];
                                                initWithNibName:@"TripPurposePicker" bundle:nil];
        [notePickerView setDelegate:self];
        //[[self navigationController] pushViewController:pickerViewController animated:YES];
        //[self.navigationController presentModalViewController:notePickerView animated:YES]; deprecated
        [self presentViewController:notePickerView animated:YES completion:nil];
        //add location information
        
<<<<<<< HEAD
        [notePickerView release];
=======
>>>>>>> master
    }
    
    // prompt to confirm first
    else
    {
        // pause updating the counter
        shouldUpdateCounter = NO;
        
        // construct purpose confirmation string
        NSString *purpose = nil;
        if ( tripManager != nil )
            purpose = [self getPurposeString:[tripManager getPurposeIndex]];
        
<<<<<<< HEAD
        NSString *confirm = [NSString stringWithFormat:@"Stop recording & save this trip?"];
        
        // present action sheet
=======
        
        
        // present action sheet
        /*Changing from UIActionSheet
         NSString *confirm = [NSString stringWithFormat:@"Stop recording & save this trip?"];
>>>>>>> master
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:confirm
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Save", nil];
        
        actionSheet.actionSheetStyle		= UIActionSheetStyleBlackTranslucent;
        UIViewController *pvc = self.parentViewController;
        UITabBarController *tbc = (UITabBarController *)pvc.parentViewController;
        
        [actionSheet showFromTabBar:tbc.tabBar];
        [actionSheet release];
<<<<<<< HEAD
=======
         */
        UIAlertController* save = [UIAlertController alertControllerWithTitle:@"WEBIKESD SAVE"
                                                                             message:@"Note This?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* saveAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               [self save];
                                                           }];
        
        UIAlertAction* discardAction = [UIAlertAction actionWithTitle:@"Discard Note." style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction * action) {
                                                                  [self.tripManager discardTrip];
                                                                  [self resetRecordingInProgress];
                                                              }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {
                                                                 shouldUpdateCounter = YES;
                                                             }];
        
        
        [save addAction:saveAction];
        [save addAction:discardAction];
        [save addAction:cancelAction];
        [self presentViewController:save animated:YES completion:nil];
         
         
>>>>>>> master
    }
}


- (void)resetCounter
{
    if ( timeCounter != nil )
        timeCounter.text = @"00:00:00";
    
    if ( distCounter != nil )
        distCounter.text = @"0 mi";
}


- (void)setCounterTimeSince:(NSDate *)startDate distance:(CLLocationDistance)distance
{
    if ( timeCounter != nil )
    {
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:startDate];
        
        static NSDateFormatter *inputFormatter = nil;
        if ( inputFormatter == nil )
<<<<<<< HEAD
            inputFormatter = [[[NSDateFormatter alloc] init] autorelease];
=======
            inputFormatter = [[NSDateFormatter alloc] init];
>>>>>>> master
        
        [inputFormatter setDateFormat:@"HH:mm:ss"];
        NSDate *fauxDate = [inputFormatter dateFromString:@"00:00:00"];
        [inputFormatter setDateFormat:@"HH:mm:ss"];
<<<<<<< HEAD
        NSDate *outputDate = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:fauxDate] autorelease];
=======
        NSDate *outputDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:fauxDate];
>>>>>>> master
        
        timeCounter.text = [inputFormatter stringFromDate:outputDate];
    }
    
    if ( distCounter != nil )
        distCounter.text = [NSString stringWithFormat:@"%.1f mi", distance / 1609.344];
    ;
}


// handle start button action
- (void)updateCounter:(NSTimer *)theTimer
{
    //NSLog(@"updateCounter");
    if ( shouldUpdateCounter )
    {
        NSDate *startDate = [[theTimer userInfo] objectForKey:@"StartDate"];
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:startDate];
        
        static NSDateFormatter *inputFormatter = nil;
        if ( inputFormatter == nil )
            inputFormatter = [[NSDateFormatter alloc] init];
        
        [inputFormatter setDateFormat:@"HH:mm:ss"];
        NSDate *fauxDate = [inputFormatter dateFromString:@"00:00:00"];
        [inputFormatter setDateFormat:@"HH:mm:ss"];
<<<<<<< HEAD
        NSDate *outputDate = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:fauxDate] autorelease];
=======
        NSDate *outputDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:fauxDate];
>>>>>>> master
        
        //NSLog(@"Timer started on %@", startDate);
        //NSLog(@"Timer started %f seconds ago", interval);
        //NSLog(@"elapsed time: %@", [inputFormatter stringFromDate:outputDate] );
        
        //self.timeCounter.text = [NSString stringWithFormat:@"%.1f sec", interval];
        self.timeCounter.text = [inputFormatter stringFromDate:outputDate];
    }
    
}


- (void)viewWillAppear:(BOOL)animated
{
    // listen for keyboard hide/show notifications so we can properly adjust the table's height
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSLog(@"keyboardWillShow");
}


- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSLog(@"keyboardWillHide");
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (NSString *)updatePurposeWithString:(NSString *)purpose
{
    // only enable start button if we don't already have a pending trip
    if ( timer == nil )
        startButton.enabled = YES;
    
    startButton.hidden = NO;
    
    return purpose;
}


- (NSString *)updatePurposeWithIndex:(unsigned int)index
{
    return [self updatePurposeWithString:[tripManager getPurposeString:index]];
}


#pragma mark UINavigationController


- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if ( viewController == self )
    {
        //NSLog(@"willShowViewController:self");
        self.title = @"Record New Trip";
    }
    else
    {
        //NSLog(@"willShowViewController:else");
        self.title = @"Back";
        self.tabBarItem.title = @"Record New Trip"; // important to maintain the same tab item title
    }
}


#pragma mark UITabBarControllerDelegate


- (BOOL)tabBarController:(UITabBarController *)tabBarController
shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}


#pragma mark PersonalInfoDelegate methods


- (void)setSaved:(BOOL)value
{
    NSLog(@"setSaved");
    // no-op
    
}


#pragma mark TripPurposeDelegate methods


- (NSString *)setPurpose:(long)index
{
    NSString *purpose = [tripManager setPurpose:index];
    NSLog(@"setPurpose: %@", purpose);
    
<<<<<<< HEAD
    //[self.navigationController popViewControllerAnimated:YES];
=======
    [self.navigationController popViewControllerAnimated:YES];
>>>>>>> master
    
    return [self updatePurposeWithString:purpose];
}


- (NSString *)getPurposeString:(long)index
{
    return [tripManager getPurposeString:index];
}


- (void)didCancelPurpose
{
<<<<<<< HEAD
    [self.navigationController dismissModalViewControllerAnimated:YES];
=======
    //[self.navigationController dismissModalViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
>>>>>>> master
    appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.isRecording = YES;
    recording = YES;
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey: @"recording"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    shouldUpdateCounter = YES;
}


- (void)didCancelNote
{
<<<<<<< HEAD
    [self.navigationController dismissModalViewControllerAnimated:YES];
=======
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
>>>>>>> master
    appDelegate = [[UIApplication sharedApplication] delegate];
}


- (void)didPickPurpose:(long)index
{
    //[self.navigationController dismissModalViewControllerAnimated:YES];
    // update UI
    appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.isRecording = NO;
    recording = NO;
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey: @"recording"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    startButton.enabled = YES;
    [self resetTimer];
    
    [tripManager setPurpose:index];
    //[tripManager promptForTripNotes];
    //do something here: may change to be the save as a separate view. Not prompt.
}

- (void)didEnterTripDetails:(NSString *)details{
    [tripManager saveNotes:details];
    NSLog(@"Trip Added details: %@",details);
}

- (void)didTakeTransit {
    [tripManager saveTookTransit];
    NSLog(@"Noted rider took public transit in RecordTripViewController.");
}

- (void)saveTrip{
    [tripManager saveTrip];
    NSLog(@"Save trip");
}

- (void)didPickNoteType:(NSNumber *)index
{	
    [noteManager.note setNote_type:index];
    NSLog(@"Added note type: %d", [noteManager.note.note_type intValue]);
    //do something here: may change to be the save as a separate view. Not prompt.
}

- (void)didEnterNoteDetails:(NSString *)details{
    [noteManager.note setDetails:details];
    NSLog(@"Note Added details: %@", noteManager.note.details);
}

- (void)didSaveImage:(NSData *)imgData{
    [noteManager.note setImage_data:imgData];
    NSLog(@"Added image, Size of Image(bytes):%lu", (unsigned long)[imgData length]);
}

- (void)getTripThumbnail:(NSData *)imgData{
    [tripManager.trip setThumbnail:imgData];
    NSLog(@"Trip Thumbnail, Size of Image(bytes):%lu", (unsigned long)[imgData length]);
}

- (void)getNoteThumbnail:(NSData *)imgData{
    [noteManager.note setThumbnail:imgData];
    NSLog(@"Note Thumbnail, Size of Image(bytes):%lu", (unsigned long)[imgData length]);
}

- (void)saveNote{
    [noteManager saveNote];
    NSLog(@"Save note");
}




#pragma mark RecordingInProgressDelegate method


- (Trip *)getRecordingInProgress
{
    if ( recording )
        return tripManager.trip;
    else
        return nil;
}


- (void)dealloc {
    
    appDelegate.locationManager = nil;
    self.timer = nil;
    self.recording = nil;
    self.shouldUpdateCounter = nil;
    self.userInfoSaved = nil;
    speedCounter = nil;
    
    //    [appDelegate.locationManager release];
<<<<<<< HEAD
    [appDelegate release];
    [infoButton release];
    [saveButton release];
    [startButton release];
    [noteButton release];
    [timeCounter release];
    [distCounter release];
    [speedCounter release];
    [saveActionSheet release];
    [timer release];
    [opacityMask release];
    [parentView release];
    [tripManager release];
    [noteManager release];
    [myLocation release];
    
    [managedObjectContext release];
    [mapView release];
    
    [super dealloc];
=======
    
    
>>>>>>> master
}

@end