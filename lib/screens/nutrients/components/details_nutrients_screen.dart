import 'package:flutter/material.dart';
import 'package:food_nutrition_app/api/services/nature_nutrient_service.dart';
import 'package:food_nutrition_app/contants.dart';
import 'package:food_nutrition_app/models/nutrient.dart';
import 'package:food_nutrition_app/screens/home/components/bottom_navbar.dart';
import 'package:food_nutrition_app/size_config.dart';
import 'package:food_nutrition_app/utils/check_token_expired.dart';
import 'package:intl/intl.dart';

class DetailsNutrientScreen extends StatefulWidget {
  const DetailsNutrientScreen({super.key, required this.nutrient});

  final NutrientModel nutrient;

  @override
  State<DetailsNutrientScreen> createState() => _DetailsNutrientScreenState();
}

class _DetailsNutrientScreenState extends State<DetailsNutrientScreen> {
  late String natureName = "";

  @override
  void initState() {
    super.initState();

    checkCurrentToken(context);

    getNatureNutrientName();
  }

  void getNatureNutrientName() async {
    if (widget.nutrient.natureId != null) {
      String natureNutrientName = await NatureNutrientService()
          .getcategoryNameById(widget.nutrient.natureId!);
      setState(() {
        natureName = natureNutrientName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: Text(natureName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: orientation == Orientation.portrait
                  ? kDefaultPadding
                  : kDefaultPadding * 2,
              vertical: kDefaultPadding * 1.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Spacer(),
                  Text(
                    widget.nutrient.nutrientName,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 15),
              const Text(
                "Mô tả",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.nutrient.description.toString(),
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 15),
              const Text(
                "Chức năng",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.nutrient.function.toString(),
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 15),
              Text(
                "Mức tiêu thụ ${widget.nutrient.nutrientName} cần thiết",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.nutrient.needed,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 15),
              Text(
                "Dấu hiệu dư thừa ${widget.nutrient.nutrientName}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.nutrient.excessSigns.toString(),
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 15),
              Text(
                "Dấu hiệu thiếu hụt ${widget.nutrient.nutrientName}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.nutrient.deficiencySigns.toString(),
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 15),
              Text(
                "Ngăn ngừa thiếu hụt ${widget.nutrient.nutrientName}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.nutrient.shortagePrevention.toString(),
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 15),
              Text(
                "Các đối tượng cần chú tâm đến lượng ${widget.nutrient.nutrientName}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.nutrient.subjectInterest.toString(),
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: SizeConfig.screenWidth * 0.5),
                child: Text(
                  "--- ${widget.nutrient.modifiedDate != null ? DateFormat("dd/MM/yyyy").format(widget.nutrient.modifiedDate!) : DateFormat("dd/MM/yyyy").format(widget.nutrient.createdDate!)} ---",
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
