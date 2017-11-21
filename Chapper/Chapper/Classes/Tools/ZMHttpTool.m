//
//  YYHttpTool.m
//

#import "ZMHttpTool.h"


@implementation ZMHttpTool
+(void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    //2.发送Get请求
    [mgr GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(NSURLSessionDataTask *)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //1.获得请求管理者

    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];

    mgr.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
   NSURLSessionDataTask *dataTask = [mgr POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
       if (success) {
           success(responseObject);
       }
       
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
       if (failure) {
           failure(error);
       }
   }];
    
    return dataTask;
}
@end
