import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class RepresentationsAndWarrantiesSupplier extends StatefulWidget {
  const RepresentationsAndWarrantiesSupplier({super.key});

  @override
  State<RepresentationsAndWarrantiesSupplier> createState() =>
      _RepresentationsAndWarrantiesSupplierState();
}

class _RepresentationsAndWarrantiesSupplierState
    extends State<RepresentationsAndWarrantiesSupplier> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '8. REPRESENTATIONS AND WARRANTIES',
          style: getPrimaryRegularStyle(
              color: context.resources.color.secondColorBlue, fontSize: 18),
        ),
        SizedBox(height: context.appValues.appSize.s10),
        Padding(
          padding: EdgeInsets.only(
            left: context.appValues.appPadding.p15,
          ),
          child: Column(
            children: [
              Text(
                'Business represents and warrants to WeDo that: (a) Business has the legal right to provide the Services that are contemplated by this Agreement in Australia; (b) Business is fully-licenced (to the extent required by applicable law) and authorised to provide the Services contemplated by this Agreement within the jurisdiction in which Business intends to offer such Services, and has the required skill, experience, and qualifications to perform the Services; (c) Business shall perform the Services in a professional and diligent manner in accordance with best industry standards for similar services, including the completion of all Bookings referred to Business that it opts to book through the Platform; (d) Business shall perform the Services in accordance with all applicable laws, rules and regulations; and (e) all Personnel utilised in connection with the Services have the legal right to work in Australia. Business acknowledges that its failure to comply with this clause 8 shall constitute a material breach of this Agreement.',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
