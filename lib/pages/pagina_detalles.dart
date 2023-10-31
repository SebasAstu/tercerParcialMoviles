import 'package:flutter/material.dart';

import '../main.dart';

class paginaDetalles extends StatelessWidget {
  final Movie movie;
  final double totalAmount;

  paginaDetalles({required this.movie, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Película'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Película: ${movie.title}'),
            Text('Precio de entrada:'+ movie.precio.toStringAsFixed(2)+'Bs'),
            Text('Cantidad de entradas: ${movie.cantidadEntradas}'),
            Text('Total a pagar:'+ totalAmount.toStringAsFixed(2)+'Bs'),
          ],
        ),
      ),
    );
  }
}


