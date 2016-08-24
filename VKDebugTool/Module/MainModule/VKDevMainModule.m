//
//  VKDebugMainModule.m
//  VKDebugToolDemo
//
//  Created by Awhisper on 16/8/17.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "VKDevMainModule.h"
#import "VKDevMenu.h"
#import "VKDevTipView.h"
#import "VKDevTool.h"
#import "VKDevToolDefine.h"
@interface VKDevMainModule ()<VKDevMenuDelegate>

@property (nonatomic,strong) VKDevMenu *devMenu;

@end

@implementation VKDevMainModule

-(instancetype)init
{
    self = [super init];
    if (self) {
#ifdef VKDevMode
        _devMenu = [[VKDevMenu alloc]init];
        _devMenu.delegate = self;
#endif
    }
    return self;
}

-(UIView *)moduleView
{
    return nil;
}

-(void)showModuleView
{
    
}

-(void)showModuleMenu
{
#ifdef VKDevMode
    [self.devMenu show];
#endif
}

-(void)hideModuleMenu
{
#ifdef VKDevMode
    [self.devMenu hide];
#endif
}

#pragma mark VKDevMenuDelegate
-(NSString *)needDevMenuTitle
{
    return @"VKDevTool";
}

-(NSArray *)needDevMenuItemsArray
{
    NSDictionary *extDic = [VKDevTool singleton].extensionDic;
    NSMutableArray *titleArray = [[NSMutableArray alloc]initWithArray:@[@"DebugScript",@"ConsoleLog",@"NetworkLog"]];
    NSArray *extTitleArray = [extDic allKeys];
    [titleArray addObjectsFromArray:extTitleArray];
    return titleArray;
}

-(void)didClickMenuWithButtonIndex:(NSInteger)index
{
#ifdef VKDevMode
    switch (index) {
        case 0:
        {
            [self goDebugScript];
        }
            break;
        case 1:{
            [self goConsoleLog];
        }
            break;
        case 2:{
            [self goNetworkLog];
        }
        default:{
            if (index >= 3) {
                NSDictionary *extDic = [VKDevTool singleton].extensionDic;
                NSArray *extTitleArray = [extDic allKeys];
                NSInteger extIndex = index - 3;
                if (extTitleArray.count > extIndex) {
                    NSString *key = [extTitleArray objectAtIndex:extIndex];
                    void(^extblock)(void) = [extDic objectForKey:key];
                    extblock();
                }
            }
        }
            break;
    }
#endif
}

-(void)goDebugScript
{
    [VKDevTool gotoScriptModule];
}

-(void)goConsoleLog{
    [VKDevTool gotoLogModule];
}

-(void)goNetworkLog{
    [VKDevTool gotoNetworkModule];
}
@end
