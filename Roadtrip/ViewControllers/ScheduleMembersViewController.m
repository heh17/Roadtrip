//
//  ShareScheduleViewController.m
//  Roadtrip
//
//  Created by Hector Diaz on 7/30/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "ScheduleMembersViewController.h"
#import "AddPeopleScheduleViewController.h"
#import "RecognizedFriendsViewController.h"
#import "Parse.h"
#import "UIImage+FixOrientation.h"
#import "UIImage+Crop.h"
#import "ImageHelper.h"
#import "PersonFace.h"
#import "PersistedFace.h"
#import "MPOSimpleFaceCell.h"
//#import "MBProgressHUD.h"
#import "PersonFace.h"
#import "ViewUtils.h"
#import <ProjectOxfordFace/MPOFaceServiceClient.h>

@interface ScheduleMembersViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate, UICollectionViewDataSource> {
    
    NSMutableArray<PersistedFace*> * _selectedFaces;
    NSMutableArray<PersonFace*> * _baseFaces;
    UICollectionView * _imageContainer0;
    UICollectionView * _imageContainer1;
    UIScrollView * _resultContainer;
    UIButton * _findBtn;
    UILabel * _imageCountLabel;
    NSInteger _selectIndex;
    NSInteger _selectedTargetIndex;
    NSString * _largrFaceListId;

}

@end

@implementation ScheduleMembersViewController

    NSString *const ProjectOxfordFaceEndpoint = @"https://westcentralus.api.cognitive.microsoft.com/face/v1.0";
    NSString *const ProjectOxfordFaceSubscriptionKey = @"8bbc65bcabcd4cb9976ca05de721eb5b";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.picturesDictionary = [[NSMutableDictionary alloc] init];
    self.detectedFaces = [[NSMutableDictionary alloc] init];
    // _largrFaceListId = @"8c641dc3-b437-43c5-afec-5eb8089cd462";
    _baseFaces = [[NSMutableArray alloc] init];
    _selectedFaces = [[NSMutableArray alloc] init];
    _selectedTargetIndex = -1;
    self.membersTableView.delegate = self;
    self.membersTableView.dataSource = self;
    [self.membersTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"memberCell"];
    UIBarButtonItem *customBtn=[[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(didClickAddButton)];
    [self.navigationItem setRightBarButtonItem:customBtn];
    
    [self deleteLargeFaceList];
    [self createLargeFaceList];
    
    [self fetchMembersOfSchedule];
    [self fetchFriends];
}

- (void)createLargeFaceList {
    MPOFaceServiceClient *client = [[MPOFaceServiceClient alloc] initWithEndpointAndSubscriptionKey:@"https://westcentralus.api.cognitive.microsoft.com/face/v1.0" key:@"8bbc65bcabcd4cb9976ca05de721eb5b"];
    
    NSString * largeFaceListId = [[[NSUUID UUID] UUIDString] lowercaseString];
    
    [client createLargeFaceList:largeFaceListId name:@"name" userData:nil completionBlock:^(NSError *error) {
        if (error) {
            //[CommonUtil simpleDialog:@"Failed in creating large face list."];
            NSLog(@"%@", error);
            return;
        }
        _largrFaceListId = largeFaceListId;
        NSLog(@"lARGE fACE LIUST: %@", largeFaceListId);
        //[CommonUtil showSimpleHUD:@"Large face list created" forController:self.navigationController];
    }];
}

- (void)deleteLargeFaceList {
        MPOFaceServiceClient *client = [[MPOFaceServiceClient alloc] initWithEndpointAndSubscriptionKey:@"https://westcentralus.api.cognitive.microsoft.com/face/v1.0" key:@"8bbc65bcabcd4cb9976ca05de721eb5b"];
    [client deleteLargeFaceList:_largrFaceListId name:@"name" userData:nil completionBlock:^(NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            return;
        }
    }];
}



