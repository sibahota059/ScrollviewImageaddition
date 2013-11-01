//
//  SPHViewController.m
//  AddremovePicture
//
//  Created by Siba Prasad Hota  on 11/1/13.
//  Copyright (c) 2013 Wemakeappz. All rights reserved.
//

#import "SPHViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>

@interface SPHViewController ()

@end

@implementation SPHViewController
@synthesize imgPicker;
@synthesize popOver;
@synthesize imageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    x=0;
    ImageArray=[[NSMutableArray alloc]init];
    
 
    self.horizontalScroll.contentSize = CGSizeMake(self.view.frame.size.width,110);
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)staticBtn:(id)sender {
    
    if (ImageArray.count>29) {
        
        [self insertImageAtindex:ImageArray.count imageis:[UIImage imageNamed:[NSString stringWithFormat:@"all_icon%d.png",ImageArray.count-29]]];
    }
    else{
        [self insertImageAtindex:ImageArray.count imageis:[UIImage imageNamed:[NSString stringWithFormat:@"all_icon%d.png",ImageArray.count+1]]];
    }
     
}

- (IBAction)dynamicpressed:(id)sender {
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Choose An Option" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Capture from camera", @"Select from saved Album", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self capturebycamera];
    }
    else if (buttonIndex == 1)
        
        {
            [self getfromattachment];
        }
}


-(void)capturebycamera
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = NO;
        
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            
            [self presentViewController:imagePicker
                               animated:YES completion:nil];
        }
        else
        {
            
            if ([self.popOver isPopoverVisible]) {
                [self.popOver dismissPopoverAnimated:YES];
                
            }
            else
            {
                self.popOver = [[UIPopoverController alloc]
                                initWithContentViewController:imagePicker];
                
                popOver.delegate = self;
                
                [self.popOver
                 presentPopoverFromRect: imageView.bounds inView:imageView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                
                
            }
        }
        
        newMedia = YES;
    }    else
        [self showWarningAlertWithText:@"Camera Not Available" title:@"Oops!"];
    
}

-(void)showWarningAlertWithText:(NSString *)msgText title:(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msgText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

-(void)getfromattachment
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imgPicker.mediaTypes = [NSArray arrayWithObjects:
                                (NSString *) kUTTypeImage,
                                nil];
        imagePicker.allowsEditing = NO;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            
            [self presentViewController:imagePicker
                               animated:YES completion:nil];
        }
        else
        {
            if ([self.popOver isPopoverVisible]) {
                [self.popOver dismissPopoverAnimated:YES];
                
            }
            else
            {
                self.popOver = [[UIPopoverController alloc]
                                initWithContentViewController:imagePicker];
                
                popOver.delegate = self;
                
                [self.popOver
                 presentPopoverFromRect: imageView.bounds inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                
                
                
            }
            
            
        }
        
        newMedia = NO;
    }
    
    
}



-(void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        
    }
}
-(void)insertImageAtindex:(NSInteger)rowNumber imageis:(UIImage*)imageis
{
    
    
    [ImageArray addObject:imageis];
    
    NSLog(@"ImageArrayCount=%d",ImageArray.count);
    
    [self scrollViewReloaddata];
    
}

-(void)DeleteImageAtindex:(NSInteger)rowNumber
{
    [ImageArray removeObjectAtIndex:rowNumber];
    
    [self scrollViewReloaddata];
    
}

-(void)scrollViewReloaddata
{
    [self removeAllsubviewOfscrollView];
    x=0;
    
    for (int xy=0; xy<ImageArray.count; xy++) {
        
        
        UIImage *imageadd= (UIImage*)[ImageArray objectAtIndex:xy];
        
        NSLog(@"Image=%@",imageadd);
        
        UIImageView *scrollImageView=[[UIImageView alloc]initWithFrame:CGRectMake(x,10,100,98)];
        [ self.horizontalScroll addSubview:scrollImageView];
        
        scrollImageView.layer.cornerRadius =2.0;
        scrollImageView.clipsToBounds = YES;
        scrollImageView.layer.borderWidth = 1.0;
        scrollImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        UIButton *scrollImagebutton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        scrollImagebutton.frame=CGRectMake(x+85,0,25,25);
        [scrollImagebutton setImage:[UIImage imageNamed:@"close_button"] forState:UIControlStateNormal];
        
        // [scrollImagebutton setTitle:@"Delete" forState:UIControlStateNormal];
        scrollImagebutton.tag=xy;
        [scrollImagebutton addTarget:self action:@selector(DeleteImageofscrollview:) forControlEvents:UIControlEventTouchUpInside];
        
        [ self.horizontalScroll addSubview:scrollImagebutton];
        scrollImageView.image=imageadd;
        scrollImageView.tag=xy;
        
        x+=110;
        
        if (xy>2) {
            
            self.horizontalScroll.contentSize=CGSizeMake(x,110);
            
            [self.horizontalScroll setContentOffset:CGPointMake(x-300, 0) animated:YES];
            
        }
        
        
        
    }
    
    
    
}

-(IBAction)DeleteImageofscrollview:(id)sender
{
    int xy=[sender tag];
    
    [self DeleteImageAtindex:xy];
    
}

-(void)removeAllsubviewOfscrollView
{
    for(UIView *subview in [self.horizontalScroll subviews]) {
        if([subview isKindOfClass:[UIButton class]]) {
            [subview removeFromSuperview];
        } else if([subview isKindOfClass:[UIImageView class]]){
            
            [subview removeFromSuperview];
            
        }
        else{
            // Do nothing - not a UIButton or subclass instance
        }
    }
}


-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        NSString *mediaType = [info
                               objectForKey:UIImagePickerControllerMediaType];
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
            imageView.image = [info
                              objectForKey:UIImagePickerControllerOriginalImage];
            
          
            
            
            
            [self insertImageAtindex:ImageArray.count imageis:imageView.image];
            
            
            if (newMedia)
                UIImageWriteToSavedPhotosAlbum(imageView.image,
                                               self,
                                               @selector(image:finishedSavingWithError:contextInfo:),
                                               nil);
        }
        else //if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
        {
            
            NSLog(@"Got Movie here.");
            
            // Code here to support video if enabled
        }
        
        
    }else
    {
        if ([self.popOver isPopoverVisible]) {
            [self.popOver dismissPopoverAnimated:YES];
            
        }
        
        
        NSString *mediaType = [info
                               objectForKey:UIImagePickerControllerMediaType];
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
            imageView.image = [info
                              objectForKey:UIImagePickerControllerOriginalImage];
            
            
        
            
            
            [self insertImageAtindex:ImageArray.count imageis:imageView.image];
            
            
            
            // [self uploadToServer];
            
            
            if (newMedia)
                UIImageWriteToSavedPhotosAlbum(imageView.image,
                                               self,
                                               @selector(image:finishedSavingWithError:contextInfo:),
                                               nil);
        }
        else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
        {
            // Code here to support video if enabled
        }
        
        
    }
    
    
    
    
    
}


-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}




@end
