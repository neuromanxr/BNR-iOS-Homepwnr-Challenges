//
//  BNRDetailViewController.m
//  BNR-iOS-Homepwnr
//
//  Created by Kelvin Lee on 7/3/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "BNRAppDelegate.h"
#import "BNRAssetTypeViewController.h"
#import "BNRPopoverBackgroundView.h"
#import "BNRChangeDateViewController.h"
#import "BNRDetailViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "BNRImageStore.h"
#import "BNROverlayView.h"

@interface BNRDetailViewController () <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, DismissDelegate>

@property (strong, nonatomic) UIPopoverController *imagePickerPopover;
@property (strong, nonatomic) UIPopoverController *assetPickerPopover;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *assetTypeButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation BNRDetailViewController

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.item.itemKey forKey:@"item.itemKey"];
    
    // save changes into item
    self.item.itemName = self.nameField.text;
    self.item.serialNumber = self.serialNumberField.text;
    self.item.valueInDollars = [self.valueField.text intValue];
    
    // have store save changes to disk
    [[BNRItemStore sharedStore] saveChanges];
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSString *itemKey = [coder decodeObjectForKey:@"item.itemKey"];
    
    for (BNRItem *item in [[BNRItemStore sharedStore] allItems]) {
        if ([itemKey isEqualToString:item.itemKey]) {
            self.item = item;
            break;
        }
    }
    [super decodeRestorableStateWithCoder:coder];
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)path coder:(NSCoder *)coder
{
    BOOL isNew = NO;
    if ([path count] == 3) {
        isNew = YES;
    }
    return [[self alloc] initForNewItem:isNew];
}

- (void)didTap
{
    [self.assetPickerPopover dismissPopoverAnimated:YES];
    
    // update the assetTypeButton title when the popover is dismissed
    NSString *typeLabel = [self.item.assetType valueForKey:@"label"];
    if (!typeLabel) {
        typeLabel = @"None";
    }
    
    self.assetTypeButton.title = [NSString stringWithFormat:@"Type: %@", typeLabel];
}

- (void)updateFonts
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
    self.dateLabel.font = font;
    
    self.nameField.font = font;
    self.serialNumberField.font = font;
    self.valueField.font = font;
}

- (IBAction)showAssetTypePicker:(id)sender
{
    [self.view endEditing:YES];
    
    BNRAssetTypeViewController *avc = [[BNRAssetTypeViewController alloc] init];
    avc.item = self.item;
    
    avc.delegate = self;
    
//    [self.navigationController pushViewController:avc animated:YES];
    
    // bronze challenge ch23
    // place asset picker on screen
    // check for iPad device before instantiating the popover controller
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        // create a navigation controller with asset type view controller
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:avc];
        
        // create a new popover controller that will display the navigation controller
        self.assetPickerPopover = [[UIPopoverController alloc] initWithContentViewController:nc];
        
        self.assetPickerPopover.delegate = self;
        
        // display the popover controller
        [self.assetPickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [self presentViewController:avc animated:YES completion:nil];
    }
    // bronze challenge ch23 end
}

- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
}

- (instancetype)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
        
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self selector:@selector(updateFonts) name:UIContentSizeCategoryDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
}

- (void)save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)cancel:(id)sender
{
    // if the user cancelled, then remove the BNRItem from the store
    [[BNRItemStore sharedStore] removeItem: self.item];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initForNewItem:"
                                 userInfo:nil];
}

