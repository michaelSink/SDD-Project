class Vault {
  static const COLLECTION = "vault";
  static const PICTURES = "pictures";
  static const QUOTES = "quotes";
  static const SONGS = "songs";
  static const STORIES = "stories";
  static const VIDEOS = "videos";
  static const OWNER = "owner";
  static const PLAYLIST = "playlists";

  String owner;
  String docId;
  List<Songs> songs;
  List<Stories> stories;
  List<Picture> pictures;
  List<Quotes> quotes;
  List<Videos> videos;
  List<dynamic> playlists;

  Vault({
    this.owner,
    this.pictures,
    this.quotes,
    this.songs,
    this.stories,
    this.videos,
    this.docId,
    this.playlists,
  }) {
    this.playlists ??= ["Happy"];
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      OWNER: owner,
      PLAYLIST: playlists,
    };
  }

  static Vault deserialize(data, String doc, List<Picture> pics, List<Songs> songs, List<Videos> vids, List<Quotes> quotes, List<Stories> stories) {
    return Vault(
        docId: doc,
        owner: data[Vault.OWNER],
        playlists: data[Vault.PLAYLIST],
        quotes: quotes,
        songs: songs,
        stories: stories,
        videos: vids,
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
  static const CATEGORY = "category";

  String name;
  String category;
  String docId;

  Songs({
    this.name,
    this.category,
    this.docId,
  }) {}

  Map<String, dynamic> serialize(){
    return <String, dynamic>{
      NAME: name,
      CATEGORY: category,
    };
  }

  static Songs deserialize(Map<String, dynamic> data, String doc){
    return Songs(
      name: data[Songs.NAME],
      category: data[Songs.CATEGORY],
      docId: doc,
      );
  }
}

class Videos {
  static const NAME = "name";
  static const IMAGE_FOLDER = "Videos";
  static const CATEGORY = "category";

  String name;
  String category;
  String docId;

  Videos({
    this.name,
    this.category,
    this.docId,
  }) {}

    Map<String, dynamic> serialize(){
    return <String, dynamic>{
      NAME: name,
      CATEGORY: category,
    };
  }

    static Videos deserialize(Map<String, dynamic> data, String doc){
    return Videos(
      name: data[Videos.NAME],
      category: data[Videos.CATEGORY],
      docId: doc,
      );
  }

}

class Quotes {
  static const QUOTE = "quote";
  static const CATEGORY = "category";

  String quote;
  String category;
  String docId;

  Quotes({
    this.quote,
    this.category,
    this.docId,
  }) {}

    Map<String, dynamic> serialize(){
    return <String, dynamic>{
      QUOTE: quote,
      CATEGORY: category,
    };
  }

    static Quotes deserialize(Map<String, dynamic> data, String doc){
    return Quotes(
      quote: data[Quotes.QUOTE],
      category: data[Quotes.CATEGORY],
      docId: doc,
      );
  }
}

class Stories {
  static const STORY = "story";
  static const TITLE = "title";

  String story;
  String title;
  String docId;

  Stories({
    this.title,
    this.story,
    this.docId,
  }) {}

    Map<String, dynamic> serialize(){
    return <String, dynamic>{
      TITLE: title,
      STORY: story
    };
  }

    static Stories deserialize(Map<String, dynamic> data, String doc){
    return Stories(
      title: data[Stories.TITLE],
      story: data[Stories.STORY],
      docId: doc,
      );
  }
}