
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:odalvinoeventoapp/presentations/screens/home/hardcode_products.dart';






  class CarShopScreen extends StatefulWidget {
    const CarShopScreen({super.key});
  
    @override
    State<CarShopScreen> createState() => _CarShopScreenState();
  }
  
  class _CarShopScreenState extends State<CarShopScreen> {
    // Controladores de texto

    // Variables

    bool isSelectedHomeModule = false;
    bool isSelectedCarShopingModule = true; 
    dynamic carShop = [];


  double calculateTotalCars(){

    double total = 0.0;

    for(var i = 0;  i < carShop.length; i++){

        total += carShop[i]['quantity'] * carShop[i]['precio'];

    }


    return total;

  }


  @override
  void initState() {

      var getCarshop = localStorage.getItem('carShop') ?? '';

        if(getCarshop == ''){
          print('Esto es el getCarshop $getCarshop');
          return;

        }
    carShop = jsonDecode(localStorage.getItem('carShop')!);

    print('este es el valor del carrito de compras al cargar el widget car_shop.dart $carShop');
    super.initState();
  }


    @override
    Widget build(BuildContext context) {

      final mediaScreen = MediaQuery.of(context).size.width * 0.9;
      final heightScreen = MediaQuery.of(context).size.height * 0.9;
      
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
               child: Scaffold(
                           backgroundColor: Colors.transparent,
                           appBar: const PreferredSize(
                
                preferredSize: Size.fromHeight(150),
                child: SingleChildScrollView(
                  child: Column(
                                 
                      children: [
                        SizedBox(height: 70,),
                  
                             Text('Carrinho de compras', style: TextStyle(fontFamily: 'Neuton ExtraBold' ,color: Colors.white, fontSize: 35),),
                  
                        
                      ],
                  
                  ),
                ),
                
                           ) ,
               
                           body: Center(
                child: Container(
                  width: mediaScreen,
                  child: Column(

                    children: [

                        SizedBox(height: heightScreen * 0.05,),

                        Expanded(
                          child: ListView.builder(
                            itemCount:carShop.length,                         
                            itemBuilder: (context, index) {
                              
                              print('Esto es el producto del carrito ${carShop[index]}');
                              
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  width: mediaScreen,
                                  height: heightScreen * 0.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                
                                  ),
                                  child: Row(
                                      children: [
                                            SizedBox(width: mediaScreen * 0.03,),
                                            Image.asset(products[index]['url_photo'],),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 0.0,vertical: 8),
                                              child: Container(
                                                width: mediaScreen * 0.36 ,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                
                                                      Text(products[index]['name'], style: const TextStyle(fontSize: 13,fontFamily: 'Neuton Regular', color: Color(0XFF053452) ), ),
                                                      Text(products[index]['cat'], style: const TextStyle(fontSize: 11,fontFamily: 'Neuton Regular', color: Color(0XFFB47C2D)),),
                                                  ],
                                                ),
                                              ),
                                            ),
                                                        Row(
                                                  
                                                  children: [
                                      
                                                  GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                    
                                                          // decreaseQuantity(index);
                                                    
                                                        },);
                                                                                  
                                                      },
                                                  child: Image.asset('lib/assets/menos@2x.png', width: 15,)),
                                                                               const SizedBox(width: 5,),
                                      
                                                                                   Padding(
                                              padding: const EdgeInsets.only(bottom: 4.3),
                                              child: Text('${carShop[index]['quantity']}', style: const TextStyle( fontSize: 15 , fontFamily: 'Neuton Regular'),),
                                                                                   ),
                                              const SizedBox(width: 5,),
                                                GestureDetector(
                                                  onTap: () {
                                             
                                                setState(() {
                                                  
                                                  // increaseQuantity(index);
                                
                                                },);
                                             
                                                  },
                                                child: Image.asset('lib/assets/mas@2x.png', width: 15,)),
                                                const SizedBox(width: 13,),
                                
                                                Text('R \$${carShop[index]['precio'].toString()}', style: const TextStyle(fontFamily: 'AlegreyaSans Bold'),),
                                                const SizedBox(width: 13,),
                                
                                                Image.asset('lib/assets/equis@2x.png', width: 15,),
                                                              
                                                ],),
                                  
                                      ],
                                  
                                  ) ,
                                ),
                              );
                          },),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Total: R \$${calculateTotalCars()}', style: const TextStyle(  fontSize: 25,fontFamily: 'AlegreyaSans Bold' ,color: Colors.white, ),),
                        ),

                        Container(
                          width: mediaScreen,
                          child: ElevatedButton(
                            style: const ButtonStyle(
                              foregroundColor: WidgetStatePropertyAll(Colors.black),
                              backgroundColor:  WidgetStatePropertyAll(Color(0xFF9FAADE)) ,
                            ),
                            onPressed: () {
                            
                          }, child: const Text('Para Confirmar o pedido', style: TextStyle( fontSize: 15 ,fontFamily: 'AlegreyaSans Bold'),) ),
                        ),
                      SizedBox(height: heightScreen * 0.03,)
                    ],),
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
                        height: 60,
                        color: Colors.white,
                        child: Center(
                          child: GestureDetector(
                            onTap: (){
                                setState(() {
                                  isSelectedHomeModule = true;
                                  isSelectedCarShopingModule = false;
                                });
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home',
                            (Route<dynamic> route) => false,
                            arguments: 0,
                          );

                          // Navigator.pushNamed(context, '/home');

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
                           
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/car-shop',
                            (Route<dynamic> route) => false,
                            arguments: 0,
                          );

                          // Navigator.pushNamed(context, '/car-shop');

                          },
                          child: Image.asset('lib/assets/carrito@2x.png', width: 50, color: isSelectedCarShopingModule ? const Color(0xFF053452) : Colors.grey,),
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












