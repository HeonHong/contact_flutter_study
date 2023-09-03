import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

void main() {
  runApp(MaterialApp(
      home:MyApp()
  ));
}

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {

  getPermission() async{
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      print('허락됨');
      var contacts = await ContactsService.getContacts();
      // print(contacts[0].familyName);

      // var newPerson = Contact();
      // newPerson.givenName = '민수';
      // newPerson.familyName = '김';
      // ContactsService.addContact(newPerson);
      setState(() {
        name = contacts;
      });

    } else if (status.isDenied) {
      print('거절됨');
      Permission.contacts.request();
      openAppSettings();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // getPermission();
  }

  int total = 3;
  List<Contact> name=[];
  List<int> like=[0,0,0];
  // List<ContactAdd> contact=[
  //   ContactAdd('김영숙',01053020621),
  //   ContactAdd('홍길동',01088888821),
  //   ContactAdd('피자짓',021110052),
  // ];

  addOne(familyName,givenName){
   setState(() {
     
     if(!familyName.isEmpty && !givenName.isEmpty){
       // ContactAdd cAdd = new ContactAdd(nameInput, numberInput);
       // contact.add(cAdd);

       var newPerson = Contact();
       newPerson.givenName = givenName;
       newPerson.familyName = familyName;


       ContactsService.addContact(newPerson);

      getPermission();

       Navigator.pop(context);

     }



     

   });
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       floatingActionButton: FloatingActionButton(
         child:Text('추가하기'),
         onPressed: (){
           showDialog(context: context, builder: (context){
             return Dialog(
                  child: DialogUi(sendTotal : total, sendAddOne:addOne)

             );
           });
         },
       ),
       appBar: AppBar(
         title: Text('앱이에요'),
         actions: [
           TextButton(onPressed: (){
             setState(() {
               // contact.sort((a,b)=>a.name.compareTo(b.name));
             });

           }, child: Text('정렬')),
           IconButton(onPressed: (){
             getPermission();
           }, icon: Icon(Icons.contacts))
         ],
       ),
       body: ListView.builder(
         itemCount: name.length,
         itemBuilder: (context,i){
           return ListTile(
             leading: Icon(Icons.account_circle),
             title: Text(name[i].displayName??'이름 없음'),
             // subtitle: Text(contact[i].number.toString()),
             trailing: TextButton(
               child: Text('삭제'),
               onPressed: (){
                  setState(() {
                      // contact.removeAt(i);
                  });
               },
             ),
           );
         },
       ),
       bottomNavigationBar: BottomItem() ,
     );

  }
}

class ContactAdd{
  String name;
  int number;

  ContactAdd(this.name, this.number);
}


class BottomItem extends StatelessWidget {
  const BottomItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        child: SizedBox(
        height: 50,
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
        Icon(Icons.phone),
    Icon(Icons.message),
    Icon(Icons.contact_page)
    ],
    ),
    )
    );
    }
}

class DialogUi extends StatelessWidget {
  //중괄호는 optional로 받을 파라미터라는 의미이다.
  //무조건 받으려면 중괄호 없이
  DialogUi({super.key, this.sendTotal, this.sendAddOne});
  
  //var로 해도 되지만 부모에서 온 거는 readOnly로 해놓는 게 낫다.
  final sendTotal;
  final sendAddOne;
  var inputData = TextEditingController();
  var familyName = '';
  var givenName='';
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Column(
        children: [
          TextField(onChanged: (text){
            familyName=text;
          },decoration: InputDecoration(
            icon:Icon(Icons.star),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.green,
                width:1.0,
              )
            )
          ),style: TextStyle(
            height: 0.5,


          )),
          TextField(onChanged: (text){
            givenName=text;
          },decoration: InputDecoration(
            icon:Icon(Icons.star),
            enabledBorder: UnderlineInputBorder(),
          ),),
          // TextField(onChanged:(number){
          //   inputNumber=number;
          // },keyboardType: TextInputType.number,inputFormatters: [FilteringTextInputFormatter.digitsOnly],),
          TextButton(onPressed: (){Navigator.pop(context);}, child: Text('Cancel')),
          // TextButton(onPressed: (){sendAddOne(inputData2, int.parse(inputNumber));}, child: Text('OK')),
          TextButton(onPressed: (){sendAddOne(familyName,givenName );}, child: Text('OK'))
        ],
      ),
    );
  }
}
