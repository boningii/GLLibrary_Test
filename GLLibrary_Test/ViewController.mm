//
//  ViewController.m
//  GLLibrary_Test
//
//  Created by Boning Xu on 2017/5/8.
//  Copyright Boning Xu. All rights reserved.
//

#import "ViewController.h"

#include "glProcessor.h"
#include "LogOutputer.h"
#include "FileUtils.h"


@interface ViewController ()
@property GL_FUNC_DEF cacheMode;// = GLF_NONE;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [NSTimer scheduledTimerWithTimeInterval:0.05f
                                     target:self
                                   selector:@selector(timerUpdate)
                                   userInfo:nil
                                    repeats:YES];
    
    // Set up.
    self.cacheMode = GLF_NONE;
}

- (void)timerUpdate {
#if 0
    for (auto&strLine : LogManager::singleton()->mLogPool) {
        outStr += strLine;
        outStr += "\n";
    }
#endif
    
    // Logs.
    std::string outStr = LogManager::singleton()->GetOutputString();
    self.mTxtLogOutput.text = [NSString stringWithUTF8String:outStr.c_str()];
    
    // Display result image.
    GL_FUNC_DEF curMode = GLProcessor::singleton()->getFuncToDo();
    if ((self.cacheMode != GLF_NONE) && (curMode == GLF_NONE)) {
        // Function Done. Display Result.
        std::string cpuFile = GLProcessor::singleton()-> getOutputPath(self.cacheMode, false);
        std::string gpuFile = GLProcessor::singleton()-> getOutputPath(self.cacheMode, true);
        std::string writePath = CCFileUtils::getWritablePath();

        cpuFile = writePath + cpuFile;
        gpuFile = writePath + gpuFile;
        NSString* nsCPUPath = [NSString stringWithUTF8String:cpuFile.c_str()];
        NSString* nsGPUPath = [NSString stringWithUTF8String:gpuFile.c_str()];
        
        UIImage * retCpuImage = [UIImage imageWithContentsOfFile: nsCPUPath];
        UIImage * retGpuImage = [UIImage imageWithContentsOfFile: nsGPUPath];
        self.mCpuResult.image = retCpuImage;
        self.mGpuResult.image = retGpuImage;
        
        // Clear.
        self.cacheMode = GLF_NONE;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)OnYTransition:(id)sender {
    GLProcessor::singleton()->doTransY();
    self.cacheMode = GLProcessor::singleton()->getFuncToDo();
}

- (IBAction)OnContrast:(id)sender {
    GLProcessor::singleton()->doContrast(0.5);
    self.cacheMode = GLProcessor::singleton()->getFuncToDo();
}

- (IBAction)OnLumination:(id)sender {
    GLProcessor::singleton()->doLumination(50);
    self.cacheMode = GLProcessor::singleton()->getFuncToDo();
}

- (IBAction)OnContrastLumination:(id)sender {
    GLProcessor::singleton()->doContrastLumination(0.5, 50);
    self.cacheMode = GLProcessor::singleton()->getFuncToDo();
}

- (IBAction)OnSaturationRate:(id)sender {
    GLProcessor::singleton()->doSaturationRate(0.3);
    self.cacheMode = GLProcessor::singleton()->getFuncToDo();
}

- (IBAction)onBoxScale:(id)sender {
    GLProcessor::singleton()->doBoxScale(gl_lib::Vec2(800, 450));
    self.cacheMode = GLProcessor::singleton()->getFuncToDo();
}
#if 0
- (IBAction)onNearestScale:(id)sender {
    GLProcessor::singleton()->doNearestScale(gl_lib::Vec2(800, 450));
    self.cacheMode = GLProcessor::singleton()->getFuncToDo();
}
#endif

- (IBAction)onBilinearScale:(id)sender {
    GLProcessor::singleton()->doBilinearScale(gl_lib::Vec2(800, 450));
    self.cacheMode = GLProcessor::singleton()->getFuncToDo();
}

- (IBAction)onBicubicScale:(id)sender {
    GLProcessor::singleton()->doBicubicScale(gl_lib::Vec2(800, 450));
    self.cacheMode = GLProcessor::singleton()->getFuncToDo();
}

- (IBAction)onLanczosScale:(id)sender {
    GLProcessor::singleton()->doLanczosScale(gl_lib::Vec2(800, 450), 3);
    self.cacheMode = GLProcessor::singleton()->getFuncToDo();
}

@end
