class Vault {
  static const COLLECTION = "vault";

  static const PICTURES = "pictures";
  static const QUOTES = "quotes";
  static const SONGS = "songs";
  static const STORIES = "stories";
  static const VIDEOS = "videos";
  static const OWNER = "owner";

  String owner;
  String docId;
  List<dynamic> songs;
  List<dynamic> stories;
  List<dynamic> videos;
  List<Picture> pictures;
  List<dynamic> quotes;

  List<Songs> _songs;
  List<String> _stories;
  List<Videos> _videos;

  Vault({
    this.owner,
    this.pictures,
    this.quotes,
    this.songs,
    this.stories,
    this.videos,
    this.docId,
  }) {
    this.quotes ??= [];
    this.songs ??= [];
    this.stories ??= [];
    this.videos ??= [];
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      OWNER: owner,
      QUOTES: quotes,
      SONGS: songs,
      STORIES: stories,
      VIDEOS: videos,
    };
  }

  static Vault deserialize(data, String doc, List<Picture> pics) {
    return Vault(
        docId: doc,
        owner: data[Vault.OWNER],
        quotes: data[Vault.QUOTES],
        songs: data[Vault.SONGS],
        stories: data[Vault.STORIES],
        videos: data[Vault.VIDEOS],
        pictures: pics,
    );
  }
}

//subclasses

class Picture {
  static const PHOTOPATH = "photoPath";
  static const PHOTOURL = "photoUrl";
  static const NAME = "name";
  static const IMAGE_FOLDER = "Photos";
  static const OWNER = "owner";

  String photoPath;
  String photoURL;
  String name;
  String owner;
  String docId;

  Picture({
    this.name,
    this.photoPath,
    this.photoURL,
    this.owner,
    this.docId,
  }) {}

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      NAME: name,
      PHOTOPATH: photoPath,
      PHOTOURL: photoURL,
      OWNER: owner,
    };
  }

   static Picture deserialize(Map<String, dynamic> data, String doc) {
    return Picture(
        name: data[Picture.NAME],
        photoPath: data[Picture.PHOTOPATH],
        photoURL: data[Picture.PHOTOURL],
        owner: data[Picture.OWNER],
        docId: doc,
    );
  }

}

class Songs {
  static const NAME = "name";
  static const IMAGE_FOLDER = "Songs";

  String name;

  Songs({
    this.name,
  }) {}
}

class Videos {
  static const NAME = "name";
  static const IMAGE_FOLDER = "Videos";

  String name;

  Videos({
    this.name,
  }) {}
}
