import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallpaper_app/Services/ad_mob_service.dart';
import '../Services/permission.dart';
import '../Screens/CategoryItems.dart';
import '../Screens/fullimage.dart';

class HomePage extends StatefulWidget {
  final List data;
  const HomePage({super.key, required this.data});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
BannerAd? _bannerAd;

  @override
  void initState(){
    super.initState();
    _createBannerAd();
  }

  void _createBannerAd(){
      _bannerAd=BannerAd(size: AdSize.fullBanner, adUnitId: AdMobService.bannerAdUnitId!, listener: AdMobService.bannerAdListener, request: AdRequest())..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff232121),
      body: Container(
        padding: EdgeInsets.only(left: 5,right: 5,top: 10),
        child: widget.data.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  childAspectRatio: 2 / 4,
                  mainAxisSpacing: 10,
                ),
                itemCount: widget.data.length,
                itemBuilder: (context, index) {
                  String imagepath =
                      "https://mobileland.in/WallpaperAdmin/public/images/" +
                          widget.data[index]['image'];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullImage(
                                    imageurl: imagepath,
                                    imagename: widget.data[index]['image'],
                                  )));
                    },
                    child: CachedNetworkImage(
                      imageUrl: imagepath,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.fill)),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: _bannerAd==null
      ?Container()
      :Container(
        height: 52,
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final List data;

  const CategoryPage({super.key, required this.data});

  //onTap function used in Category Page
  void onTapFunction(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryItems(category: category, data: data,),
      ),
    );
  }

  Widget createCategoryContainer(String category) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/Category/$category.jpg"),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Container(
          padding: EdgeInsets.only(left: 15,right: 15,top: 6,bottom: 6),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.black.withOpacity(0.6),),
          child: Text(
            category,
            style: GoogleFonts.roboto(color: Colors.white, fontSize: 30),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 5,right: 5,top: 10),
        color: Color(0xff232121),
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 8,
            childAspectRatio: 2 / 1,
          ),
          children: [
            InkWell(
                onTap: () {
                  onTapFunction(context, "Anime");
                },
                child: createCategoryContainer("Anime")),
            InkWell(
                onTap: () {
                  onTapFunction(context, "Nature");
                },
                child: createCategoryContainer("Nature")),
            InkWell(
                onTap: () {
                  onTapFunction(context, "Animal");
                },
                child: createCategoryContainer("Animal")),
            InkWell(
                onTap: () {
                  onTapFunction(context, "Space");
                },
                child: createCategoryContainer("Space")),
            InkWell(
                onTap: () {
                  onTapFunction(context, "Structure");
                },
                child: createCategoryContainer("Structure")),
            InkWell(
                onTap: () {
                  onTapFunction(context, "Vehicle");
                },
                child: createCategoryContainer("Vehicle")),
            InkWell(
                onTap: () {
                  onTapFunction(context, "Others");
                },
                child: createCategoryContainer("Others")),
          ],
        ),
      ),
    );
  }
}

class ExplorePage extends StatelessWidget {
  final List data;

  const ExplorePage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: 0);

    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: controller,
        itemCount: data.length,
        itemBuilder: (context, index) {
          String imagePath = "https://mobileland.in/WallpaperAdmin/public/images/" + data[index]['image'];
          return Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: const Color(0xff232121),
                child: CachedNetworkImage(
                  imageUrl: imagePath,
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 16.0,
                right: 16.0,
                child: FloatingActionButton(
                  backgroundColor: Color(0x6b2076da),
                  onPressed: () {
                    // Add your wallpaper setting logic here for this particular image
                    // You can use data[index] to get information about this image
                    _showWallpaperOptions(context, imagePath,data[index]['image']);
                  },
                  child: Icon(Icons.add,
                    color: Colors.white,
                    size: 30,),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


void _showWallpaperOptions(BuildContext context, String imagePath,String imagename) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
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
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.home,color: Colors.teal,),
              title: Text('Set as Home Screen', style: TextStyle(color: Colors.teal),),
              onTap: () async {
                // Implement set as home screen logic
                _setWallpaper(imagePath, WallpaperManager.HOME_SCREEN,context);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.lock,color: Colors.teal,),
              title: Text('Set as Lock Screen', style: TextStyle(color: Colors.teal),),
              onTap: () {
                // Implement set as lock screen logic
                _setWallpaper(imagePath, WallpaperManager.LOCK_SCREEN,context);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.phonelink_lock,color: Colors.teal,),
              title: Text('Set as Both', style: TextStyle(color: Colors.teal),),
              onTap: () {
                // Implement set as both home and lock screen logic
                _setWallpaper(imagePath, WallpaperManager.BOTH_SCREEN,context);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.download,color: Colors.teal,),
              title: Text('Download', style: TextStyle(color: Colors.teal),),
      onTap: () async {
      Navigator.pop(context);
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
      String savePath = picturesPath+"/"+ imagename;

      await dio.download(imagePath, savePath);

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
      }}
            ),
          ],
        ),
      );
    },
  );
}
Future<void> _setWallpaper(String imagePath, int wallpaperType, BuildContext context) async {
  try {
    var file = await DefaultCacheManager().getSingleFile(imagePath);
    final bool result = await WallpaperManager.setWallpaperFromFile(file.path, wallpaperType);
    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wallpaper set successfully.'),
          padding: EdgeInsets.only(bottom: 200.0),

        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to set wallpaper.'),
          padding: EdgeInsets.only(bottom: 50.0), // Adjust bottom padding as needed
        ),
      );
    }
  } catch (e) {
    print(e.toString());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to set wallpaper: ${e.toString()}'),
      ),
    );
  }
}

