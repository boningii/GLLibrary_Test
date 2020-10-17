//
//  ViewController.h
//  GLLibrary_Test
//
//  Created by Boning Xu on 2017/5/8.
//  Copyright © 2017年 Boning Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *mBtnTransY;
@property (weak, nonatomic) IBOutlet UIButton *mBtnContrast;
@property (weak, nonatomic) IBOutlet UIButton *mBtnLumination;
@property (weak, nonatomic) IBOutlet UIButton *mBtnContrastLumination;
@property (weak, nonatomic) IBOutlet UIButton *mBtnSaturationRate;
@property (weak, nonatomic) IBOutlet UIButton *mBtnNearestScale;
@property (weak, nonatomic) IBOutlet UIButton *mBtnBoxScale;
@property (weak, nonatomic) IBOutlet UIButton *mBtnBilinearScale;
@property (weak, nonatomic) IBOutlet UIButton *mBtnBicubicScale;
@property (weak, nonatomic) IBOutlet UIButton *mBtnLanczosScale;
@property (weak, nonatomic) IBOutlet UIImageView *mCpuResult;
@property (weak, nonatomic) IBOutlet UIImageView *mGpuResult;
@property (weak, nonatomic) IBOutlet UITextView *mTxtLogOutput;


- (IBAction)OnYTransition:(id)sender;
- (IBAction)OnContrast:(id)sender;
- (IBAction)OnLumination:(id)sender;
- (IBAction)OnContrastLumination:(id)sender;
- (IBAction)OnSaturationRate:(id)sender;
- (IBAction)onBoxScale:(id)sender;
//- (IBAction)onNearestScale:(id)sender;
- (IBAction)onBilinearScale:(id)sender;
- (IBAction)onBicubicScale:(id)sender;
- (IBAction)onLanczosScale:(id)sender;

- (void)timerUpdate;

@end

