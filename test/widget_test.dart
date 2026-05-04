// اختبارات smoke سريعة لطبقة Data + منطق التقسيم.
//
// لا نُختبر الـ widget tree الكامل لأن الـ Splash له timer
// و GoogleFonts يحاول تحميل خطوط أونلاين في بيئة الاختبار.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:hsbhali_app/features/bills/data/datasources/bill_local_datasource.dart';
import 'package:hsbhali_app/features/bills/data/models/bill_item_model.dart';
import 'package:hsbhali_app/features/bills/data/models/bill_model.dart';
import 'package:hsbhali_app/features/bills/data/models/person_model.dart';
import 'package:hsbhali_app/features/bills/data/repositories/bill_repository_impl.dart';
import 'package:hsbhali_app/features/bills/domain/entities/bill.dart';
import 'package:hsbhali_app/features/bills/domain/entities/bill_item.dart';
import 'package:hsbhali_app/features/bills/domain/entities/person.dart';
import 'package:hsbhali_app/features/bills/domain/usecases/calculate_split.dart';
import 'package:hsbhali_app/features/people/data/models/shilla_model.dart';

void main() {
  late Directory tempDir;
  late Box<BillModel> box;
  late BillRepositoryImpl repo;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('hsbhali_test_');
    Hive.init(tempDir.path);
    Hive.registerAdapter(BillModelAdapter());
    Hive.registerAdapter(BillItemModelAdapter());
    Hive.registerAdapter(PersonModelAdapter());
    Hive.registerAdapter(ShillaModelAdapter());
  });

  setUp(() async {
    box = await Hive.openBox<BillModel>('bills_test_${DateTime.now().millisecondsSinceEpoch}');
    repo = BillRepositoryImpl(
      localDataSource: BillLocalDataSourceImpl(billsBox: box),
    );
  });

  tearDown(() async {
    await box.clear();
    await box.close();
  });

  tearDownAll(() async {
    await Hive.close();
    if (await tempDir.exists()) await tempDir.delete(recursive: true);
  });

  group('Bills CRUD', () {
    test('إنشاء فاتورة و قراءتها', () async {
      final bill = Bill(
        id: 'bill-1',
        placeName: 'ماك التجمع',
        createdAt: DateTime.now(),
        items: const [
          BillItem(
            id: 'i1',
            name: 'بيج ماك',
            quantity: 2,
            unitPrice: 90,
            totalPrice: 180,
          ),
        ],
        people: const [],
        subtotal: 180,
        total: 180,
      );

      final created = await repo.createBill(bill);
      expect(created.isRight(), true);

      final all = await repo.getAllBills();
      all.fold(
        (f) => fail('failed: ${f.message}'),
        (bills) {
          expect(bills.length, 1);
          expect(bills.first.placeName, 'ماك التجمع');
        },
      );
    });

    test('حساب stats من فواتير متعددة', () async {
      for (var i = 0; i < 3; i++) {
        await repo.createBill(Bill(
          id: 'bill-$i',
          placeName: i == 0 ? 'كنتاكي' : 'ماك',
          createdAt: DateTime.now(),
          items: const [],
          people: const [],
          subtotal: 100,
          total: 100,
        ));
      }

      final stats = await repo.getStats();
      stats.fold(
        (f) => fail('failed: ${f.message}'),
        (s) {
          expect(s.totalBillsCount, 3);
          expect(s.monthTotal, 300);
          expect(s.topPlace, 'ماك');
        },
      );
    });
  });

  group('CalculateSplit', () {
    const usecase = CalculateSplit();

    final ahmed = const Person(id: 'p1', name: 'أحمد', colorIndex: 0);
    final sara = const Person(id: 'p2', name: 'سارة', colorIndex: 1);

    test('قسمة بسيطة: كل صنف لشخص واحد', () async {
      final bill = Bill(
        id: 'b',
        createdAt: DateTime.now(),
        items: [
          BillItem(
            id: 'i1',
            name: 'برجر',
            quantity: 1,
            unitPrice: 100,
            totalPrice: 100,
            assignedPersonIds: [ahmed.id],
          ),
          BillItem(
            id: 'i2',
            name: 'بيتزا',
            quantity: 1,
            unitPrice: 200,
            totalPrice: 200,
            assignedPersonIds: [sara.id],
          ),
        ],
        people: [ahmed, sara],
        subtotal: 300,
        total: 300,
      );

      final result = await usecase(bill);
      result.fold(
        (f) => fail(f.message),
        (split) {
          expect(split.shares.length, 2);
          expect(split.shares[0].subtotal, 100);
          expect(split.shares[0].total, 100);
          expect(split.shares[1].subtotal, 200);
          expect(split.shares[1].total, 200);
        },
      );
    });

    test('صنف مشترك بين شخصين', () async {
      final bill = Bill(
        id: 'b',
        createdAt: DateTime.now(),
        items: [
          BillItem(
            id: 'i1',
            name: 'بيتزا فاميلي',
            quantity: 1,
            unitPrice: 300,
            totalPrice: 300,
            assignedPersonIds: [ahmed.id, sara.id],
          ),
        ],
        people: [ahmed, sara],
        subtotal: 300,
        total: 300,
      );

      final result = await usecase(bill);
      result.fold(
        (f) => fail(f.message),
        (split) {
          expect(split.shares[0].subtotal, 150);
          expect(split.shares[1].subtotal, 150);
        },
      );
    });

    test('توزيع البقشيش و الضريبة نسبيًا', () async {
      // أحمد: 100، سارة: 200 → النسب 1:2
      // البقشيش 30 → أحمد 10، سارة 20
      final bill = Bill(
        id: 'b',
        createdAt: DateTime.now(),
        items: [
          BillItem(
            id: 'i1',
            name: 'برجر',
            quantity: 1,
            unitPrice: 100,
            totalPrice: 100,
            assignedPersonIds: [ahmed.id],
          ),
          BillItem(
            id: 'i2',
            name: 'بيتزا',
            quantity: 1,
            unitPrice: 200,
            totalPrice: 200,
            assignedPersonIds: [sara.id],
          ),
        ],
        people: [ahmed, sara],
        subtotal: 300,
        tipAmount: 30,
        total: 330,
      );

      final result = await usecase(bill);
      result.fold(
        (f) => fail(f.message),
        (split) {
          expect(split.shares[0].subtotal, 100);
          expect(split.shares[0].tipShare, closeTo(10, 0.01));
          expect(split.shares[0].total, closeTo(110, 0.01));
          expect(split.shares[1].subtotal, 200);
          expect(split.shares[1].tipShare, closeTo(20, 0.01));
          expect(split.shares[1].total, closeTo(220, 0.01));
        },
      );
    });

    test('فشل لو ما فيش أشخاص', () async {
      final bill = Bill(
        id: 'b',
        createdAt: DateTime.now(),
        items: const [],
        people: const [],
        subtotal: 0,
        total: 0,
      );

      final result = await usecase(bill);
      expect(result.isLeft(), true);
    });

    test('subset equal: 2 من 3 أشخاص يدفعوا نص و نص و التالت بصفر', () async {
      final mona = const Person(id: 'p3', name: 'منى', colorIndex: 2);
      final bill = Bill(
        id: 'b',
        createdAt: DateTime.now(),
        items: [
          BillItem(
            id: 'i1',
            name: 'بيتزا',
            quantity: 1,
            unitPrice: 6000,
            totalPrice: 6000,
            assignedPersonIds: [ahmed.id, sara.id],
          ),
        ],
        people: [ahmed, sara, mona],
        subtotal: 6000,
        total: 6000,
      );

      final result = await usecase(bill);
      result.fold(
        (f) => fail(f.message),
        (split) {
          final ahmedShare =
              split.shares.firstWhere((s) => s.person.id == ahmed.id);
          final saraShare =
              split.shares.firstWhere((s) => s.person.id == sara.id);
          final monaShare =
              split.shares.firstWhere((s) => s.person.id == mona.id);
          expect(ahmedShare.subtotal, 3000);
          expect(saraShare.subtotal, 3000);
          expect(monaShare.subtotal, 0);
          expect(monaShare.total, 0);
        },
      );
    });

    test('quantity mode: ٤ برجر بـ ١٦٠٠٠، توزيع ٢/١/١', () async {
      final mona = const Person(id: 'p3', name: 'منى', colorIndex: 2);
      final bill = Bill(
        id: 'b',
        createdAt: DateTime.now(),
        items: [
          BillItem(
            id: 'i1',
            name: 'برجر',
            quantity: 4,
            unitPrice: 4000,
            totalPrice: 16000,
            splitMode: SplitMode.quantity,
            portionsPerPerson: {
              ahmed.id: 2,
              sara.id: 1,
              mona.id: 1,
            },
          ),
        ],
        people: [ahmed, sara, mona],
        subtotal: 16000,
        total: 16000,
      );

      final result = await usecase(bill);
      result.fold(
        (f) => fail(f.message),
        (split) {
          final ahmedShare =
              split.shares.firstWhere((s) => s.person.id == ahmed.id);
          final saraShare =
              split.shares.firstWhere((s) => s.person.id == sara.id);
          final monaShare =
              split.shares.firstWhere((s) => s.person.id == mona.id);
          expect(ahmedShare.subtotal, 8000);
          expect(saraShare.subtotal, 4000);
          expect(monaShare.subtotal, 4000);
        },
      );
    });
  });
}
