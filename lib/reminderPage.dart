// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:url_launcher/url_launcher.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({Key? key}) : super(key: key);

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  // late TextEditingController _dateC;
  // late TextEditingController _timeC;
  final TextEditingController _dateC = TextEditingController();
  final TextEditingController _timeC = TextEditingController();
  final TextEditingController _message = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  ///Date
  DateTime selected = DateTime.now();
  DateTime initial = DateTime(2000);
  DateTime last = DateTime(2025);

  ///Time
  TimeOfDay timeOfDay = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _dateC.addListener(updateData);
    _timeC.addListener(updateData);
    _message.addListener(updateData);
    _phone.addListener(updateData);
  }

  void updateData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Pickers"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              buildUI(context),
              Column(
                children: [
                  Text(_dateC.text.isNotEmpty ? _dateC.text : ""),
                  Text(_timeC.text.isNotEmpty ? _timeC.text : ""),
                  Text(_message.text.isNotEmpty ? _message.text : "")
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUI(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        TextFormField(
          textInputAction: TextInputAction.next,
          controller: _message,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
              labelText: 'Enter Reminder', border: OutlineInputBorder()),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          textInputAction: TextInputAction.done,
          controller: _phone,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              labelText: 'Enter WhatsApp number', border: OutlineInputBorder()),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _dateC.text.isNotEmpty ? _dateC.text : "Pick A Date",
                style: const TextStyle(
                    color: Color.fromARGB(255, 12, 127, 221), fontSize: 24),
              ),
              IconButton(
                  onPressed: () async {
                    await displayDatePicker(context);
                  },
                  icon: const Icon(Icons.calendar_month))
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _timeC.text.isNotEmpty ? _timeC.text : "Choose your time",
                style: const TextStyle(
                    color: Color.fromARGB(255, 12, 127, 221), fontSize: 24),
              ),
              IconButton(
                  onPressed: () async {
                    await displayTimePicker(context);
                  },
                  icon: const Icon(Icons.watch_rounded))
            ],
          ),
        ),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
                onPressed: () async {
                  await launchWhatsApp();
                },
                style: ElevatedButton.styleFrom(elevation: 7),
                child: const Text("Send Message")))
      ],
    );
  }

  launchWhatsApp() async {
    // final link = WhatsAppUnilink(
    //   phoneNumber: "+91${_phone.text}",
    //   text: _message.text,
    // );
    String encodedMessage = Uri.encodeComponent(_message.text);
    String whatsappUrl = 'https://wa.me/${_phone.text}?text=$encodedMessage';

    await launchUrl(Uri.parse(whatsappUrl));
  }

  Future<void> displayDatePicker(BuildContext context) async {
    final date = await showDatePicker(
        context: context,
        initialDate: selected,
        firstDate: initial,
        lastDate: last,
        initialDatePickerMode: DatePickerMode.day,
        keyboardType: TextInputType.datetime,
        helpText: "Pick a Date",
        cancelText: "Close",
        confirmText: "Pick",
        barrierDismissible: false);

    if (date != null) {
      setState(() {
        _dateC.text = date.toLocal().toString().split(" ")[0];
      });
    }
  }

  Future<void> displayTimePicker(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: timeOfDay,
    );

    if (time != null) {
      String period = 'AM'; // Default to AM

      // Determine the period (AM/PM)
      if (time.hour >= 12) {
        period = 'PM';
      }

      // Convert hour to 12-hour format
      int hourIn12HourFormat = time.hourOfPeriod;
      if (hourIn12HourFormat == 0) {
        hourIn12HourFormat = 12; // 12 AM
      }

      setState(() {
        _timeC.text = "$hourIn12HourFormat:${time.minute} $period";
      });
    }
  }
}
