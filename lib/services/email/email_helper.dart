import 'package:enough_mail/enough_mail.dart';

class EmailHelper {
  void start() async {
    print('starting helper');
    var client = ImapClient();
    await client.connectToServer('simplecomputers101.com', 993, isSecure: true);
    var response =
        await client.login('pondhockey@simplecomputers101.com', 'mFCOUj}KreA]');
    if (response.isOkStatus) {
      var list = await client.listMailboxes();
      if (list.isOkStatus) {
        print('mailboxes: ${list.result}');
      }
    }
  }
}
