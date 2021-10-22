import 'dart:convert';
import 'package:climapp/models/clima.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'clima_bloc/clima_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClimaBloc(),
      child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: HomePage()),
    );
  }
}

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final TextEditingController _controller = TextEditingController();
  late ClimaBloc climaBloc;

  void _searchWeather(String cityName) async {
    climaBloc.add(ClimaLoading());
    final resp = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=2bfeaabdca00f9f2e594409eff15fb98#'));

    final decodeBody = json.decode(resp.body);

    if (resp.statusCode == 200) {
      final clima = Clima.fromJson(decodeBody);
      climaBloc.add(ClimaLoaded(clima));
    } else {
      climaBloc.add(
          ClimaError('Error ${resp.statusCode}: ${decodeBody['message']}'));
    }
  }

  @override
  Widget build(BuildContext context) {
    climaBloc = BlocProvider.of<ClimaBloc>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF001100),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Center(
                  child: SizedBox(
                child: FlareActor(
                  "assets/WorldSpin.flr",
                  fit: BoxFit.contain,
                  animation: "roll",
                ),
                height: 300,
                width: 300,
              )),
              const Text('CLIMAPP',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Colors.white)),
              const SizedBox(height: 12),
              const Text('La aplicación chila que te busca el clima xd',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  )),
              const SizedBox(height: 20),
              BlocBuilder<ClimaBloc, ClimaState>(
                bloc: climaBloc,
                builder: (context, state) {
                  if (state.isLoading) {
                    return const CircularProgressIndicator();
                  }
                  if (state.isError) {
                    return Row(
                      children: [
                        Image.asset(
                          'assets/error.gif',
                          width: 200,
                          height: 200,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                state.errorMessage,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: () {
                                  climaBloc.add(ClimaReset());
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blueGrey,
                                ),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Volver",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  }
                  if (state.clima != null) {
                    final mainDescription = state.clima!.weather[0].main;
                    return Row(
                      children: [
                        Expanded(
                          child: Image.asset('assets/$mainDescription.gif'),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(state.clima!.name,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white)),
                                const SizedBox(height: 12),
                                Text('${state.clima!.main.temp}°C',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white)),
                                const SizedBox(height: 12),
                                Text(state.clima!.weather[0].description,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white)),
                                const SizedBox(height: 20),
                                TextButton(
                                  onPressed: () {
                                    climaBloc.add(ClimaReset());
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blueGrey,
                                  ),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Volver",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2!
                                                  .copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                        ),
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      TextField(
                        controller: _controller,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          label: Text('Ingresa tu ciudad'),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          _searchWeather(_controller.text);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Buscar",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        )),
                              ),
                            ]),
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
