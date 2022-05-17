import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geo_journal_v001/accounts/AccountPage.dart';
import 'package:geo_journal_v001/accounts/AccountsDBClasses.dart';
import 'package:geo_journal_v001/app_components/appUtilites.dart';
import 'package:geo_journal_v001/projects/project_and_DB/ProjectDBClasses.dart';
import 'package:geo_journal_v001/wells/AddSoilSample.dart';
import 'package:geo_journal_v001/wells/WellPage.dart';
import 'package:geo_journal_v001/wells/well_and_DB/WellDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'SoilSampleDBClasses.dart';


/* *************************************************************************
  Classes for soil samples
************************************************************************* */
class SoilSample extends StatefulWidget {
  final name;
  final depthStart;
  final depthEnd;
  final notes;
  
  final wellNumber;
  final projectNumber;

  final image;

  SoilSample(this.name, this.depthStart, this.depthEnd, this.notes, this.wellNumber, this.projectNumber, this.image);
  
  @override
  SoilSampleState createState() => SoilSampleState();
}


class SoilSampleState extends State<SoilSample> {
  var box;
  var image;
  
   
  // Function for getting data from Hive database
  Future getDataFromBox() async {
    box = await Hive.openBox('accounts_data');
    
    return Future.value(box.values);     
  }


