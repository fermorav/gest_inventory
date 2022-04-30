import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/components/ProductComponent.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/data/models/Sales.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/strings.dart';

import '../components/SalesComponent.dart';
import '../data/framework/FirebaseAuthDataSource.dart';
import '../data/framework/FirebaseSalesDataSource.dart';
import '../data/framework/FirebaseUserDataSource.dart';
import 'package:gest_inventory/data/framework/FirebaseBusinessDataSource.dart';
import '../data/models/User.dart';
import '../utils/colors.dart';
import '../utils/routes.dart';

class AllSalesPage extends StatefulWidget {
  const AllSalesPage({Key? key}) : super(key: key);

  @override
  State<AllSalesPage> createState() => _AllSalesPageState();
}

class _AllSalesPageState extends State<AllSalesPage> {
  final FirebaseAuthDataSource _authDataSource = FirebaseAuthDataSource();
  final FirebaseUserDataSource _userDataSource = FirebaseUserDataSource();
  late final FirebaseBusinessDataSource _businessDataSource = FirebaseBusinessDataSource();
  late final FirebaseSalesDataSource _salesDataSource = FirebaseSalesDataSource();

  String? businessId;
  late Stream<List<Product>> _listProductStream;
  late Future<List<Sales>> _listSalesStream;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _getArguments();
      _listProductStream = _businessDataSource.getProducts(businessId!).asStream();
      _listSalesStream = _salesDataSource.getTableSales(businessId!);
      //_listUsers();
    });
    super.initState();
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        textAppBar: "Historial de Ventas",
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: isLoading
          ? waitingConnection()
          : FutureBuilder<List<Sales>>(
              future: _listSalesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return hasError("Error de Conexión");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return waitingConnection();
                }
                if (snapshot.data!.isEmpty) {
                  return hasError("Historial Vacio");
                }
                if (snapshot.hasData) {
                  return _component(snapshot.data!);
                }

                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
      /*floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () => _nextScreenArgs(add_product_page, businessId!),//Cambiar al de registrar producto
        child: Icon(Icons.add),
      ),*/
    );
  }

  void _getArguments() {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    if (args.isEmpty) {
      Navigator.pop(context);
      return;
    }
    businessId = args[business_id_args];
    setState(() {
      isLoading = false;
    });
  }

  void _nextScreenArgs(String route, String businessId) {
    final args = {business_id_args: businessId};
    Navigator.pushNamed(context, route, arguments: args);
  }

  Widget _component(List<Sales> sales) {
    return ListView.builder(
      itemCount: sales.length,
      itemBuilder: (contex, index) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: SalesComponent(
            sales: sales[index],
          ),
        );
      },
    );
  }

  Center waitingConnection() {
    return Center(
      child: SizedBox(
        child: CircularProgressIndicator(
          strokeWidth: 5,
        ),
        width: 75,
        height: 75,
      ),
    );
  }

  Center hasError(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}