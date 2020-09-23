import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_finder/bloc/weatherbloc.dart';
import 'package:weather_finder/model/weathermodel.dart';
import 'package:weather_finder/reporcities/weatherrepo.dart';

bool light = false;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: light ? Colors.black : Colors.white,
      body: BlocProvider(
        create: (context) => WeatherBloc(WeatherRepo()),
        child: Column(
          children: [
            Searchpage(),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      light = true;
                    });
                  },
                  color: Colors.black,
                  child: Text(
                    'Dark',
                    style: TextStyle(color: Colors.white),
                  ),
                 
                ),
                SizedBox(
                  width: 10,
                ),
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      light = false;
                    });
                  },
                   color: Colors.white,
                  
                  child: Text('light'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Searchpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weatherbloc = BlocProvider.of<WeatherBloc>(context);
    var cityController = TextEditingController();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Container(
              // child: FlareActor("assets/WorldSpin.flr", fit: BoxFit.contain, animation: "roll",),
              child: Lottie.asset('assets/wind-gust.json', fit: BoxFit.contain),
              height: 300,
              width: 300,
            )),
            BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                if (state is WeatherIsNotSearched)
                  return Container(
                    padding: EdgeInsets.only(
                      left: 32,
                      right: 32,
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Search Weather",
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w500,
                              color: light ? Colors.white70 : Colors.black87),
                        ),
                        Text(
                          "Instanly",
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w200,
                              color: light ? Colors.white70 : Colors.grey),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        TextFormField(
                          controller: cityController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: light ? Colors.white70 : Colors.black54,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color:
                                        light ? Colors.white70 : Colors.black54,
                                    style: BorderStyle.solid)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: Colors.blue,
                                    style: BorderStyle.solid)),
                            hintText: "City Name",
                            hintStyle: TextStyle(
                                color: light ? Colors.white70 : Colors.black54),
                          ),
                          style: TextStyle(
                              color: light ? Colors.white70 : Colors.black54),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: FlatButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            onPressed: () {
                              weatherbloc
                                  .add(FetchWeather(cityController.text));
                            },
                            color: Colors.lightBlue,
                            child: Text(
                              "Search",
                              style: TextStyle(
                                  color:
                                      light ? Colors.white70 : Colors.black54,
                                  fontSize: 16),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                else if (state is WeatherIsLoading)
                  return Center(child: CircularProgressIndicator());
                else if (state is WeatherIsLoaded)
                  return ShowWeather(state.getWeather, cityController.text);
                else
                  return Text(
                    "Error",
                    style: TextStyle(
                        color: light ? Colors.white70 : Colors.black54),
                  );
              },
            ),
           
          ],
        ),
      ),
    );
  }
}

class ShowWeather extends StatelessWidget {
  WeatherModel weather;
  final city;

  ShowWeather(this.weather, this.city);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Container(
          padding: EdgeInsets.only(right: 32, left: 32, top: 10),
          child: Column(
            children: <Widget>[
              Text(
                city,
                style: TextStyle(
                    color: light ? Colors.white70 : Colors.black54,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                weather.getTemp.round().toString() + "C",
                style: TextStyle(
                    color: light ? Colors.white70 : Colors.black54, fontSize: 50),
              ),
              Text(
                "Temprature",
                style: TextStyle(
                    color: light ? Colors.white70 : Colors.black54, fontSize: 14),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        weather.getMinTemp.round().toString() + "C",
                        style: TextStyle(
                            color: light ? Colors.white70 : Colors.black54,
                            fontSize: 30),
                      ),
                      Text(
                        "Min Temprature",
                        style: TextStyle(
                            color: light ? Colors.white70 : Colors.black54,
                            fontSize: 14),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        weather.getMaxTemp.round().toString() + "C",
                        style: TextStyle(
                            color: light ? Colors.white70 : Colors.black54,
                            fontSize: 30),
                      ),
                      Text(
                        "Max Temprature",
                        style: TextStyle(
                            color: light ? Colors.white70 : Colors.black54,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: 50,
                child: FlatButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  onPressed: () {
                    BlocProvider.of<WeatherBloc>(context).add(ResetWeather());
                  },
                  color: Colors.lightBlue,
                  child: Text(
                    "Search",
                    style: TextStyle(
                        color: light ? Colors.white70 : Colors.black54,
                        fontSize: 16),
                  ),
                ),
              ),
              
            ],
          )),
    );
  }
}
