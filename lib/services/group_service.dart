import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class GroupService {
  Future<String> generateJoinCode() async {
    const uuid = Uuid();
    String code;
    bool exists = true;
    do {
      code = uuid.v4().substring(0, 6).toUpperCase();
      final result = await FirebaseFirestore.instance
          .collection('groups')
          .where('joinCode', isEqualTo: code)
          .get();
      exists = result.docs.isNotEmpty;
    } while (exists);
    
      return code;
    
  }
  
}
