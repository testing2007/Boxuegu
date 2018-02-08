//
//  BXGLocationManager.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/31.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "BXGAlertController.h"

static BXGLocationManager *_instance;
@interface BXGLocationManager() <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, copy) void(^currentLocationBlock)(CLLocation *location) ;
@end

@implementation BXGLocationManager

+ (instancetype)share; {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [BXGLocationManager new];
    });
    return _instance;
}

- (CLLocationManager *)locationManager {

    if(!_locationManager){
    
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (void)requestCurrentLocationWithFinishedBlock:(void(^)(CLLocation *location))finishedBlock {
    
    switch (CLLocationManager.authorizationStatus) {
        case kCLAuthorizationStatusNotDetermined:
        {
        
            [self.locationManager requestWhenInUseAuthorization];
            if(finishedBlock){
                
                [self toSetting];
                finishedBlock(nil);
            }
            return;
        }break;
            
        case kCLAuthorizationStatusRestricted:
        {
            [self.locationManager requestWhenInUseAuthorization];
            if(finishedBlock){
                
                [self toSetting];
                finishedBlock(nil);
            }
            return;
        }break;
            
        case kCLAuthorizationStatusDenied:
        {
            [self.locationManager requestWhenInUseAuthorization];
            if(finishedBlock){
                
                [self toSetting];
                finishedBlock(nil);
            }
            return;
        }break;
            
            
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            
        }break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            
        }break;
        default:
            break;
    }

        
        
        
    
    
    
    [self.locationManager startUpdatingLocation];
    self.currentLocationBlock = ^(CLLocation *location) {
        
        if(finishedBlock){
            
            finishedBlock(location);
        }
    };
//    MPMediaLibraryAuthorizationStatusNotDetermined = 0,
//    MPMediaLibraryAuthorizationStatusDenied,
//    MPMediaLibraryAuthorizationStatusRestricted,
//    MPMediaLibraryAuthorizationStatusAuthorized,
    // [self.locationManager requestWhenInUseAuthorization];
    

}

- (void)toSetting{

    
}

#pragma mark - Delegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {

    [self.locationManager stopUpdatingLocation];
    if(locations.count > 0){
    
        if(self.currentLocationBlock) {
        
            self.currentLocationBlock(locations.firstObject);
            self.currentLocationBlock = nil;
        }
    }
}


- (void)requestCurrentProvinceAndCityStringWithFinishedBlock:(void(^)(NSString *string))finishedBlock; {

    
    if(!finishedBlock) {
    
        return;
    }
    
    [self requestCurrentLocationWithFinishedBlock:^(CLLocation *location) {
    
        if(location) {
        
            CLGeocoder *geocoder = [[CLGeocoder alloc]init];
            
            [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                
                if(placemarks.count <= 0 || error){
                
                    NSLog(@"error");
                    finishedBlock(nil);
                    return;
                }else {
                
                    CLPlacemark *placemark = placemarks.firstObject;
                    NSString *province = placemark.administrativeArea;
                    NSString *city = placemark.locality;
                    
                    if(!province){
                    
                        province = @"";
                    }
                    
                    if(!city){
                        
                        city = @"";
                    }
                    
                    if(([province isEqualToString:city] || [province isEqualToString:@""]) && ![city isEqualToString:@""]) {
                    
                        finishedBlock(city);
                    }else if ([city isEqualToString:@""]){
                        
                        finishedBlock(@"定位失败");
                    } else {
                    
                        finishedBlock([NSString stringWithFormat:@"%@,%@",province,city]);
                    }
                }
            }];
            
        }else {
        
            finishedBlock(nil);
            return;
        }
        
        
    }];
}


@end
