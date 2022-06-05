import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Database/cloud_utils.dart';
import '../Database/models.dart';
import '../widgets/dialogs.dart';
import '../widgets/accessories.dart';


class HymnPage extends StatefulWidget {
  const HymnPage({Key? key}) : super(key: key);

  @override
  _HymnPageState createState() => _HymnPageState();
}

class _HymnPageState extends State<HymnPage> {

  dynamic Stream = HymnsDB.getAllHymns();
  Widget HymnsTile(String text,TextStyle style,FaIcon icon){
    return Row(
      children: [
        icon,
        SizedBox(width: 10,),
        Expanded(
          child: Text(
            text,
            style: style,
          ),
        )
      ],
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white60,
        child: StreamBuilder(
          stream: Stream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> n) {
            Set _dates = Set();List dates = [];int docLength=(n.hasData)?n.data!.docs.length:0;
            for(int x=0;x<docLength;x++){
              _dates.add(n.data!.docs[x]["timestamp"]!.toDate().toString().split('.')[0].split(' ')[0]);
              dates = List.from(_dates);
            }
            return (n.connectionState == ConnectionState.waiting) ? Center(child: gradientCirclePBar()) :
            ((docLength==0) ? Center(child: Text("No records available")):
            Column(
              children: [
                SizedBox(height:10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.music,color: Colors.purple),
                    SizedBox(width:10),
                    Text("$docLength",style: TextStyle(fontFamily:"Times New Roman",color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                    itemCount: dates.length,
                    itemBuilder: (context, index) {
                      String date = dates[index];
                      return Column(
                        children: [
                          SizedBox(height: 20),
                          Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.lightBlue[100],
                              ),
                              child: Text(date,style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 13),textAlign: TextAlign.center,)),
                          SizedBox(height: 15),
                          Divider(color: Colors.red,thickness: 0.3,indent: 5,endIndent: 5),
                          ...n.data!.docs.map(
                                  (n){
                                Hymns hymn = Hymns.fromMap(n.data() as Map<String,dynamic>);
                                DateTime _timestamp = hymn.timestamp
                                    .toDate(); // Convert TimeStamp to DateTime
                                List<String> timestamp = _timestamp.toString().split(
                                    '.')[0].split(' ');//Convert DateTime to String
                                return (date == timestamp[0]) ?
                                GestureDetector(
                                  onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder:(context)=>hymnInfoDialog(hymn))),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          elevation: 5.0,
                                          child: ListTile(
                                            title: HymnsTile(hymn.title,
                                                TextStyle(fontSize: 14,fontFamily: "Times New Roman",
                                                    fontWeight: FontWeight.w600),
                                                FaIcon(FontAwesomeIcons.music,
                                                  color: Colors.blueGrey, size: 15,)),
                                            leading: Hero(tag:"image",child: Image.asset(DataUtils.mainLogo,fit: BoxFit.cover,width: 35,height: 35,)),
                                            trailing: Text(timestamp[1].substring(0,5),style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ):SizedBox();
                              }
                          ).toList(),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height:40)
              ],
            ));
          },
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
