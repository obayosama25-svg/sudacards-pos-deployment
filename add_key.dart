import 'dart:convert';
import 'dart:io';

void main() async {
  final prefix = 'AAAAC3NzaC1lZDI1NTE5AAAAI';
  
  // Variations of characters in font:
  // H t [J] [l/I/1] [O/0] y m q f e w H 2 [i] [l/I/1] [O/0] 9 a / T N E U Q G C d B [I/l/1] [O/0] F N m V W m + q U T Y A
  final c_J = ['J'];
  final c_l1 = ['l', 'I', '1'];
  final c_O1 = ['O', '0'];
  final c_l2 = ['l', 'I', '1'];
  final c_O2 = ['O', '0'];
  final c_l3 = ['I', 'l', '1'];
  final c_O3 = ['O', '0'];

  for (var j in c_J) {
    for (var l1 in c_l1) {
      for (var o1 in c_O1) {
        for (var l2 in c_l2) {
          for (var o2 in c_O2) {
            for (var l3 in c_l3) {
              for (var o3 in c_O3) {
                final b64 = prefix + 'Ht' + j + l1 + o1 + 'ymqfewH2i' + l2 + o2 + '9a/TNEUQGCdB' + l3 + o3 + 'FNmVWm+qUTYA';
                final fullKey = 'ssh-ed25519 ' + b64 + ' dokploy';
                
                final file = File('c:\\project\\sudacardspos\\deploy\\test_key.pub');
                file.writeAsStringSync(fullKey);

                final res = Process.runSync(
                  'C:\\Program Files\\GitHub CLI\\gh.exe',
                  ['repo', 'deploy-key', 'add', file.path, '-R', 'obayosama25-svg/sudacards-pos-deployment', '-t', 'dokploy-key'],
                );

                if (res.exitCode == 0) {
                  print('SUCCESS! Valid key: ' + fullKey);
                  return;
                }
              }
            }
          }
        }
      }
    }
  }
  print('None matched.');
}