-(void) didClickAddButton {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select Source" message:@"Where do you want to save your schedule to?" preferredStyle: UIAlertControllerStyleActionSheet];
    
    UIAlertAction *usernameAction = [UIAlertAction actionWithTitle:@"Add by username" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self performSegueWithIdentifier:@"addFriendsSegue" sender:self];
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"Add by photo" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePickerVC = [UIImagePickerController new];
        imagePickerVC.delegate = self;
        imagePickerVC.allowsEditing = YES;
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
         
        //[self chooseImage:self];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction: usernameAction];
    [alert addAction:photoAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    [self performSegueWithIdentifier:@"addFriendsSegue" sender:self];
}

- (void)chooseImage: (id)sender {
    _selectIndex = [(UIView*)sender tag];
    UIActionSheet * choose_photo_sheet = [[UIActionSheet alloc]
                                          initWithTitle:@"Select Image"
                                          delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:@"Select from album", @"Take a photo",nil];
    [choose_photo_sheet showInView:self.view];
}

-(void) fetchMembersOfSchedule {
    
    PFQuery *membersQuery = [self.schedule.membersRelation query];
    [membersQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error fetching members of schedule");
        } else {
            self.members = objects;
            [self.membersTableView reloadData];
        }
        
    }];
    
}

- (void)addFace:data image:(UIImage *) image{
    
    MPOFaceServiceClient *client = [[MPOFaceServiceClient alloc] initWithEndpointAndSubscriptionKey:@"" key:@""];
    
    [client addFaceInLargeFaceList:_largrFaceListId data:data userData:nil faceRectangle:nil  completionBlock:^(MPOAddPersistedFaceResult *addPersistedFaceResult, NSError *error) {
        if (error) {
            return;
        }
        
        PersistedFace *obj = [[PersistedFace alloc] init];
        obj.image = image;
        obj.persistedFaceId = addPersistedFaceResult.persistedFaceId;
        
        [_selectedFaces addObject:obj];
        
        _imageCountLabel.text =  [NSString stringWithFormat:@"%d faces in total", (int32_t)_selectedFaces.count];
        [_imageContainer0 reloadData];
        [_imageContainer1 reloadData];
        
    }];
}

- (void)trainLargeFaceList {
    MPOFaceServiceClient *client = [[MPOFaceServiceClient alloc] initWithEndpointAndSubscriptionKey:@"https://westcentralus.api.cognitive.microsoft.com/face/v1.0" key:@"8bbc65bcabcd4cb9976ca05de721eb5b"];

    [client trainLargeFaceList:_largrFaceListId completionBlock:^(NSError *error) {
        //[HUD removeFromSuperview];
        if (error) {
            
        } else {
            [self findSimilarFace];
            NSLog(@"Base face size: %lu", _baseFaces.count);
        }
    }];
}



- (void)findSimilarFace {
    
    /*MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText = @"Finding similar faces";
    [HUD show: YES];
    */
    MPOFaceServiceClient *client = [[MPOFaceServiceClient alloc] initWithEndpointAndSubscriptionKey:@"https://westcentralus.api.cognitive.microsoft.com/face/v1.0" key:@"8bbc65bcabcd4cb9976ca05de721eb5b"];
    
    for (int i = 0; i < _baseFaces.count; i++){
        [client findSimilarWithFaceId:_baseFaces[i].face.faceId largeFaceListId:_largrFaceListId completionBlock:^(NSArray<MPOSimilarPersistedFace *> *collection, NSError *error) {
            //[HUD removeFromSuperview];
            
            if (error) {
                //[CommonUtil showSimpleHUD:@"Failed to find similar faces" forController:self.navigationController];
                return;
            }
            
            for (UIView * v in _resultContainer.subviews) {
                [v removeFromSuperview];
            }
            for (int j = 0; j < collection.count; j++) {
                MPOSimilarPersistedFace * result = collection[j];
                NSLog(@"ID: %@", result.persistedFaceId);
                NSLog(@"Dictionary: %@", self.picturesDictionary);
                NSLog(@"User: %@", [self.picturesDictionary valueForKey:result.persistedFaceId]);
                UIImage *pic = _baseFaces[i].image;
                [self.detectedFaces setValue:pic forKey:[self.picturesDictionary valueForKey:result.persistedFaceId]];
            }
            
            if(i == collection.count - 1){
                NSLog(@"This");
                [self performSegueWithIdentifier:@"recognizedFriendsSegue" sender:self];
            }
            
            if (collection.count == 0) {
                NSLog(@"No similar face");
                //[CommonUtil showSimpleHUD:@"No similar faces." forController:self.navigationController];
            }
            NSLog(@"Passing dictionary: %@", self.detectedFaces);
        }];
    }
}

