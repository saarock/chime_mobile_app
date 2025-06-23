// Use case to connect to socket
import 'package:chime/features/video-call/data/data_source/video_call_datasource.dart';

class ConnectSocketUseCase {
  final IVideoCallDataSource dataSource;

  ConnectSocketUseCase(this.dataSource);

  Future<void> execute({String? jwt}) {
    return dataSource.initialize(jwt: jwt);
  }
}
