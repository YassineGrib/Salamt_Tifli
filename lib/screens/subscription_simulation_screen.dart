import 'package:flutter/material.dart';

class SubscriptionSimulationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('محاكاة الدفع'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الدفع بالبطاقة الذهبية',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'رقم البطاقة',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'تاريخ انتهاء الصلاحية',
              ),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'رمز CVV',
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Simulate payment process
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('نجاح العملية'),
                      content: Text('تمت عملية الدفع بنجاح!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('حسناً'),
                        ),
                      ],
                    ),
                  );
                },
                child: Text('محاكاة الدفع'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}