- (IBAction)takePicture:(id)sender
{
    // to prevent crashing when popover is visible and the button is pressed
    if ([self.imagePickerPopover isPopoverVisible]) {
        // if the popover is already up, get rid of it
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];

    // if the device has a camera, take a picture, otherwise,
    // just pick from photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        // gold challenge ch11
        imagePicker.showsCameraControls = YES;
        CGRect frame = [UIScreen mainScreen].bounds;
        BNROverlayView *ov = [[BNROverlayView alloc] initWithFrame:frame];
        imagePicker.cameraOverlayView = ov;
        NSLog(@"%f", imagePicker.view.bounds.size.width);
        // gold challenge ch11 end
        
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    // set instance of BNRDetailViewController to be the image picker's delegate
    imagePicker.delegate = self;
    
    // bronze challenge ch11
    // allow editing after picking an image
    imagePicker.allowsEditing = YES;
    
    // present view controller modally
    // place image picker on screen
//    [self presentViewController:imagePicker animated:YES completion:nil];
    
    // place image picker on screen
    // check for iPad device before instantiating the popover controller
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        // create a new popover controller that will display the imagePicker
        self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        
        self.imagePickerPopover.delegate = self;
        
        // gold challenge ch17
        // subclass for custom popover view
        self.imagePickerPopover.popoverBackgroundViewClass = [BNRPopoverBackgroundView class];
        
        // display the popover controller
        // is the camera bar button item
        [self.imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

// silver challenge ch11
- (IBAction)clearPicture:(id)sender
{
    NSLog(@"imageView %@", self.imageView.image);
    if (self.item.itemKey) {
        [[BNRImageStore sharedStore] deleteImageForKey:self.item.itemKey];
        
        self.imageView.image = nil;
    }
    NSLog(@"imageView %@", self.imageView.image);
}

// gold challenge ch10
- (IBAction)changeDate:(id)sender
{
    BNRChangeDateViewController *cd = [[BNRChangeDateViewController alloc] init];
    
    // pass the BNRItem items to BNRChangeDateViewController
    // must have or will not work, items in cd would be null
    cd.item = self.item;
    
    // push BNRChangeDateViewController to the navigation controller
    [self.navigationController pushViewController:cd animated:YES];
}
// gold challenge ch10 end

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // get picked image from info dictionary
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // create the thumbnail
    [self.item setThumbnailFromImage:image];
    
    // store the image in the BNRImageStore for this key
    [[BNRImageStore sharedStore] setImage:image
                                   forKey:self.item.itemKey];
    
    // put the image onto the screen in our image view
    self.imageView.image = image;
    
    // take image picker off the screen - you must call this dismiss method
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    // do I have a popover?
    if (self.imagePickerPopover) {
        // dismiss it
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
    } else {
        // dismiss the modal image picker
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover");
    self.imagePickerPopover = nil;
}

- (void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation
{
    // is it an iPad? No preparation necessary
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }
    
    // is it a landscape?
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    } else {
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self prepareViewsForOrientation:toInterfaceOrientation];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIInterfaceOrientation io = [[UIApplication sharedApplication] statusBarOrientation];
    [self prepareViewsForOrientation:io];
    
    BNRItem *item = self.item;
    
    self.nameField.text = item.itemName;
    self.serialNumberField.text = item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    // set delegate of valueField to this view controller
    self.valueField.delegate = self;
    // change the keyboard type for valueField
    // bronze challenge
    self.valueField.keyboardType = UIKeyboardTypeNumberPad;
    // change the return key type
    self.valueField.returnKeyType = UIReturnKeyGo;
    
    // you need a NSDateFormatter that will turn a date into a simple date string
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }

    // use filtered NSDate object to set dateLabel contents
    self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
    
    NSString *imageKey = self.item.itemKey;
    
    // get the image for its image key from the image store
    UIImage *imageToDisplay = [[BNRImageStore sharedStore] imageForKey:imageKey];
    
    // use that image to put on the screen in the imageView
    self.imageView.image = imageToDisplay;
    
    NSString *typeLabel = [self.item.assetType valueForKey:@"label"];
    if (!typeLabel) {
        typeLabel = NSLocalizedString(@"None", @"Type label None");
    }
    
    self.assetTypeButton.title = [NSString stringWithFormat:NSLocalizedString(@"Type: %@", @"Asset type button"), typeLabel];
    
    // update the fonts
    [self updateFonts];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:nil];
    
    // contentMode of the image view in the XIB was aspect fit
    iv.contentMode = UIViewContentModeScaleAspectFit;
    
    // do not produce a translated constraint for this view
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    
    // the image view was a subview of the view
    [self.view addSubview:iv];
    
    // the image view was pointed to by the imageView property
    self.imageView = iv;
    
    // set the vertical priorities to be less than those of other subviews
    [self.imageView setContentHuggingPriority:200 forAxis:UILayoutConstraintAxisVertical];
    [self.imageView setContentCompressionResistancePriority:700 forAxis:UILayoutConstraintAxisVertical];
    
    // dictionary of names of views
    NSDictionary *nameMap = @{@"imageView" : self.imageView,
                              @"dateLabel" : self.dateLabel,
                              @"toolbar" : self.toolbar};
    
    // imageView is 0 pts from superview at left and right edges
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:0 metrics:nil views:nameMap];
    
    // imageView is 8 pts from dateLabel at its top edge
    // and 8 pts from toolbar at its bottom edge
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolbar]" options:0 metrics:nil views:nameMap];
    
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticalConstraints];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // clear first responder
    [self.view endEditing:YES];
    
    // "save" changes to item
    BNRItem *item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialNumberField.text;
    
    int newValue = [self.valueField.text intValue];
    
    // is it changed?
    if (newValue != item.valueInDollars) {
        // put it in the item
        item.valueInDollars = newValue;
        
        // store it as the default value for the next item
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:newValue forKey:BNRNextItemValuePrefsKey];
    }
}

// silver challenge ch10
// hide the keyboard when done with input
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)setItem:(BNRItem *)item
{
    _item = item;
    self.navigationItem.title = _item.itemName;
}

@end
