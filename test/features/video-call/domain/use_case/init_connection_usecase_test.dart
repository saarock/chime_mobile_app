import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chime/features/video-call/domain/repository/video_call_repository.dart';
import 'package:chime/features/video-call/domain/use_case/init_connection_usecase.dart';

// Mock repository
class MockVideoCallRepository extends Mock implements IVideoCallRepository {}

void main() {
  late InitConnectionUseCase useCase;
  late MockVideoCallRepository mockRepository;

  setUp(() {
    mockRepository = MockVideoCallRepository();
    useCase = InitConnectionUseCase(mockRepository);
  });

  test('execute calls repository.initConnection with jwt', () async {
    const testJwt = 'fake_jwt_token';

    // Stub the repository to return a Future<void>
    when(
      () => mockRepository.initConnection(jwt: any(named: 'jwt')),
    ).thenAnswer((_) async {});

    // Call use case
    await useCase.execute(jwt: testJwt);

    // Verify that initConnection was called once with the exact jwt
    verify(() => mockRepository.initConnection(jwt: testJwt)).called(1);
  });

  test('execute calls repository.initConnection with null jwt', () async {
    // Stub the repository to return a Future<void>
    when(
      () => mockRepository.initConnection(jwt: any(named: 'jwt')),
    ).thenAnswer((_) async {});

    // Call use case with no jwt
    await useCase.execute();

    // Verify that initConnection was called once with null jwt
    verify(() => mockRepository.initConnection(jwt: null)).called(1);
  });
}
