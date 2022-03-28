//■ 表示ステート
enum DisplayState{
  IsLoading,
  FriendExist,
  FriendDoesNotExist,
}

//■ フレンドリクエスト
enum RequestState{
  IsNotExist,
  IsSelfID,
  IsMultipleRequire,
  IsInFriendList,
  IsLogout,
  Accept,
}

//■ 出生順
enum ChildOrder{
  Error,
  male01,
  male02,
  male03,
  male04,
  male05,
  female01,
  female02,
  female03,
  female04,
  female05,
}