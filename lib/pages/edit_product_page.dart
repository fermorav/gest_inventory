import 'package:flutter/material.dart';
import 'package:gest_inventory/components/ButtonSecond.dart';
import 'package:gest_inventory/data/models/Business.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../components/AppBarComponent.dart';
import '../components/TextInputForm.dart';
import '../data/firebase/FirebaseBusinessDataSource.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({Key? key}) : super(key: key);

  @override
  State<EditProductPage> createState() =>
      _EditProductState();
}

class _EditProductState extends State<EditProductPage> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController precioMayoreoController = TextEditingController();
  TextEditingController precioUnitarioController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController ventaMesController = TextEditingController();
  TextEditingController ventaSemanaController = TextEditingController();

  late String idNegocio, negocio;
  String? product;
  Product? _product;
  Business? _business;
  String? _nombreError;
  String? _precioMayoreoError;
  String? _precioUnitarioError;
  String? _stockError;
  String? _ventaSemanaError;
  String? _ventaMesError;

  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );

  late final FirebaseBusinessDataSource _businessDataSource =
      FirebaseBusinessDataSource();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _getArguments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        textAppBar: "Editar Producto",
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: _isLoading
          ? waitingConnection()
          : ListView(
              children: [
                TextInputForm(
                  hintText: "Nombre del Producto",
                  labelText: "Nombre del Producto",
                  controller: nombreController,
                  inputType: TextInputType.name,
                  onTap: () {},
                  errorText: _nombreError,
                ),
                TextInputForm(
                  hintText: "Precio Unitario",
                  labelText: "Precio Unitario",
                  controller: precioUnitarioController,
                  inputType: TextInputType.number,
                  onTap: () {},
                  errorText: _precioUnitarioError,
                ),
                TextInputForm(
                  hintText: "Precio Mayoreo",
                  labelText: "Precio Mayoreo",
                  controller: precioMayoreoController,
                  inputType: TextInputType.number,
                  onTap: () {},
                  errorText: _precioMayoreoError,
                ),
                TextInputForm(
                  hintText: "Stock",
                  labelText: "Stock",
                  controller: stockController,
                  inputType: TextInputType.number,
                  onTap: () {},
                  errorText: _stockError,
                ),
                TextInputForm(
                  hintText: "Ventas a la Semana",
                  labelText: "Ventas a la Semana",
                  controller: ventaSemanaController,
                  inputType: TextInputType.number,
                  onTap: () {},
                  errorText: _ventaSemanaError,
                ),
                TextInputForm(
                  hintText: "Ventas al Mes",
                  labelText: "Ventas al Mes",
                  controller: ventaMesController,
                  inputType: TextInputType.number,
                  onTap: () {},
                  errorText: _ventaMesError,
                ),
                Container(
                  padding: _padding,
                  height: 80,
                  child: ButtonSecond(
                    onPressed: _saveData,
                    text: button_save,
                  ),
                ),
              ],
            ),
    );
  }

  void _getArguments() {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    if (args.isEmpty) {
      Navigator.pop(context);
      return;
    }

    _product = args[product_args];

    nombreController.text = _product!.nombre;
    precioMayoreoController.text = _product!.precioMayoreo.toString();
    precioUnitarioController.text = _product!.precioUnitario.toString();
    stockController.text = _product!.stock.toString();
    ventaMesController.text = _product!.ventaMes.toString();
    ventaSemanaController.text = _product!.ventaSemana.toString();

    idNegocio = _product!.idNegocio.toString();

    _businessDataSource.getBusiness(idNegocio).then((business) => {
      if (business != null)
        {
          setState(() {
            _business = business;
            negocio = _business!.nombreNegocio.toString();
            _isLoading = false;
          }),
        }
      else
        {print(business?.id)}
    });
  }

  void _saveData() async {
    _nombreError = null;
    _precioMayoreoError = null;
    _precioUnitarioError = null;
    _stockError = null;
    _ventaSemanaError = null;
    _ventaMesError = null;

    if (nombreController.text.isEmpty) {
      setState(() {
        _nombreError = "El nombre del producto no puede quedar vac??o";
      });

      return;
    }

    if (precioMayoreoController.text.isEmpty) {
      setState(() {
        _precioMayoreoError = "El precio de mayoreo no puede quedar vac??o";
      });

      return;
    }

    if (precioUnitarioController.text.isEmpty) {
      setState(() {
        _precioUnitarioError = "El precio unitario no puede quedar vac??o";
      });

      return;
    }

    if (stockController.text.isEmpty) {
      setState(() {
        _stockError = "El stock no puede quedar vac??o";
      });

      return;
    }

    if (ventaMesController.text.isEmpty) {
      setState(() {
        _ventaMesError = "Las ventas al mes no puede quedar vac??a";
      });

      return;
    }

    if (ventaSemanaController.text.isEmpty) {
      setState(() {
        _ventaSemanaError = "Las ventas a la semana no puede quedar vac??a";
      });

      return;
    }

    setState(() {
      _isLoading = true;
    });

    _product?.nombre = nombreController.text;
    _product?.precioMayoreo = double.parse(precioMayoreoController.text);
    _product?.precioUnitario = double.parse(precioUnitarioController.text);
    _product?.stock = double.parse(stockController.text);
    _product?.ventaSemana = int.parse(ventaSemanaController.text);
    _product?.ventaMes = int.parse(ventaMesController.text);

    if (_product != null &&
        await _businessDataSource.updateProduct(_product!)) {
      _showToast("Datos actualizados");
      _nextScreenArgs(optionsList_product_page, _product!.idNegocio);
    } else {
      _showToast("Error al actualizar los datos");
    }
  }

  void _nextScreenArgs(String route, String businessId) {
    final args = {business_id_args: businessId};
    Navigator.popAndPushNamed(context, route, arguments: args);
  }

  void _showToast(String content) {
    final snackBar = SnackBar(
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
}