  // Get image from gallery
  void getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 4000,
      maxHeight: 4000,
    );

    image = pickedFile.path;
  }


  // Check current account
  Future<bool> checkAccount(var account) async {
    return (account.login == (await currentAccount).login &&
      account.password == (await currentAccount).password &&
      account.email == (await currentAccount).email &&
      account.phoneNumber == (await currentAccount).phoneNumber &&
      account.position == (await currentAccount).position &&
      account.isAdmin == (await currentAccount).isAdmin)? Future<bool>.value(true): Future<bool>.value(false);
  }


  // Function for saving or deleting image from gallery, depending on mode
  saveOrDeleteImage(bool change) async {
    var projects = (await currentAccount).projects;
    var wells;
    var samples;
    
    for (var key in box.keys) {
      if ((await checkAccount(box.get(key))) == true) {
        
        for (var project in projects) {
          if (project.number == widget.projectNumber) {

            wells = project.wells;
            
            for (var well in wells) {
              if (well.projectNumber == widget.projectNumber && well.number == widget.wellNumber) {

                samples = well.samples;

                for (var sample in samples) {
                  if (sample.name == widget.name) {

                    samples[samples.indexOf(sample)] = SoilForWellDescription(
                      sample.name,
                      sample.depthStart,
                      sample.depthEnd,
                      sample.notes,
                      widget.wellNumber,
                      widget.projectNumber,
                      image: change==true? image.toString() : null
                    );

                    wells[wells.indexOf(well)] = WellDescription(
                      well.number, 
                      well.date,
                      well.latitude,
                      well.longtitude,
                      well.projectNumber,
                      samples,
                      image: well.image 
                    );

                    projects[projects.indexOf(project)] = ProjectDescription(
                      project.name, 
                      project.number,
                      project.date,
                      project.address,
                      project.notes, 
                      wells, 
                      project.soundings 
                    );

                    box.put(
                      key, UserAccountDescription(
                      (await currentAccount).login,
                      (await currentAccount).password,
                      (await currentAccount).email,
                      (await currentAccount).phoneNumber,
                      (await currentAccount).position,
                      true,
                      (await currentAccount).isAdmin,
                      projects
                      )
                    );

                    return '';

                  }
                }

              }
            }

          }
        }
      }
    }
  }


  // Function for deleting data in database
  deleteElementInBox() async {
    var projects = (await currentAccount).projects;
    var wells;
    var samples;
    
    for (var key in box.keys) {
      if ((await checkAccount(box.get(key))) == true) {
        
        for (var project in projects) {
          if (project.number == widget.projectNumber) {

            wells = project.wells;
            
            for (var well in wells) {
              if (well.number == widget.wellNumber) {

                samples = well.samples;

                for (var sample in samples) {
                  if (sample.name == widget.name) {

                    samples.removeWhere((item) => item.name == widget.name);

                    wells[wells.indexOf(well)] = WellDescription(
                      well.number, 
                      well.date,
                      well.latitude,
                      well.longtitude,
                      well.projectNumber,
                      samples,
                      image: well.image 
                    );

                    projects[projects.indexOf(project)] = ProjectDescription(
                      project.name, 
                      project.number,
                      project.date,
                      project.address,
                      project.notes, 
                      wells, 
                      project.soundings 
                    );

                    box.put(
                      key, UserAccountDescription(
                      (await currentAccount).login,
                      (await currentAccount).password,
                      (await currentAccount).email,
                      (await currentAccount).phoneNumber,
                      (await currentAccount).position,
                      true,
                      (await currentAccount).isAdmin,
                      projects
                      )
                    );

                  }
                }

              }
            }

          }
        }
      }
    }
  }



  @override
  Widget build(BuildContext context) {

    getDataFromBox();

    return Container(

      decoration: BoxDecoration(
        border: Border(
        bottom: BorderSide(color: Colors.black45, width: 1.0),
        )
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          // Main data about soil sample
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 0.0),
                child: Text('${widget.name}')
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
                child: Text('${widget.depthStart}-${widget.depthEnd} м'),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 15.0),
                child: Container(
                  width: 200,
                  child: Text('Нотатки: ${widget.notes}'),
                )
              )
            ]
          ),


          Row(
            children: [
              
              // Add / delete photo
              IconButton(        
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,

                padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                icon: Icon(Icons.photo, size: 20),
                onPressed: () {

                  // If there isn't a photo - add new one from gallery and save it, 
                  // else - show this photo and then choose: delete it or not
                  if ((widget.image == null && image != null) || (widget.image != null && image == null)) {

                    saveOrDeleteImage(true);
                    
                    showDialog(
                      context: context, 
                      builder: (BuildContext context) {

                        return AlertDialog(
                          insetPadding: EdgeInsets.all(10),
                          contentPadding: EdgeInsets.zero,
                          
                          title: const Text(''),
                          content: Stack(
                            overflow: Overflow.visible,
                            alignment: Alignment.center,
                            children: [
                              Image.file(File(widget.image == null? image : widget.image), fit: BoxFit.cover)
                            ],
                          ),

                          actions: [
                            
                            FlatButton(
                              child: const Text('Видалити'),
                              onPressed: () { 
                                saveOrDeleteImage(false);
                                image = null;
                                Navigator.of(context).pop(); 
                              },
                            ),

                            FlatButton(
                              child: const Text('ОК'),
                              onPressed: () { 
                                saveOrDeleteImage(true);
                                Navigator.of(context).pop(); 
                              },
                            ),

                          ],
                        );
                      }
                    );
                  } else {
                    getFromGallery();
                  }
                  }
              ),


              // Move to soil sample editing page
              IconButton(        
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,

                padding: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                icon: Icon(Icons.edit, size: 23),
                onPressed: () {

                  if (currentAccountIsRegistered) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddSoilSample.editing(widget.name, widget.wellNumber, widget.projectNumber, 'edit')));
                  } else {
                    attentionAlert(context, 'Незареєстровані користувачі не мають доступу до даного елементу.\nМожливо, ви хочете зареєструватися?', materialRoute: AddAccountPage('sign_up'));
                  }

                }
              ),


              // Delete soil sample
              IconButton(        
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,

                padding: EdgeInsets.fromLTRB(0.0, 0.0, 23.0, 0.0),
                icon: Icon(Icons.delete, size: 23),
                onPressed: () {
                  
                  if (currentAccountIsRegistered) {
                    onDeleteAlert(context, 'дану пробу грунту', deleteElementInBox, materialPageRoute: WellPage(widget.wellNumber, widget.projectNumber));
                    setState(() { });
                  } else {
                    attentionAlert(context, 'Незареєстровані користувачі не мають доступу до даного елементу.\nМожливо, ви хочете зареєструватися?', materialRoute: AddAccountPage('sign_up'));
                  }
                  
                }
              ),
              
              
            ]
          ),

        ]
      )
    );
  }

}