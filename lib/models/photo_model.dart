

import 'dart:convert';

PixabayImagesModel pixabayImagesModelFromJson(String str) => PixabayImagesModel.fromJson(json.decode(str));

String pixabayImagesModelToJson(PixabayImagesModel data) => json.encode(data.toJson());

class PixabayImagesModel {
  final String total;
  final String totalHits;
  final List<Photo> hits;

  PixabayImagesModel({
    required this.total,
    required this.totalHits,
    required this.hits,
  });

  factory PixabayImagesModel.fromJson(Map<String, dynamic> json) => PixabayImagesModel(
    total: json["total"].toString(),
    totalHits: json["totalHits"].toString(),
    hits: List<Photo>.from(json["hits"].map((x) => Photo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "totalHits": totalHits,
    "hits": List<dynamic>.from(hits.map((x) => x.toJson())),
  };
}

class Photo {
  final String id;
  final String pageUrl;
  final String type;
  final String tags;
  final String previewUrl;
  final String previewWidth;
  final String previewHeight;
  final String webformatUrl;
  final String webformatWidth;
  final String webformatHeight;
  final String largeImageUrl;
  final String imageWidth;
  final String imageHeight;
  final String imageSize;
  final String views;
  final String downloads;
  final String collections;
  final String likes;
  final String comments;
  final String userId;
  final String user;
  final String userImageUrl;
  final String noAiTraining;
  final String isAiGenerated;
  final String isGRated;
  final String isLowQuality;
  final String userUrl;
  final String name;

  Photo({
    required this.id,
    required this.pageUrl,
    required this.type,
    required this.tags,
    required this.previewUrl,
    required this.previewWidth,
    required this.previewHeight,
    required this.webformatUrl,
    required this.webformatWidth,
    required this.webformatHeight,
    required this.largeImageUrl,
    required this.imageWidth,
    required this.imageHeight,
    required this.imageSize,
    required this.views,
    required this.downloads,
    required this.collections,
    required this.likes,
    required this.comments,
    required this.userId,
    required this.user,
    required this.userImageUrl,
    required this.noAiTraining,
    required this.isAiGenerated,
    required this.isGRated,
    required this.isLowQuality,
    required this.userUrl,
    required this.name,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
    id: json["id"].toString(),
    pageUrl: json["pageURL"].toString(),
    type: json["type"].toString(),
    tags: json["tags"].toString(),
    previewUrl: json["previewURL"].toString(),
    previewWidth: json["previewWidth"].toString(),
    previewHeight: json["previewHeight"].toString(),
    webformatUrl: json["webformatURL"].toString(),
    webformatWidth: json["webformatWidth"].toString(),
    webformatHeight: json["webformatHeight"].toString(),
    largeImageUrl: json["largeImageURL"].toString(),
    imageWidth: json["imageWidth"].toString(),
    imageHeight: json["imageHeight"].toString(),
    imageSize: json["imageSize"].toString(),
    views: json["views"].toString(),
    downloads: json["downloads"].toString(),
    collections: json["collections"].toString(),
    likes: json["likes"].toString(),
    comments: json["comments"].toString(),
    userId: json["user_id"].toString(),
    user: json["user"].toString(),
    userImageUrl: json["userImageURL"].toString(),
    noAiTraining: json["noAiTraining"].toString(),
    isAiGenerated: json["isAiGenerated"].toString(),
    isGRated: json["isGRated"].toString(),
    isLowQuality: json["isLowQuality"].toString(),
    userUrl: json["userURL"].toString(),
    name: json["name"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "pageURL": pageUrl,
    "type": type,
    "tags": tags,
    "previewURL": previewUrl,
    "previewWidth": previewWidth,
    "previewHeight": previewHeight,
    "webformatURL": webformatUrl,
    "webformatWidth": webformatWidth,
    "webformatHeight": webformatHeight,
    "largeImageURL": largeImageUrl,
    "imageWidth": imageWidth,
    "imageHeight": imageHeight,
    "imageSize": imageSize,
    "views": views,
    "downloads": downloads,
    "collections": collections,
    "likes": likes,
    "comments": comments,
    "user_id": userId,
    "user": user,
    "userImageURL": userImageUrl,
    "noAiTraining": noAiTraining,
    "isAiGenerated": isAiGenerated,
    "isGRated": isGRated,
    "isLowQuality": isLowQuality,
    "userURL": userUrl,
    "name": name,
  };
}
