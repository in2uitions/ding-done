import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';

class DefinitionAndInterpretation extends StatefulWidget {
  const DefinitionAndInterpretation({super.key});

  @override
  State<DefinitionAndInterpretation> createState() =>
      _DefinitionAndInterpretationState();
}

class _DefinitionAndInterpretationState
    extends State<DefinitionAndInterpretation> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '1.	DEFINITIONS AND INTERPRETATION',
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
                '1.	In these Terms (including the recitals), unless the context otherwise requires:',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 17),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Padding(
                padding: EdgeInsets.only(
                  left: context.appValues.appPadding.p15,
                ),
                child: Column(
                  children: [
                    Text(
                      '1.	“Booking” means the booking made by you for the provision of Services;',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      '2.	“Booking System” means WeDo’s systems which enable you to make a Booking;',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      '3.	“Service Fee” means the fee, as advised by WeDo from time to time, (inclusive of goods and service tax, if applicable) for the Services;',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      '4.	“Intellectual Property Rights” means all present and future rights anywhere in the world in relation to copyright, trademarks, designs, patents or other proprietary rights, or any rights to registration of such rights whether existing before or after your access to the Platform;',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      '5.	“Platform Content” means all material, content and information made available on the Platform including but not limited to written text, graphics, images, photographs, logos, trademarks, audio material, video material and any other forms of expression;',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      '6.	“you”, “your”< means you as the user of the Platform.',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                  ],
                ),
              ),
              Text(
                '2.	In these Terms, unless the context otherwise requires:',
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 17),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Padding(
                padding: EdgeInsets.only(
                  left: context.appValues.appPadding.p15,
                ),
                child: Column(
                  children: [
                    Text(
                      '1.	headings are for convenience only and do not affect its interpretation or construction;',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      '2.	the singular includes the plural and vice versa;',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      '3.	references to recitals, clauses, subclauses, paragraphs, annexures or schedules are references to recitals, clauses, subclauses, paragraphs, annexures and schedules of or to these Terms;',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      '4.	words importing a gender include other genders; the word “person” means a natural person and any association, body or entity whether incorporated or not;',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      '5.	where any word or phrase is defined, any other part of speech or other grammatical forms of that word or phrase has a cognate meaning;',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      '6.	a reference to any statute, proclamation, rule, code, regulation or ordinance includes any amendment, consolidation, modification, re-enactment or reprint of it or any statute, proclamation, rule, code, regulation or ordinance replacing it;',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      '7.	all monetary amounts are in Australian currency;',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      '8.	a reference to time refers to Eastern Standard Time;',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      '9.	“includes” is not a word of limitation; no rule of construction applies to the disadvantage of a party because these Terms are prepared by (or on behalf of) that party',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      '10.	a reference to any thing is a reference to the whole and each part of it;',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      '11.	a reference to a group of persons is a reference to all of them collectively and to each of them individually; and',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      '12.	a reference to a document includes all amendments or supplements to, or replacements or novations of, that document.',
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
