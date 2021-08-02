import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HorizonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Categories(
            image_location:'images/admin.png',
            image_caption: 'AO THE THAO',
          ),
          Categories(
            image_location:'images/admin.png',
            image_caption: 'AO THE THAO',
          ),Categories(
            image_location:'images/admin.png',
            image_caption: 'AO THE THAO',
          ),Categories(
            image_location:'images/admin.png',
            image_caption: 'AO THE THAO',
          ),Categories(
            image_location:'images/admin.png',
            image_caption: 'AO THE THAO',
          ),Categories(
            image_location:'images/admin.png',
            image_caption: 'AO THE THAO',
          ),Categories(
            image_location:'images/admin.png',
            image_caption: 'AO THE THAO',
          )
        ],
      ),
    );
  }
}
class Categories extends StatelessWidget {
  final String image_location;
  final String image_caption;
  Categories(
      {this.image_location, this.image_caption});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(2.0),
      child: InkWell(onTap: (){},
        child: Container( width: 100.0,
          child: ListTile(
            title: Image.asset(image_location,
              width: 100.0,
              height: 80.0,),
            subtitle: Container(
              alignment: Alignment.topCenter,
              child: Text(image_caption,style: new TextStyle(fontSize: 12.0),),
            ),
          ),
        ),
      ),
    );
  }
}

