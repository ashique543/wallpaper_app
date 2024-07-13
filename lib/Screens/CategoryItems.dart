import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Home/NavBar.dart';
import 'fullimage.dart';

class CategoryItems extends StatefulWidget {
  final category;
  final List data;
  const CategoryItems({super.key, this.category, required this.data});

  @override
  State<CategoryItems> createState() => _CategoryItemsState();
}

class _CategoryItemsState extends State<CategoryItems> {
  @override
  Widget build(BuildContext context) {
    // Filter data to include only items from the 'Anime' category
    List categoryData = widget.data.where((item) => item['category'] == widget.category).toList();
    return Scaffold(
      backgroundColor: Color(0xff232121),

      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.teal),
          title:  Text(widget.category, style: GoogleFonts.roboto(color: Colors.white,fontSize: 25),),
          backgroundColor: Color(0xc6000000),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))),
          centerTitle: true,
          elevation: 8
      ),
      body:  widget.data.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          childAspectRatio: 2 / 4,
          mainAxisSpacing: 10,
        ),
        itemCount: categoryData.length,
        itemBuilder: (context, index) {
          String imagepath =
              "https://mobileland.in/WallpaperAdmin/public/images/" +
                  categoryData[index]['image'];
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullImage(
                        imageurl: imagepath,
                        imagename: categoryData[index]['image'],
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
    );
  }
}
