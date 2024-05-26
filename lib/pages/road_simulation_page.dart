// lib/pages/road_simulation_page.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../models/road.dart';
import '../utils/congestion_calculator.dart';
import '../widgets/lane_changer.dart';
import '../utils/accident_calculator.dart';
import '../utils/vehicle_manager.dart';
import '../models/accident_type.dart' as accident_model;
import '../models/weather_condition.dart';
import '../utils/accident_handler.dart';
import '../widgets/lane_widgets.dart';

class RoadSimulationPage extends StatefulWidget {
  @override
  _RoadSimulationPageState createState() => _RoadSimulationPageState();
}

class _RoadSimulationPageState extends State<RoadSimulationPage> {
  late Road road;
  int numberOfVehicles1 = 10;
  int numberOfVehicles2 = 10;
  double averageSpeed1 = 0.0;
  double averageSpeed2 = 0.0;
  WeatherCondition weatherCondition = WeatherCondition.Normal;
  final Random random = Random();
  final LaneChanger laneChanger = LaneChanger();
  List<double> originalSpeedsLane1 = [];
  List<double> originalSpeedsLane2 = [];
  bool isLane1Usable = true;
  bool isLane2Usable = true;

  @override
  void initState() {
    super.initState();
    initializeRoad();

    Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        updateSimulation();
        laneChanger.changeLanes(road);
      });
    });

    Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        VehicleManager.updateVehiclePositions(road);
      });
    });
  }

  void initializeRoad() {
    road = Road(
      condition: RoadCondition.Good,
      weather: weatherCondition,
      vehicleCount1: numberOfVehicles1,
      vehicleCount2: numberOfVehicles2,
      vehicles1: generateVehicles(numberOfVehicles1, isLane2: false),
      vehicles2: generateVehicles(numberOfVehicles2, isLane2: true),
      speedLimit: 100,
      accident1: accident_model.AccidentType.None,
      accident2: accident_model.AccidentType.None,
      laneCount: 2,
    );
    updateSimulation();
  }

  List<Vehicle> generateVehicles(int count, {required bool isLane2}) {
    return List.generate(count, (index) {
      var type = isLane2 ? VehicleType.Truck : VehicleType.Car;
      return Vehicle(
        type,
        isLane2 ? 80.0 + (index % 3) * 10.0 : 100.0 + (index % 3) * 10.0,
        random.nextDouble(),
        isLane2 ? 2 : 1,
      );
    });
  }

  void updateVehicles(int count, {required bool isLane2}) {
    setState(() {
      if (isLane2) {
        numberOfVehicles2 = count;
        road.vehicleCount2 = count;
        road.vehicles2 = generateVehicles(numberOfVehicles2, isLane2: true);
      } else {
        numberOfVehicles1 = count;
        road.vehicleCount1 = count;
        road.vehicles1 = generateVehicles(numberOfVehicles1, isLane2: false);
      }
      updateSimulation();
    });
  }

  void updateWeather(WeatherCondition weather) {
    setState(() {
      weatherCondition = weather;
      road.weather = weather;
      updateSimulation();
    });
  }

  void updateSimulation() {
    double congestion1 =
        calculateCongestion(road.vehicleCount1, road.laneCount);
    double congestion2 =
        calculateCongestion(road.vehicleCount2, road.laneCount);

    road.accident1 = calculateAccident(
        congestion1, road.weather, road.condition, road.vehicleCount1);
    road.accident2 = calculateAccident(
        congestion2, road.weather, road.condition, road.vehicleCount2);

    if (road.accident1 != accident_model.AccidentType.None) {
      AccidentHandler.handleAccident(context, 1, road.accident1, road,
          originalSpeedsLane1, originalSpeedsLane2, updateSimulation);
    }
    if (road.accident2 != accident_model.AccidentType.None) {
      AccidentHandler.handleAccident(context, 2, road.accident2, road,
          originalSpeedsLane1, originalSpeedsLane2, updateSimulation);
    }

    VehicleManager.updateVehicleSpeeds(road, isLane1Usable, isLane2Usable);

    averageSpeed1 = VehicleManager.calculateAverageSpeed(road.vehicles1);
    averageSpeed2 = VehicleManager.calculateAverageSpeed(road.vehicles2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yol Simülasyonu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Yol Durumu: ${road.condition.name}'),
            Text('Hava Durumu: ${road.weather.name}'),
            Text('Hız Limiti: ${road.speedLimit} km/h'),
            Text('Şerit Sayısı: ${road.laneCount}'),
            SizedBox(height: 20),
            Text('Şerit 1\'deki Araç Sayısı: ${road.vehicleCount1}'),
            Slider(
              value: numberOfVehicles1.toDouble(), // Convert int to double
              min: 1,
              max: 20,
              divisions: 19,
              label: numberOfVehicles1.toString(),
              onChanged: (value) {
                updateVehicles(value.toInt(), isLane2: false);
              },
            ),
            Text('Şerit 2\'deki Araç Sayısı: ${road.vehicleCount2}'),
            Slider(
              value: numberOfVehicles2.toDouble(), // Convert int to double
              min: 1,
              max: 20,
              divisions: 19,
              label: numberOfVehicles2.toString(),
              onChanged: (value) {
                updateVehicles(value.toInt(), isLane2: true);
              },
            ),
            DropdownButton<WeatherCondition>(
              value: weatherCondition,
              onChanged: (WeatherCondition? newValue) {
                if (newValue != null) {
                  updateWeather(newValue);
                }
              },
              items: WeatherCondition.values.map((WeatherCondition classType) {
                return DropdownMenuItem<WeatherCondition>(
                  value: classType,
                  child: Text(classType.name),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
                'Şerit 1\'deki Ortalama Hız: ${averageSpeed1.toStringAsFixed(2)} km/h'),
            Text(
                'Şerit 2\'deki Ortalama Hız: ${averageSpeed2.toStringAsFixed(2)} km/h'),
            Expanded(
              child: Stack(
                children: [
                  LaneWidget(vehicles: road.vehicles1, laneNumber: 1),
                  LaneWidget(vehicles: road.vehicles2, laneNumber: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
