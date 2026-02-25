import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../core/theme.dart';
import '../services/bet_service.dart';

class CreateBetPage extends StatefulWidget {
  const CreateBetPage({super.key});

  @override
  State<CreateBetPage> createState() => _CreateBetPageState();
}

class _CreateBetPageState extends State<CreateBetPage> {
  final TextEditingController _titleController = TextEditingController();
  final BetService _betService = BetService();
  int _selectedType = 0;
  double _timeWindow = 15;
  double _entryFee = 10;
  bool _isCreating = false;

  final List<Map<String, dynamic>> _betTypes = [
    {'icon': Icons.swap_horiz_rounded, 'label': 'Binary'},
    {'icon': Icons.list_rounded, 'label': 'Multiple'},
    {'icon': Icons.numbers_rounded, 'label': 'Numeric'},
    {'icon': Icons.linear_scale_rounded, 'label': 'Slider'},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('New Bet Challenge'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('CHALLENGE TITLE', style: Theme.of(context).textTheme.bodySmall?.copyWith(letterSpacing: 2)),
            const SizedBox(height: 12),
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: 'e.g., Champions League Predictor',
                fillColor: AppColors.surface,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              ),
            ),
            const SizedBox(height: 32),
            Text('CHOOSE TYPE', style: Theme.of(context).textTheme.bodySmall?.copyWith(letterSpacing: 2)),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                bool isSelected = _selectedType == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedType = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.neonGreen.withOpacity(0.1) : AppColors.surface,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected ? AppColors.neonGreen : Colors.white10,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _betTypes[index]['icon'],
                          color: isSelected ? AppColors.neonGreen : Colors.white38,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _betTypes[index]['label'],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            Text('ENTRY WINDOW (MINUTES)', style: Theme.of(context).textTheme.bodySmall?.copyWith(letterSpacing: 2)),
            const SizedBox(height: 16),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppColors.electricCyan,
                thumbColor: AppColors.electricCyan,
                overlayColor: AppColors.electricCyan.withOpacity(0.2),
              ),
              child: Slider(
                value: _timeWindow,
                min: 5,
                max: 120,
                divisions: 23,
                label: '${_timeWindow.round()}m',
                onChanged: (val) => setState(() => _timeWindow = val),
              ),
            ),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text('5m', style: Theme.of(context).textTheme.bodySmall),
                 Text('${_timeWindow.round()} minutes', style: const TextStyle(color: AppColors.electricCyan, fontWeight: FontWeight.bold)),
                 Text('120m', style: Theme.of(context).textTheme.bodySmall),
               ],
             ),
            const SizedBox(height: 40),
            Text('ENTRY FEE', style: Theme.of(context).textTheme.bodySmall?.copyWith(letterSpacing: 2)),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: CupertinoPicker(
                itemExtent: 50,
                onSelectedItemChanged: (index) => setState(() => _entryFee = (index + 1) * 5.0),
                children: List.generate(20, (index) => Center(
                  child: Text(
                    '\$${(index + 1) * 5}',
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                )),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
               onPressed: _isCreating ? null : () async {
                 if (_titleController.text.isEmpty) {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a title')));
                   return;
                 }

                 setState(() => _isCreating = true);
                 try {
                   await _betService.createChallenge(
                     title: _titleController.text,
                     entryFee: _entryFee,
                     endsAt: DateTime.now().add(Duration(minutes: _timeWindow.round())),
                   );
                   Navigator.pop(context);
                 } catch (e) {
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                 } finally {
                   setState(() => _isCreating = false);
                 }
               },
               style: ElevatedButton.styleFrom(
                 backgroundColor: AppColors.neonGreen,
                 foregroundColor: Colors.black,
                 minimumSize: const Size(double.infinity, 60),
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
               ),
               child: _isCreating 
                 ? const CircularProgressIndicator(color: Colors.black)
                 : const Text('CREATE CHALLENGE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
