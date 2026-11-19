import 'package:flutter/material.dart';

/// Syllivo's illustration set for picture exercises: each concept is a
/// glyph on a soft, uniquely tinted blob. Keys are referenced by curriculum
/// JSON (`"images"` on picture questions), so keep them stable.
class IllustrationSpec {
  final IconData icon;
  final Color color;
  const IllustrationSpec(this.icon, this.color);
}

const illustrations = <String, IllustrationSpec>{
  'house': IllustrationSpec(Icons.house_rounded, Color(0xFF4F46E5)),
  'table': IllustrationSpec(Icons.table_restaurant_rounded, Color(0xFFB45309)),
  'chair': IllustrationSpec(Icons.chair_rounded, Color(0xFF0D9488)),
  'bed': IllustrationSpec(Icons.bed_rounded, Color(0xFF7C3AED)),
  'kitchen': IllustrationSpec(Icons.kitchen_rounded, Color(0xFF0891B2)),
  'water': IllustrationSpec(Icons.water_drop_rounded, Color(0xFF0284C7)),
  'coffee': IllustrationSpec(Icons.coffee_rounded, Color(0xFF92400E)),
  'tea': IllustrationSpec(Icons.emoji_food_beverage_rounded, Color(0xFF15803D)),
  'bread': IllustrationSpec(Icons.bakery_dining_rounded, Color(0xFFD97706)),
  'apple': IllustrationSpec(Icons.apple_rounded, Color(0xFFDC2626)),
  'rice': IllustrationSpec(Icons.rice_bowl_rounded, Color(0xFF64748B)),
  'meat': IllustrationSpec(Icons.kebab_dining_rounded, Color(0xFFBE123C)),
  'fruit': IllustrationSpec(Icons.local_florist_rounded, Color(0xFFDB2777)),
  'book': IllustrationSpec(Icons.menu_book_rounded, Color(0xFF4338CA)),
  'school': IllustrationSpec(Icons.school_rounded, Color(0xFF1D4ED8)),
  'person': IllustrationSpec(Icons.person_rounded, Color(0xFF475569)),
  'friends': IllustrationSpec(Icons.people_alt_rounded, Color(0xFFEA580C)),
  'teacher': IllustrationSpec(Icons.co_present_rounded, Color(0xFF9333EA)),
  'family': IllustrationSpec(Icons.family_restroom_rounded, Color(0xFFE11D48)),
  'train': IllustrationSpec(Icons.train_rounded, Color(0xFF0F766E)),
  'bus': IllustrationSpec(Icons.directions_bus_rounded, Color(0xFFCA8A04)),
  'airplane': IllustrationSpec(Icons.flight_rounded, Color(0xFF2563EB)),
  'ticket':
      IllustrationSpec(Icons.confirmation_number_rounded, Color(0xFFC026D3)),
  'hotel': IllustrationSpec(Icons.hotel_rounded, Color(0xFF6D28D9)),
  'sun': IllustrationSpec(Icons.wb_sunny_rounded, Color(0xFFF59E0B)),
  'snow': IllustrationSpec(Icons.ac_unit_rounded, Color(0xFF38BDF8)),
  'doctor': IllustrationSpec(Icons.medical_services_rounded, Color(0xFFDC2626)),
  'medicine': IllustrationSpec(Icons.medication_rounded, Color(0xFF16A34A)),
  'phone': IllustrationSpec(Icons.smartphone_rounded, Color(0xFF334155)),
  'money': IllustrationSpec(Icons.payments_rounded, Color(0xFF15803D)),
  'shop': IllustrationSpec(Icons.storefront_rounded, Color(0xFFEA580C)),
  'clock': IllustrationSpec(Icons.schedule_rounded, Color(0xFF0369A1)),
  'work': IllustrationSpec(Icons.work_rounded, Color(0xFF7C2D12)),
  'computer': IllustrationSpec(Icons.computer_rounded, Color(0xFF1E40AF)),
};

class Illustration extends StatelessWidget {
  final String id;
  final double size;
  const Illustration(this.id, {super.key, this.size = 96});

  @override
  Widget build(BuildContext context) {
    final spec = illustrations[id] ??
        const IllustrationSpec(Icons.image_not_supported_outlined, Colors.grey);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _BlobPainter(spec.color, dark),
        child: Center(
          child: Icon(spec.icon, size: size * 0.5, color: spec.color),
        ),
      ),
    );
  }
}

class _BlobPainter extends CustomPainter {
  final Color color;
  final bool dark;
  _BlobPainter(this.color, this.dark);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final fill = Paint()..color = color.withValues(alpha: dark ? 0.22 : 0.12);
    final blob = Path()
      ..moveTo(s * 0.5, s * 0.06)
      ..cubicTo(s * 0.8, s * 0.04, s * 0.98, s * 0.28, s * 0.94, s * 0.54)
      ..cubicTo(s * 0.9, s * 0.84, s * 0.66, s * 0.98, s * 0.42, s * 0.94)
      ..cubicTo(s * 0.14, s * 0.9, s * 0.02, s * 0.66, s * 0.06, s * 0.42)
      ..cubicTo(s * 0.1, s * 0.18, s * 0.26, s * 0.08, s * 0.5, s * 0.06)
      ..close();
    canvas.drawPath(blob, fill);
    canvas.drawCircle(Offset(s * 0.8, s * 0.2), s * 0.06,
        Paint()..color = color.withValues(alpha: dark ? 0.35 : 0.22));
    canvas.drawCircle(Offset(s * 0.16, s * 0.8), s * 0.035,
        Paint()..color = color.withValues(alpha: dark ? 0.35 : 0.22));
  }

  @override
  bool shouldRepaint(_BlobPainter old) =>
      old.color != color || old.dark != dark;
}
