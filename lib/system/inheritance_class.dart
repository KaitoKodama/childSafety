
//-------------- フィールド名(user_info)用クラス ----------------
class UserDetail{
  UserDetail(Map<String, dynamic> mapRef){
    this.userID = mapRef['user_id'];
    this.userName = mapRef['user_name'];
    this.userComment = mapRef['user_comment'];
    this.userExplain = mapRef['user_exp'];
    this.userIconPath = mapRef['user_icon'];
    this.isLogout = mapRef['is_logout'];
    this.isSaved = true;
  }
  String? userID;
  String? userName;
  String? userComment;
  String? userExplain;
  String? userIconPath;
  bool? isLogout;
  bool? isSaved;
}

//-------------- フィールド名(child_info)用クラス ----------------
class UserChildDetail{
  UserChildDetail(Map<String, dynamic> mapRef){
    this.childIcon = mapRef['child_icon'];
    this.childName = mapRef['child_name'];
    this.childBirth = mapRef['child_birth'];

    this.childFavFood = mapRef['child_fav'];
    this.childHateFood = mapRef['child_hate'];
    this.childAllergy = mapRef['child_aller'];
    this.childPersonality = mapRef['child_person'];
    this.childExe = mapRef['child_exe'];
    this.isSaved = true;
  }
  String? childIcon;
  String? childName;
  String? childBirth;

  String? childFavFood;
  String? childHateFood;
  String? childAllergy;
  String? childPersonality;
  String? childExe;
  bool? isSaved;
}

//-------------- フィールド名(news_inc)用クラス ----------------
class MyselfIncNews{
  MyselfIncNews(Map<String, dynamic> mapRef){
    this.title = mapRef['title'];
    this.content = mapRef['content'];
  }
  String? title;
  String? content;
}