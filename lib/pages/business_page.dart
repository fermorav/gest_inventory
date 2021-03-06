import 'package:flutter/material.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../components/AppBarComponent.dart';
import '../components/ButtonMain.dart';
import '../data/firebase/FirebaseBusinessDataSource.dart';
import '../data/models/Business.dart';
import '../utils/icons.dart';

class BusinessPage extends StatefulWidget {
  const BusinessPage({Key? key}) : super(key: key);

  @override
  State<BusinessPage> createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> {
  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );

  late final FirebaseBusinessDataSource _businessDataSource =
      FirebaseBusinessDataSource();

  String? businessId;
  String? userPosition; 
  Business? _business;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _getArguments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        textAppBar: title_info_business,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Container(
                  padding: _padding,
                  child: Text(
                    _business!.nombreNegocio,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                Container(
                  height: 30,
                  margin: const EdgeInsets.only(
                      left: 200, top: 10, right: 10, bottom: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _business!.activo ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(45),
                  ),
                  child: Text(
                    _business!.activo ? "Activo" : "Desactivado",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  padding: _padding,
                  child: _labelText("Propeitario: ", false),
                ),
                Container(
                  padding: _padding,
                  child: _labelText(_business!.nombreDueno, true),
                ),
                Container(
                  padding: _padding,
                  child: _labelText("Direcci??n: ", false),
                ),
                Container(
                  padding: _padding,
                  child: _labelText(_business!.direccion.toString(), true),
                ),
                Container(
                  padding: _padding,
                  child: _labelText("Tel??fono: ", false),
                ),
                Container(
                  padding: _padding,
                  child: _labelText(_business!.telefono.toString(), true),
                ),
                Container(
                  padding: _padding,
                  child: _labelText("Correo: ", false),
                ),
                Container(
                  padding: _padding,
                  child: _labelText(_business!.correo, true),
                ),
                Container(
                  padding: _padding,
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Empleados: ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      ButtonMain(
                        text: button_see_employees,
                        isDisabled: true,
                        onPressed: () {
                          _nextScreenArgs(list_employees_route, _business!.id, userPosition.toString());
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: Visibility(
        child: FloatingActionButton(
          onPressed: () {
            _nextScreenArgsBusiness(edit_business_route, _business!);
          },
          backgroundColor: primaryColor,
          child: getIcon(AppIcons.edit),
        ),
        visible: userPosition == "[Administrador]" ? true : false,
      ),
    );
  }

  void _getArguments() {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    if (args.isEmpty) {
      Navigator.pop(context);
      return;
    }

    businessId = args[business_id_args];
    userPosition = args[user_position_args];
    _getBusiness(businessId!);
  }

  void _getBusiness(String id) async {
    _businessDataSource.getBusiness(id).then((business) => {
          if (business != null)
            {
              setState(() {
                _business = business;
                _isLoading = false;
              }),
            }
        });
  }

  void _nextScreenArgsBusiness(String route, Business business) {
    final args = {business_args: business};
    Navigator.pushNamed(context, route, arguments: args);
  }

  void _nextScreenArgs(String route, String businessId, String userPosition) {
    final args = {business_id_args: businessId, user_position_args: userPosition};
    Navigator.pushNamed(context, route, arguments: args);
  }

  Text _labelText(String text, bool right) {
    return Text(
      text,
      textAlign: right ? TextAlign.right : TextAlign.left,
      style: TextStyle(
        color: right ? Colors.black87 : primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
    );
  }
}
