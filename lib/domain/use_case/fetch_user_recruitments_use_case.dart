import 'package:flutter_clean_architecture/core/clean/use_case.dart';

abstract class FetchUserRecruitmentsUseCaseInput implements UseCaseInput {
  /// 指定されたユーザが作成した募集情報のみ取得する
  Future<void> fetchUserRecruitments(
      FetchUserRecruitmentsUseCaseOutput output, int userId);
}

abstract class FetchUserRecruitmentsUseCaseOutput implements UseCaseOutput {
  /// 指定されたユーザが作成した募集情報に失敗した時
  void onFailedToFetchUserRecruitments(Exception error);

  /// 取得処理中
  void onFetchingUseRecruiments();
}
