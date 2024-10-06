import 'package:agro_buddy/components/my_button.dart';
import "package:flutter/material.dart";
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HarvestForecast extends StatefulWidget {
  const HarvestForecast({super.key});

  @override
  State<HarvestForecast> createState() => _HarvestForecastState();
}

class _HarvestForecastState extends State<HarvestForecast> {
  final TextEditingController standardYieldController = TextEditingController();
  final TextEditingController cultivatedAreaController = TextEditingController();
  final TextEditingController lastYieldController = TextEditingController();

  String calculatedHarvest = '';

  void calculateHarvest() {
    double standardYield = double.tryParse(standardYieldController.text) ?? 0;
    double cultivatedArea = double.tryParse(cultivatedAreaController.text) ?? 0;
    double lastYield = double.tryParse(lastYieldController.text) ?? 0;

    double result = standardYield * cultivatedArea * (lastYield/standardYield);

    setState(() {
      calculatedHarvest = result.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const  Color.fromARGB(255, 40, 99, 31),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //important text
                Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.harvest_imp,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 196, 32, 42),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.harvest_imp_text,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                //standard yield input
                SizedBox(
                  child: TextField(
                    controller: standardYieldController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.st_yield,
                      labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      border: const UnderlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                //cultivated land extent input
                SizedBox(
                  child: TextField(
                    controller: cultivatedAreaController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.cult_area,
                      labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      border: const UnderlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                //last time yield input
                SizedBox(
                  child: TextField(
                    controller: lastYieldController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.last_yield,
                      labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      border: const UnderlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      //calculate harvest text
                      Text(
                        AppLocalizations.of(context)!.cast_harv,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),

                      Text(
                        calculatedHarvest.isNotEmpty ? calculatedHarvest : '0', 
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.amount_kg,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                //Calculate Harvest button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyButton(
                        text: AppLocalizations.of(context)!.calc_btn,
                        onTap: calculateHarvest
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
