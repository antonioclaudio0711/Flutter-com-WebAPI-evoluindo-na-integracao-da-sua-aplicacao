// import 'dart:math';

// asyncStudy() {
//   esperandoFuncoesAssincronas();
// }

//void execucaoNormal() {
//  print("\nExecução normal");
//  print("01");
//  print("02");
// print("03");
// print("04");
//}

// void assincronismoBasico() {
//   print("\nAssincronismo básico");
//   print("01");
//   print("02");
//   Future.delayed(const Duration(seconds: 5), () {
//     print("03");
//   });
//   print("04");
// }

// void usandoFuncoesAssincronas() {
//   print("\nUsando funções assíncronas");
//   print("A");
//   print("B");
//   getRandomInt(3).then((value) => {
//         print("O número aleatório é: $value"),
//       });
//   print("C");
//   print("D");
// }

// void esperandoFuncoesAssincronas() async {
//   print("\nEsperando resposta da função assíncrona");
//   print("01");
//   print("02");
//   int sortNumber = await getRandomInt(5);
//   print("O número aleatório sorteado foi: $sortNumber");
//   print("03");
//   print("04");
// }

// Future<int> getRandomInt(int time) async {
//   await Future.delayed(Duration(seconds: time));

//   Random rng = Random();

//   return rng.nextInt(10);
// }
