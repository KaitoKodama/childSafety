import 'package:child_safety01/component/cp_list.dart';
import 'package:child_safety01/component/footer.dart';
import 'package:child_safety01/component/header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UsagePage extends StatefulWidget{
  @override
  _UsagePageState createState() => _UsagePageState();
}

//プライバシーポリシーページ
class _UsagePageState extends State<UsagePage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationHead(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTitle('MAPAKO 利用規約'),
                ListContents(
                    '第1条　本利用規約について',
                    'アプリ利用規約（以下「本利用規約」といいます。）は、株式会社バーニーズ（以下「当社」といいます。）が本アプリ上で提供するサービスを、ユーザが利用する際の一切の行為に適用されます。本利用規約は、本サービスの利用条件を定めるものです。ユーザは、本利用規約に従い本サービスを利用するものとします。\n'
                    'ユーザは、本アプリをダウンロードした場合、本利用規約の全ての記載内容について同意したものとみなされます。\n'
                    '当社は、当社の判断により、本利用規約をいつでも任意の理由で変更することができるものとします。変更後の利用規約は、当社が別途定める場合を除いて、本アプリ上に表示した時点より効力を生じるものとします。\n'
                    'ユーザが、変更後の本利用規約に同意できない場合は、直ちに本アプリをユーザ自身のスマートフォン等の携帯端末（以下、「携帯端末」といいます）から削除するものとします。\n'
                    'ユーザが、本利用規約の変更の効力が生じた後に本サービスをご利用になる場合には、変更後の利用規約の全ての記載内容に同意したものとみなされます。'
                ),
                ListContents(
                    '第2条　利用条件等',
                    'ユーザは、自己の責任において本アプリをユーザ自身のスマートフォン等の携帯端末にダウンロードし、インストールするものとします。なお、本アプリが全ての携帯端末に対応することを保証するものではありません。\n'
                    'ユーザは、本アプリのダウンロードを完了し、その利用を開始することが可能になった時点から本アプリを利用することができます。なお、本アプリは、当該携帯端末のみにダウンロードおよびインストールできるものとします。\n'
                    '本アプリの著作権・その他の権利は、当社に帰属します。本規約は、明示的に定めがある場合を除き、ユーザに本アプリの著作権その他いかなる権利も移転することを許諾するものではありません。\n'
                    'ユーザは、次の行為を行ってはならないものとします。\n'
                    '① 本サービスに影響を与える外部ツールの利用・作成・頒布・販売等を行う行為。\n'
                    '② 本アプリを逆アセンブル、逆コンパイル、リバースエンジニアリング、その他本アプリのソースコード、構造、アイデア等を解析するような行為。\n'
                    '③ 本アプリを複製、送信、譲渡、貸与、翻訳、翻案、改変、他のソフトウェアと結合等する行為。\n'
                    '④ 本アプリに組み込まれているセキュリティデバイスまたはセキュリティコードを破壊するような行為。\n'
                    '⑤ その他、本アプリに関して本アプリ提供者が有する権利を侵害する行為。\n'
                    '⑥ 第三者が上記各行為を行うことを助長する行為。\n'
                    '⑦ 本アプリ及び本規約に基づく本アプリの利用権を第三者に再許諾、譲渡、移転またはその他の方法で処分する行為。\n'
                    '⑧ 本アプリに付されている著作権表示及びその他の権利表示を除去または変更する行為。\n'
                    '⑨ その他、当社が不適切と判断する行為。ユーザが本規約のいずれかの条項に違反したときは、ユーザに対して何時にても本規約に基づく本アプリの利用を終了させることができます。その場合、当社はユーザに対して何らの責任を負うものではありません。\n'
                    'ユーザは、課金に関しては、Google社の「Androidマーケット利用規約」に同意していることが前提となり、同規約に従うものとします。'
                ),
                ListContents(
                  '第3条 免責',
                   '当社は、本サービスの利用により発生したユーザの損害については、一切の賠償責任を負いません。\n'
                   'ユーザが、本サービスを利用することにより、第三者に対し損害を与えた場合、 ユーザは自己の費用と責任においてこれを賠償するものとします。\n'
                   '当社は本サービスに発生した不具合、エラー、障害等により本サービスが利用できないことによって引き起こされた損害について一切の賠償責任を負いません。本サービスは、当社がその時点で提供可能なものとします。当社は提供する情報、コンテンツおよびソフトウェア等の情報についてその完全性、正確性、適用性、有用性、利用可能性、 安全性、確実性等につきいかなる保証も一切しません。\n'
                   '当社はユーザに対して、適宜情報提供やアドバイスを行うことがありますが、その結果について責任を負わないものとします。\n'
                   '当社は、本アプリのバグその他を補修する義務および本アプリを改良または改善する義務は負いません。ただし、ユーザに本アプリのアップデート版またはバージョンアップ情報等を提供する場合があります。この場合、かかるアップデート版またはバージョンアップ情報等も本アプリとして扱い、これらにも本規約が当然に適用されます。\n'
                   '本サービスが何らかの外的要因によりデータ破損等をした場合、当社はその責任を負いません。'
                ),
                ListContents(
                  '第4条 法律の適用及び裁判管轄',
                  '1. 本規約は、日本法に準拠し、日本法によって解釈されるものとします。\n'
                  '2. 本規約に関する紛争については、東京地方裁判所または東京簡易裁判所を第一審の専属的合意管轄裁判所とします。'
                ),
                ListConclusion('以上'),
                ListConclusion('最終更新日：2021年8月3日'),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: ApplicationFoot(),
    );
  }
}