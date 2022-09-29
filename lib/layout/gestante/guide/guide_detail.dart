// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:gest_app/data/model/guide.dart';
import 'package:gest_app/service/guides_service.dart';

import '../../../utilities/designs.dart';

class GuideDetailPage extends StatefulWidget {
  final String guideId;
  const GuideDetailPage({required this.guideId});

  @override
  State<GuideDetailPage> createState() => _GuideDetailPageState();
}

class _GuideDetailPageState extends State<GuideDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<Guide>(
        future: getGuideById(widget.guideId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: const Text("No se encontró información para esta guía"),
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    //! Title
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      snapshot.data!.title!,
                      style: kTitulo1,
                    ),
                  ),
                  Padding(
                    //! Short Description
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      snapshot.data!.shortDescription!,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Padding(
                    //! Thumbnail
                    padding: const EdgeInsets.all(8.0),
                    child: Hero(
                      tag: 'imgGuia',
                      child: Image(
                        image: NetworkImage(snapshot.data!.thumbnail!),
                      ),
                    ),
                  ),
                  Padding(
                    //! Large Description
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      snapshot.data!.largeDescription!,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Future<Guide> getGuideById(String id) {
  GuideService guideService = GuideService();
  return guideService.getGuideByID(id);
}
