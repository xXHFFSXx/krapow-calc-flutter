import 'package:flutter/material.dart';

import '../ux/ux_helpers.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({
    super.key,
    required this.onFinish,
    required this.onUseSampleData,
  });

  final VoidCallback onFinish;
  final VoidCallback onUseSampleData;

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final _pageController = PageController();
  int _pageIndex = 0;

  final List<_OnboardingStep> _steps = const [
    _OnboardingStep(
      title: 'รู้กำไรของแต่ละเมนูในไม่กี่นาที',
      description: 'แอปช่วยสรุปต้นทุนและกำไรแบบง่าย ๆ ไม่ต้องเป็นนักบัญชี',
      bullets: [
        'รู้ว่าราคาที่ขายคุ้มไหม',
        'เห็นเมนูทำกำไรดี',
        'คำนวณราคาเดลิเวอรี่อัตโนมัติ',
      ],
    ),
    _OnboardingStep(
      title: 'ตั้งค่าวัตถุดิบแบบเร็ว',
      description: 'เริ่มจากวัตถุดิบหลักก่อน แล้วค่อยเพิ่มทีหลังได้',
      bullets: [
        'ใส่ราคาวัตถุดิบหลัก 5-10 รายการ',
        'ใช้ตัวอย่างเพื่อดูผลลัพธ์ทันที',
        'ปรับราคาภายหลังได้เสมอ',
      ],
    ),
    _OnboardingStep(
      title: 'เริ่มใช้งานทันที',
      description: 'เลือกเริ่มจากตัวอย่างหรือใส่ข้อมูลของร้านคุณเลย',
      bullets: [
        'ลองดูผลลัพธ์ก่อนตัดสินใจ',
        'แก้ไขเมนูและต้นทุนได้ง่าย',
      ],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _steps.length,
                onPageChanged: (index) => setState(() => _pageIndex = index),
                itemBuilder: (context, index) {
                  final step = _steps[index];
                  return _buildStep(context, step);
                },
              ),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, _OnboardingStep step) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            step.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            step.description,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ...step.bullets.map(
            (text) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, color: Colors.deepOrange, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(text)),
                ],
              ),
            ),
          ),
          const Spacer(),
          const SimpleHint(
            text: 'ไม่ต้องรู้บัญชี แค่ใส่ต้นทุนที่รู้ก็เห็นกำไรทันที',
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _steps.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _pageIndex == index ? 16 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _pageIndex == index ? Colors.deepOrange : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_pageIndex == _steps.length - 1) ...[
            ElevatedButton(
              onPressed: widget.onFinish,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('เริ่มใช้งาน'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: widget.onUseSampleData,
              child: const Text('ลองใช้ข้อมูลตัวอย่างก่อน'),
            ),
          ] else ...[
            ElevatedButton(
              onPressed: () => _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('ถัดไป'),
            ),
          ],
        ],
      ),
    );
  }
}

class _OnboardingStep {
  const _OnboardingStep({
    required this.title,
    required this.description,
    required this.bullets,
  });

  final String title;
  final String description;
  final List<String> bullets;
}
