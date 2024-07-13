import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallpaper_app/Services/permission.dart';

class FullImage extends StatefulWidget {
  final String imageurl;
  final String imagename;

  const FullImage({Key? key, required this.imageurl, required this.imagename}) : super(key: key);

  @override
  _FullImageState createState() => _FullImageState();
}

class _FullImageState extends State<FullImage> {
  bool _isSettingWallpaper = false;

  Future<void> _setWallpaper(int location) async {
    setState(() {
      _isSettingWallpaper = true;
    });

    var file = await DefaultCacheManager().getSingleFile(widget.imageurl);
    bool result = false;

    if (location == WallpaperManager.HOME_SCREEN) {
      result = await WallpaperManager.setWallpaperFromFile(file.path, location);
    } else if (location == WallpaperManager.LOCK_SCREEN) {
      result = await WallpaperManager.setWallpaperFromFile(file.path, location);
    } else if (location == WallpaperManager.BOTH_SCREEN) {
      result = await WallpaperManager.setWallpaperFromFile(file.path, location);
    }

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Wallpaper set successfully!'),
        ),
      );
    }

    setState(() {
      _isSettingWallpaper = false;
    });
  }

  void _showBottomNavigationPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return Container(
          decoration: const BoxDecoration(
              color: Color(0xff232121),
              boxShadow: [ BoxShadow(
                color: Colors.teal,
                blurRadius: 10.0,
              ),],
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
          ),
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.home,color: Colors.teal,),
                title: Text('Set as Home Screen Wallpaper',style: TextStyle(color: Colors.teal),),
                onTap: () {
                  _setWallpaper(WallpaperManager.HOME_SCREEN);
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: Icon(Icons.lock,color: Colors.teal,),
                title: Text('Set as Lock Screen Wallpaper',style: TextStyle(color: Colors.teal),),
                onTap: () {
                  _setWallpaper(WallpaperManager.LOCK_SCREEN);
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: Icon(Icons.phone_android,color: Colors.teal,),
                title: Text('Set as Both (Home & Lock) Wallpaper',style: TextStyle(color: Colors.teal),),
                onTap: () {
                  _setWallpaper(WallpaperManager.BOTH_SCREEN);
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: Icon(Icons.file_download,color: Colors.teal,),
                title: Text('Download Image',style: TextStyle(color: Colors.teal),),
        onTap: () async {
        Navigator.pop(ctx);
        try {
          requestPermission();
        // Get the external directory to store the downloaded file
        Directory? picturesDir = await getExternalStorageDirectory();
        if (picturesDir == null) {
        throw Exception("Could not access external storage directory");
        }

        // Define the path for the Pictures directory
        String picturesPath = "/storage/emulated/0/Download";


        // Create the Pictures directory if it doesn't exist
        Directory(picturesPath).createSync(recursive: true);

        // Create Dio instance for downloading file
        Dio dio = Dio();

        // Download image
        String savePath = picturesPath+"/"+ widget.imagename;
        
        await dio.download(widget.imageurl, savePath);

        // Show a snackbar to indicate successful download
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        content: Text('Image downloaded successfully!'),
        ),
        );
        } catch (e) {
        // Show a snackbar if an error occurs during download
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        content: Text('Failed to download image'),
        ),
        );
        }

                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xff232121),
        ),
        child: Stack(
          children: [
            // Image
            Positioned.fill(
              child: Image.network(
                widget.imageurl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(

                    ),
                  );
                },
              ),
            ),

            // Circular container
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 50, // Center horizontally
              bottom: 30, // Adjust bottom spacing as needed
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Show bottom navigation popup
                    _showBottomNavigationPopup(context);
                    print('Container tapped');
                  },
                  borderRadius: BorderRadius.circular(50), // Make it circular
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0x6b2076da),
                    ),
                    child: _isSettingWallpaper
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                        : Center(
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
