
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:odalvinoeventoapp/presentations/screens/home/car_shop.dart';
import 'package:odalvinoeventoapp/presentations/screens/home/design/animation_car.dart';
import 'package:odalvinoeventoapp/presentations/screens/home/hardcode_products.dart';
import 'package:odalvinoeventoapp/presentations/screens/home/helpers/help_home_cards.dart';
import 'package:odalvinoeventoapp/presentations/screens/home/providers/product_provider.dart';
import 'package:odalvinoeventoapp/presentations/screens/home/qr_scanner/qr_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';



    double _scrollPosition = 0.0; // Variable para guardar la posición del scroll


    TextEditingController searchBarController = TextEditingController();

  class HomeScreen extends StatefulWidget {
    final String? coupon;
    const HomeScreen({super.key,  this.coupon});
  
    @override
    State<HomeScreen> createState() => _HomeScreenState();
  }
  
  class _HomeScreenState extends State<HomeScreen> {
    // Controladores de texto
    final ScrollController _scrollController = ScrollController();

    // Variables
    List<dynamic> filteredProducts = [];
    bool isSelectedHomeModule = true;
    bool isSelectedCarShopingModule = false; 
    dynamic carShopNew = {};
    List listProducts = [];
    List? content;
    Map? coupon;    

   void filteredProduct() {
    setState(() {
      filteredProducts = listProducts.where((product) {
        final searchTerm = searchBarController.text.toLowerCase();
        final productName = product['product_name'].toString().toLowerCase();
        final productCat = product['product_brand'].toString().toLowerCase();
        final barCode = product['upc'].toString().toLowerCase();
        return productName.contains(searchTerm) || productCat.contains(searchTerm) || barCode.contains(searchTerm);
      }).toList();
    });
  }



void addProductsToCar(int index) {
  // Crear el mapa del producto a agregar al carrito


  carShop = jsonDecode(localStorage.getItem('carShop')!) ?? "";
      

  Map<String, dynamic> itemsForCarShop = {
    'id': index + 1,
    'fecha': DateFormat('dd/MM/yyyy').format(DateTime.now()),
    'product_name': filteredProducts[index]['product_name'],
    'product_brand': filteredProducts[index]['product_brand'],
    'image_url': filteredProducts[index]['image_url'],
    'stock': filteredProducts[index]['qty_on_hand'],
    'quantity': filteredProducts[index]['quantity'], 
    'product_id': filteredProducts[index]['m_product_id'],
    'precio': filteredProducts[index]['price_list'],
    'upc': filteredProducts[index]['upc'],
  };

  if(itemsForCarShop['quantity'] == 0){
    carShop.clear();
    return;
  }

  // Buscar si el producto ya existe en el carrito
  var existingProduct = carShop.firstWhere(
    (value) => value['product_id'] == itemsForCarShop['product_id'],
    orElse: () => {},
  );

  // Si el producto ya existe en el carrito
  if (existingProduct.isNotEmpty) {
    setState(() {
      // Incrementar la cantidad del producto existente
      existingProduct['quantity'] += itemsForCarShop['quantity'];
    });
  } else {
    // Si el producto no existe, añadirlo al carrito
    setState(() {
      carShop.add(itemsForCarShop);
    });
  }

  showDialog(context: context, builder: (context) {
       
        return AlertDialog(
            title:const Text('Success', style: TextStyle(fontFamily: 'AlegreyaSans Regular') ,),
            content: const Text('El producto fue adicionado ao carrinho', style: TextStyle(fontFamily: 'Neuton Regular', fontSize: 18),),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Row(
                children: [
                  Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(100)
                    ),
                    child: const Icon(Icons.check, color: Colors.white,)),
                    const SizedBox(width: 5,),
                  Container(
                    width: 65,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text('Aceptar', style: TextStyle(fontFamily: 'Neuton Regular', fontSize: 15, color: Colors.white),),
                    )),
                ],
              ))
            ],
        );

  },);

  // Guardar el carrito actualizado en el almacenamiento local
  localStorage.setItem('carShop', jsonEncode(carShop));

  // Obtener el carrito del almacenamiento local (opcional para depuración)
  var traerCarroLocalStorage = jsonDecode(localStorage.getItem('carShop')!);

  // Imprimir resultados para depuración
  print('Esto es el valor de traerCarroLocalStorage $traerCarroLocalStorage');
  print('Esto es el carshop en incremento $carShop');
}




 void increaseQuantity(int index) {
  carShop = jsonDecode(localStorage.getItem('carShop')!);

  print('Este es el valor de index $index');
    print('Este es el valor del producto ${filteredProducts[index]}');

    int qty = int.parse(filteredProducts[index]['quantity'].toString());
    double stock = double.parse(filteredProducts[index]['qty_on_hand'].toString() == '{@nil: true}'?  "0" : filteredProducts[index]['qty_on_hand'].toString());

  if (qty >= 0 && qty < stock) {
    
      setState(() {
       filteredProducts[index]['quantity']++;
        
      });

    

   }else{

      showDialog(context: context, builder: (context) {

            return const AlertDialog(
                      title: Text('Message', style:  TextStyle(fontFamily: 'Neuton Regular',),), 
                      content:  Text('Vino não disponível, estoque insuficiente', style: TextStyle(fontFamily: 'Neuton Regular'),),

            );

      }, );

   }

      carShopNew =  carShop.firstWhere((value) {

            return  value['m_product_id'] == index + 1;
            
          
          },orElse: () {
            return {};
          },);

    if(carShopNew.isNotEmpty){

        carShopNew['quantity'] =  filteredProducts[index]['quantity'];

    }
   localStorage.setItem('carShop', jsonEncode(carShop));

    var getCarritoLocal = localStorage.getItem('carShop');

    print('Este es el localstorage del carrito $getCarritoLocal');

    print('Esto es el carrito $carShop');
   

  }

  void decreaseQuantity(int index) {

    carShop = jsonDecode(localStorage.getItem('carShop')!);
  
//       Map<String, dynamic> itemsForCarShop =   {
//         'id':index +1 , 
//         'fecha': '06/07/2024',
//         'quantity': products[index]['quantity'],
//         'product_id': index + 1 ,
//         'precio': 23,
        

//       };

        carShopNew =  carShop.firstWhere((value) {

            return  value['product_id'] == index + 1;
            
          
          },orElse: () {
            return {};
          },);




    if(filteredProducts[index]['quantity'] <= 0){
      return;
    }

    // if(carShopNew['quantity'] <= 0){

    //     return;
    // }



    setState(() {

        filteredProducts[index]['quantity']--;

         if(carShopNew.isNotEmpty){

            carShopNew['quantity'] =  filteredProducts[index]['quantity'];

        }
      
    });

    localStorage.setItem('carShop', jsonEncode(carShop));

    print('Esto es el carshop en decrease $carShop');
    
  }

  void _saveScrollPosition() {
    _scrollPosition = _scrollController.position.pixels;
    
  }

  // Función para restaurar la posición guardada del scroll
  void _restoreScrollPosition() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollPosition);
      }
    });
  }

  void validateScreen() async {
    Directory supportDirectory = await getApplicationSupportDirectory();

        String filePath = '${supportDirectory.path}/.env';

        File configP = File(filePath);
         
         content = jsonDecode(await configP.readAsString());

            

         coupon = content?.firstWhere(
            (value) => value['cupon'] == widget.coupon,
            orElse: () => {}, // Return null if the coupon is not found
          );

          setState(() {
          });
          print('Este es el contenido $content');

  }

  @override
  void initState() {

      

      _scrollController.addListener(_saveScrollPosition);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        validateScreen();
      filteredProduct();
        if(filteredProducts.isEmpty){

            Provider.of<ProductProvider>(context, listen: false).getProductsWines();
        }
        });
            
        // products.clear();
        // localStorage.clear();
      // localStorage.setItem('carShop', '');

        var setearLocal = localStorage.getItem('carShop');
         setearLocal ?? localStorage.setItem('carShop', '[]');

        print('Esto es el valor del local Storage $setearLocal');

        super.initState();
  }