- (PersistedFace*)faceForId:(NSString*)faceId {
    for (PersistedFace * face in _selectedFaces) {
        if ([face.persistedFaceId isEqualToString:faceId]) {
            return face;
        }
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.members.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"memberCell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    PFUser *member = self.members[indexPath.row];
    cell.textLabel.text = [member valueForKey:@"username"];
    cell.detailTextLabel.text = [member valueForKey:@"publicEmail"];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    UIImage * _selectedImage;
    if (info[UIImagePickerControllerEditedImage])
        _selectedImage = info[UIImagePickerControllerEditedImage];
    else
        _selectedImage = info[UIImagePickerControllerOriginalImage];
    [_selectedImage fixOrientation];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    NSData *data = UIImageJPEGRepresentation(_selectedImage, 0.8);
    if(_selectIndex != 0){
       /* MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.labelText = @"Detecting faces";
        [HUD show: YES];*/
    MPOFaceServiceClient *client = [[MPOFaceServiceClient alloc] initWithEndpointAndSubscriptionKey:@"https://westcentralus.api.cognitive.microsoft.com/face/v1.0" key:@"8bbc65bcabcd4cb9976ca05de721eb5b"];
        
        [client detectWithData:data returnFaceId:YES returnFaceLandmarks:YES returnFaceAttributes:@[] completionBlock:^(NSArray<MPOFace *> *collection, NSError *error) {
           // [HUD removeFromSuperview];
            if (error) {
                //[CommonUtil showSimpleHUD:@"Detection failed" forController:self.navigationController];
                return;
            }
            
            NSMutableArray * faces = [[NSMutableArray alloc] init];
            
            for (MPOFace *face in collection) {
                UIImage *croppedImage = [_selectedImage crop:CGRectMake(face.faceRectangle.left.floatValue, face.faceRectangle.top.floatValue, face.faceRectangle.width.floatValue, face.faceRectangle.height.floatValue)];
                PersonFace *obj = [[PersonFace alloc] init];
                obj.image = croppedImage;
                obj.face = face;
                [faces addObject:obj];
            }
            NSLog(@"Faces: %lu", faces.count);
            [_baseFaces removeAllObjects];
            [_baseFaces addObjectsFromArray:faces];
            _findBtn.enabled = NO;
            _selectedTargetIndex = -1;
            
            _imageCountLabel.text =  [NSString stringWithFormat:@"%d faces in total", (int32_t)_selectedFaces.count];
            [_imageContainer0 reloadData];
            [_imageContainer1 reloadData];
            NSLog(@"IF PART WOO");
            if (collection.count == 0) {
                //[CommonUtil showSimpleHUD:@"No face detected." forController:self.navigationController];
            }
        }];
        
    }else {
        NSLog(@"ELSE PART BOO");
        // [self.picturesDictionary setValue:@"Emma" forKey:@"26319271-918b-4eb6-ace1-e0db8f805400"];
        //	[self.picturesDictionary setValue:@"Emma" forKey:@"26319271-918b-4eb6-ace1-e0db8f805400"];
        // [self.picturesDictionary setValue:@"Hector" forKey:@"05b230e7-793e-4cc4-9c88-76a6ce08645b"];
        for (int i = 0; i < self.friends.count; i++) {
            NSLog(@"In for loop");
            PFFile *imageFile = [((PFUser *)self.friends[i]) valueForKey:@"profilePic"];
            [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                UIImage *profileImage = [UIImage imageWithData:imageData];
                NSData *data = UIImageJPEGRepresentation(profileImage, 0.8);
                [self addFace:data image:_selectedImage withUser:((PFUser *)self.friends[i]).username];
            }];
        }
        MPOFaceServiceClient *client = [[MPOFaceServiceClient alloc] initWithEndpointAndSubscriptionKey:@"https://westcentralus.api.cognitive.microsoft.com/face/v1.0" key:@"8bbc65bcabcd4cb9976ca05de721eb5b"];
        
        [client detectWithData:data returnFaceId:YES returnFaceLandmarks:YES returnFaceAttributes:@[] completionBlock:^(NSArray<MPOFace *> *collection, NSError *error) {
            // [HUD removeFromSuperview];
            if (error) {
                //[CommonUtil showSimpleHUD:@"Detection failed" forController:self.navigationController];
                return;
            }
            
            NSMutableArray * faces = [[NSMutableArray alloc] init];
            
            for (MPOFace *face in collection) {
                UIImage *croppedImage = [_selectedImage crop:CGRectMake(face.faceRectangle.left.floatValue, face.faceRectangle.top.floatValue, face.faceRectangle.width.floatValue, face.faceRectangle.height.floatValue)];
                PersonFace *obj = [[PersonFace alloc] init];
                obj.image = croppedImage;
                obj.face = face;
                [faces addObject:obj];
            }
            NSLog(@"Faces: %lu", faces.count);
            [_baseFaces removeAllObjects];
            [_baseFaces addObjectsFromArray:faces];
        }];
    }
    
}

