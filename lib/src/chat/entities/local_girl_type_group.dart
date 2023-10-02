import 'package:gem_dubi/src/chat/entities/approved_users.dart';
import 'package:gem_dubi/src/chat/entities/girl_type_category.dart';

class LocalGirlTypeGroup {
  final GirlTypeCategory girlTypeCategory;
  final List<ApprovedUsers> userList;

  LocalGirlTypeGroup({
    required this.girlTypeCategory,
    required this.userList,
  });
}
