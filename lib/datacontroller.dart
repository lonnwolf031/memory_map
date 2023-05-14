//import 'package:flutter/widgets.dart';

/*

void example() async{
  WidgetsFlutterBinding.ensureInitialized();
  sqliteservice memoDb = MemoDbProvider();

  final memo = MemoModel(
    id: 1,
    title: 'Title 1',
    content: 'Note 1',
  );

  await memoDb.addItem(memo);
  var memos = await memoDb.fetchMemos();
  print(memos[0].title); //Title 1

  final newmemo = MemoModel(
    id: memo.id,
    title: 'Title 1 changed',
    content: memo.content,
  );

  await memoDb.updateMemo(memo.id, newmemo);
  var updatedmemos = await memoDb.fetchMemos();
  print(updatedmemos[0].title); //Title 1 changed

  await memoDb.deleteMemo(memo.id);
  print(await memoDb.fetchMemos()); //[]

}
 */