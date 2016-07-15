//
//  ViewController.m
//  Zwt369BaiduMap
//
//  Created by Tony Zhang on 16/7/13.
//  Copyright © 2016年 Tony Zhang. All rights reserved.
//

#import "ViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface ViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>{

    BMKLocationService *service;
}

/** BMKMapView */
@property(nonatomic,strong)BMKMapView *mapView;

/** 大半针 */
@property(nonatomic,strong)BMKPointAnnotation *pointAnotation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(10, 100, 300, 300)];
    [self.view addSubview:self.mapView];
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//定位跟随模式
    NSArray *point = self.mapView.annotations;
    [self.mapView removeAnnotations:point];
    point = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:point];
    self.mapView.delegate = self;
    _mapView.showMapScaleBar = YES;//比例尺
    _mapView.mapScaleBarPosition = CGPointMake(10,_mapView.frame.size.height-45);//比例尺的位置
    _mapView.showsUserLocation=YES;//显示当前设备的位置
    _mapView.mapType = BMKMapTypeStandard;
    self.mapView.zoomLevel = 18;
//    [self addPointAnnotation];
//    [self addAnimatedAnnotation];
   //    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake( 28.227606,112.901352);
//   
//    BMKCoordinateSpan span = (BMKCoordinateSpan){0.01f,0.01f};
//    BMKCoordinateRegion viewRegion = (BMKCoordinateRegion){coor,span};
//
//    [_mapView setRegion:viewRegion animated:YES];
    
    
    self.pointAnotation = [[BMKPointAnnotation alloc]init];
    
    [_mapView addAnnotation:self.pointAnotation];
    //用户位置类
    BMKLocationViewDisplayParam* param = [[BMKLocationViewDisplayParam alloc] init];
    param.locationViewOffsetY = 0;//偏移量
    param.locationViewOffsetX = 0;
    param.isAccuracyCircleShow =NO;//设置是否显示定位的那个精度圈
    param.isRotateAngleValid = NO;
    [_mapView updateLocationViewWithParam:param];
    service = [[BMKLocationService alloc]init];
    service.delegate = self;
    [service startUserLocationService];
}


- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{

   CLLocationCoordinate2D coor = userLocation.location.coordinate;
    self.pointAnotation.coordinate = coor;
    [self.mapView updateLocationData:userLocation];
}

-(void)viewWillAppear:(BOOL)animated {
//    [_mapView viewWillAppear];
//    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
  
}

-(void)viewWillDisappear:(BOOL)animated {
//    [_mapView viewWillDisappear];
//    _mapView.delegate = nil; // 不用时，置nil
  }


//根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"annotationViewID";
    //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout = YES;
//    view.zoomLevel = 20;
    return annotationView;
}


@end