- (void)addFace:data image:(UIImage *) image withUser:(NSString *)username{
    /*MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText = @"Adding faces";
    [HUD show: YES];
     */
    MPOFaceServiceClient *client = [[MPOFaceServiceClient alloc] initWithEndpointAndSubscriptionKey:@"https://westcentralus.api.cognitive.microsoft.com/face/v1.0" key:@"8bbc65bcabcd4cb9976ca05de721eb5b"];
    
    [client addFaceInLargeFaceList:_largrFaceListId data:data userData:nil faceRectangle:nil  completionBlock:^(MPOAddPersistedFaceResult *addPersistedFaceResult, NSError *error) {
        //[HUD removeFromSuperview];
        if (error) {
            //[CommonUtil showSimpleHUD:@"Failed in adding face" forController:self.navigationController];
            return;
        }
        //[CommonUtil showSimpleHUD:@"Successed in adding face" forController:self.navigationController];
        
        PersistedFace *obj = [[PersistedFace alloc] init];
        obj.image = image;
        obj.persistedFaceId = addPersistedFaceResult.persistedFaceId;
        [self.picturesDictionary setValue:username forKey:obj.persistedFaceId];
        NSLog(@"Dictionary ID: %@", obj.persistedFaceId);
        NSLog(@"Dictionary Username: %@", username);
        [_selectedFaces addObject:obj];
        
        _imageCountLabel.text =  [NSString stringWithFormat:@"%d faces in total", (int32_t)_selectedFaces.count];
        [_imageContainer0 reloadData];
        [_imageContainer1 reloadData];
        
        [self trainLargeFaceList];
        
    }];
}

-(void) fetchFriends {
    PFUser *currentUser = [PFUser currentUser];
    PFRelation *friendsRelation = [currentUser relationForKey:@"friends"];
    PFQuery *friendsQuery = [friendsRelation query];
    [friendsQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error getting friends");
        } else {
            self.friends = objects;
            [self fetchProfilePictureOfFriends];
        }
        
    }];
}

-(void) fetchProfilePictureOfFriends {
    
    for(PFUser *friend in self.friends) {
        PFFile *imageFile = [friend valueForKey:@"profilePic"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            UIImage *profileImage = [UIImage imageWithData:imageData];
        
        }];
    }
}
     


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([[segue identifier] isEqualToString:@"addFriendsSegue"]) {
        AddPeopleScheduleViewController *viewController = [segue destinationViewController];
        viewController.schedule = self.schedule;
        
    } else if([[segue identifier] isEqualToString:@"recognizedFriendsSegue"]) {
        RecognizedFriendsViewController *vc = [segue destinationViewController];
        vc.friends = self.friends;
        vc.schedule = self.schedule;
        vc.userPhotosDictionary = self.detectedFaces;
    }
    
}


@end
