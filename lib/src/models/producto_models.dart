// To parse this JSON data, do
//
//     final productoModel = productoModelFromJson(jsonString);

import 'dart:convert';

List<ProductoModel> listaP(String str) {
  List<ProductoModel> lista = [];
  lista.add(productoModelFromJson(str));
  return lista;
}

// recibe un json y me lo decodifica en forma de string y nos regresa un intancia de nuestro modelo

ProductoModel productoModelFromJson(str) =>
    ProductoModel.fromJson(json.decode(str));

// toma un  modelos y me lo pasa un json encode
String productoModelToJson(ProductoModel data) => json.encode(data.toJson());

class ProductoModel {
  String? id;
  String? titulo;
  double? valor;
  bool disponible;
  String? fotoUrl;

  ProductoModel({
    this.id,
    this.titulo = '',
    this.valor = 0.0,
    this.disponible = true,
    this.fotoUrl,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
        id: json["id"],
        titulo: json["titulo"],
        valor: json["valor"],
        disponible: json["disponible"],
        fotoUrl: json["fotoUrl"],
      );

  Map<String, dynamic> toJson() => {
        // "id": id,
        "titulo": titulo,
        "valor": valor,
        "disponible": disponible,
        "fotoUrl": fotoUrl,
      };
}
