//
//  SPHViewController.h
//  AddremovePicture
//
//  Created by Siba Prasad Hota  on 11/1/13.
//  Copyright (c) 2013 Wemakeappz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPHViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,
UIActionSheetDelegate,UIPopoverControllerDelegate>
{
     BOOL newMedia;
     int x;
     NSMutableArray *ImageArray;
}
@property (nonatomic, retain) UIImagePickerController *imgPicker;
@property (weak, nonatomic) IBOutlet UIScrollView *horizontalScroll;
@property (nonatomic, strong) UIPopoverController *popOver;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)staticBtn:(id)sender;
- (IBAction)dynamicpressed:(id)sender;

@end
