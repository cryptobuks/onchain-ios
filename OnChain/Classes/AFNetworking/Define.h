//
//  Define.h
//  PICKETFENCE
//
//  Created by YunCholHo on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

#import "XMLParser.h"
#import "LocationModel.h"
#import "MapViewController.h"

#define SERVER_PATH @"https://maps.googleapis.com/maps/api/place/textsearch/xml"
#define KEY  @"AIzaSyBzRJJWBppzZIBPfsczkxZOEnNt0I7HEbc"

////tag
#define RESPONSE_TAG  @"PlaceSearchResponse"
#define STATUS_TAG    @"status"
#define RESULT_TAG    @"result"
#define NAME_TAG       @"name"
#define TYPE_TAG        @"type"
#define FORMAED_ADDRESS_TAG @"formatted_address"
#define GEOMETRY_TAG        @"geometry"
#define LOCATION_TAG        @"location"
#define LAT_TAG             @"lat"
#define LNG_TAG             @"lng"
#define RATING_TAG             @"rating"
#define ICON_TAG               @"icon"
#define REFERENCE_TAG           @"reference"
#define HOUR_TAG                @"opening_hours"
#define OPEN_NOW_TAG            @"open_now"
#define NEXT_PAGE_TAG           @"next_page_token"
