
import 'package:flutter/material.dart';
import 'package:sencare_project/screens/patients/patient_record_screen.dart';

class AnimatedPressableButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final String patientId;

  const AnimatedPressableButton({
    Key? key,
    required this.onPressed,
    required this.text,
     required this.patientId

  }): super(key: key);

  @override
  _AnimatedPressableButtonState createState() => _AnimatedPressableButtonState();
}


class _AnimatedPressableButtonState extends State<AnimatedPressableButton> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
   late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this)..repeat(reverse: true);

      
      // Create scale animation
    _animation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

@override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _animation,
      child: ElevatedButton(
                      onPressed: () =>
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PatientRecordScreen(patientId: '${widget.patientId}')),
                      ),
//                       Navigator.pushNamed(
//   context,
//   AppRoutes.medicalRecordList, 
//   arguments: {
//     'patientId': resident['_id']
//   },
// )
                      child: Text(widget.text),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFB8500),
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
      )              
    );
                    
    
                    }

  }