import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geo_journal_v001/accounts/AccountPage.dart';
import 'package:geo_journal_v001/accounts/AccountsDBClasses.dart';
import 'package:geo_journal_v001/projects/project_and_DB/ProjectDBClasses.dart';
import 'package:geo_journal_v001/soundings/AddSoundingData.dart';
import 'package:geo_journal_v001/soundings/Soundigs.dart';
import 'package:geo_journal_v001/soundings/sounding_and_DB/SoundingDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../AppUtilites.dart';


/* *************************************************************************
 Classes for sounding
************************************************************************* */
class Sounding extends StatefulWidget {
  final depth;
  final qc;
  final fs;
  final notes;
  final image;

  final projectNumber;  // number of project, to which the well belongs

  Sounding(this.depth, this.qc, this.fs, this.notes, this.projectNumber, this.image);
  
  @override
  SoundingState createState() => SoundingState();
}


class SoundingState extends State<Sounding>{
  var box;
  var image;

  // Function for getting data from Hive database
  Future<void> getDataFromBox() async {
    box = await Hive.openBox('accounts_data');
  }

  
  getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 4000,
      maxHeight: 4000,
    );

    image = pickedFile.path;
  }

  getFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 4000,
      maxHeight: 4000,
    );

    image = pickedFile.path;
  }


  Future<bool> checkAccount(var account) async {
    return (account.login == (await currentAccount).login &&
      account.password == (await currentAccount).password &&
      account.email == (await currentAccount).email &&
      account.phoneNumber == (await currentAccount).phoneNumber &&
      account.position == (await currentAccount).position &&
      account.isAdmin == (await currentAccount).isAdmin)? Future<bool>.value(true): Future<bool>.value(false);
  }

  
  saveOrDeleteImage(bool change) async {
    var projects = (await currentAccount).projects;
    var soundings;
    
    for (var key in box.keys) {
      if ((await checkAccount(box.get(key))) == true) {
        
        for (var project in projects) {
          if (project.number == widget.projectNumber) {

            soundings = project.soundings;
            
            for (var sounding in soundings) {
              if (sounding.depth == widget.depth) {

                soundings[soundings.indexOf(sounding)] = SoundingDescription(
                  sounding.depth, 
                  sounding.qc,
                  sounding.fs,
                  sounding.notes,
                  widget.projectNumber,
                  image: change==true? image.toString() : null
                );

                projects[projects.indexOf(project)] = ProjectDescription(
                  project.name, 
                  project.number,
                  project.date,
                  project.notes, 
                  project.wells, 
                  soundings 
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


  // Function for deleting data in database
  deleteElementInBox() async {
    var projects = (await currentAccount).projects;
    var soundings;

    for (var key in box.keys) {
      if ((await checkAccount(box.get(key))) == true) {

        for (var project in projects) {
          if (project.number == widget.projectNumber) {

            soundings = project.soundings;

            for (var sounding in soundings) {
              if (sounding.depth == widget.depth) {

                soundings.removeWhere((item) => item.depth == widget.depth);
    
                projects[projects.indexOf(project)] = ProjectDescription(
                  project.name, 
                  project.number,
                  project.date,
                  project.notes, 
                  project.wells, 
                  soundings
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 0.0),
                  child: Text('Кінцева глибина: ${widget.depth}')
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
                  child: Text('qc: ${widget.qc}'),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
                  child: Text('fs: ${widget.fs}'),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 15.0),
                  child: Text('Примітки: ${widget.notes}'),
                )
              ]
            ),


            Row(
              children: [

                IconButton(        
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,

                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                  icon: Icon(Icons.photo, size: 20),
                  onPressed: () {
                    if (widget.image != null || image != null) {
                      
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

                IconButton(        
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,

                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                  icon: Icon(Icons.edit, size: 23),
                  onPressed: () {

                    if (currentAccountIsRegistered) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddSoundingData.edit(widget.projectNumber, widget.depth, 'edit')));
                    } else {
                      attentionAlert(context, 'Незареєстровані користувачі не мають доступу до даного елементу.\nМожливо, ви хочете зареєструватися?', materialRoute: AddAccountPage('sign_up'));
                    }

                  }
                ),

                IconButton(        
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,

                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 23.0, 0.0),
                  icon: Icon(Icons.delete, size: 23),
                  onPressed: () {
                    
                    if (currentAccountIsRegistered) {
                      onDeleteAlert(context, 'дану точку', deleteElementInBox, materialPageRoute: Soundings(widget.projectNumber));
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