@override
  void dispose() {
    carShop.clear();

    super.dispose();
  }

    @override
    Widget build(BuildContext context) {

      final mediaScreen =  MediaQuery.of(context).size.width * 0.9;
      final heightScreen = MediaQuery.of(context).size.height * 0.9;
          _restoreScrollPosition();


      return Scaffold(

            body: Stack(
              children: [
                  Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/FONDO.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
                  
             GestureDetector(
              onTap: () {

                FocusScope.of(context).unfocus();

              } ,
               child:  coupon?['login'] == false ? const Center(child: CircularProgressIndicator()):  Scaffold(
                
                           backgroundColor: Colors.transparent,
                           appBar: PreferredSize(
                          
                preferredSize: const Size.fromHeight(190),
                
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                      children: [
                        const SizedBox(height: 70,),
                      
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset('lib/assets/logo@3x.png', width: 70,),
                            SizedBox(
                              width: mediaScreen *0.5,
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Bem-vindo', style: TextStyle(fontFamily: 'Neuton ExtraBold' ,color: Colors.white, fontSize: 35),),
                                  Text('Faça sua compra com o cupom', style: TextStyle(fontFamily: 'Neuton Regular', color: Colors.white),)
                                ],
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(right: 20),
                            //   child: GestureDetector(
                            //     onTap: () async {
                                 
                            //       String? barCode =  await Navigator.of(context).push(
                            //       MaterialPageRoute(
                            //         builder: (context) => QRScannerScreen(),
                            //       ),
                            //     );
                                 
                            //     if (barCode != null) {
                            //       setState(() {
                            //         searchBarController.text = barCode;
                            //        filteredProduct();
                            //       });
                            //     }
                            //     },
                            //     child: Image.asset('lib/assets/QR.png')),
                            // ),
                            
                          ],
                        ),
                          const SizedBox(height: 15,),
                        Container(
                          width: mediaScreen ,
                          decoration:  BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(55) ,
                          ),
                          child:  TextField(
                              controller: searchBarController,
                              onChanged: (value) {

                                  filteredProduct();

                              },
                              style:  const TextStyle(color: Color(0XFF053452)),
                              decoration: InputDecoration(
                                hintText: "Busqueda por nome o marca...",
                                hintStyle: TextStyle(fontFamily: 'Neuton Regular', color: const Color(0XFF053452).withOpacity(0.5),),
                                suffixIcon:  Icon(Icons.search, color: Color(int.parse('0XFF053452')),), 
                                contentPadding: const EdgeInsets.all(15),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none
                                )
                              ),
                                
                  
                          ),
                        ),
                      ],
                  
                  ),
                ),
                
                           ) ,
               
                 body:  Center(
                child: SizedBox(
                  width: mediaScreen,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                      
                    children: [
                    
                        SizedBox(height: heightScreen *0.05,),
                    Consumer<ProductProvider>(
                      builder: (context, productProvider, child) {
                        if (productProvider.isLoading) {
                          return const Center(child: CircularProgressIndicator(color: Colors.white));
                        }

                        if (productProvider.filteredProducts.isEmpty) {
                          return const Center(
                            child: Text(
                              'No products found',
                              style: TextStyle(fontFamily: 'Neuton Regular', color: Colors.white),
                            ),
                          );
                        }

                        // Asegúrate de que la lista tiene elementos antes de usar el GridView.builder
                        if (productProvider.filteredProducts.isEmpty) {
                          return const Center(
                            child: Text('No products found', style: TextStyle(color: Colors.white)),
                          );
                        }

                        if (listProducts.isEmpty) {
                              listProducts = productProvider.filteredProducts;
                              filteredProducts = List.from(productProvider.filteredProducts);
                            }
                        

                        return Expanded(
                          child: GridView.builder(
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            itemCount: filteredProducts.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                              childAspectRatio: 0.5,
                            ),
                            itemBuilder: (context, index) {
                              // Verificar si el índice está dentro del rango de la lista
                            

                              return HomeCards(
                                filteredProducts: filteredProducts,
                                index: index,
                                addProductsToCar: addProductsToCar,
                                increaseQuantity: increaseQuantity,
                                decreaseQuantity: decreaseQuantity,
                              );
                            },
                          ),
                        );
                      },
                    )



                  ],
                 ),
                ),
                           ), 

              bottomNavigationBar: Container(
              
                width: mediaScreen,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [

                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 7,
                      spreadRadius: 2,

                    ),

                  ]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 60, // Altura de la barra de navegación
                        color: Colors.white,
                        child: Center(
                          child: GestureDetector(
                            onTap: (){
                                setState(() {
                                  isSelectedHomeModule = true;
                                  isSelectedCarShopingModule = false;
                                });

                            // Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route)=> false, arguments: 0);
                            // Navigator.pushNamed(context,  '/home');
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen(), ) );

                            }, child: Image.asset('lib/assets/home@2x.png', width: 50, color: isSelectedHomeModule ? const Color(0xFF053452): Colors.grey,),),
                        ),
                      ),
                      Container(
                    
                        child: GestureDetector(
                          onTap: () {
                               setState(() {
                                  isSelectedHomeModule = false;
                                  isSelectedCarShopingModule = true;
                                });
                          // Navigator.pushNamedAndRemoveUntil(
                          //   context,
                          //   '/car-shop',
                          //   (Route<dynamic> route) => false,
                          //   arguments: 0,
                          // );
                          //  Navigator.pushNamed(context,  '/car-shop');

                          Navigator.push(context, MaterialPageRoute(builder: (context) => const CarShopScreen(  ),));

                          },

                          child: AnimatedShoppingCart( isSelectedCarShopingModule: isSelectedCarShopingModule , ) ,
                        ),
                      ),
                    ],
                  ),
                ),
              ),               
            ),
           )
          ],
        ),



      );
    }
  }












