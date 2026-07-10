import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:app_proje_a/main.dart';

void main() {
  testWidgets('App builds successfully', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService();
    await storage.init();
    await tester.pumpWidget(MyApp(storage: storage));
    // Uygulama başarıyla oluşturuldu mu kontrol et
    expect(find.byType(MyApp), findsOneWidget);
  });
}
