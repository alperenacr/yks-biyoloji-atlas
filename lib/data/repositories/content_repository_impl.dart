import '../../domain/entities/topic.dart';
import '../../domain/entities/region.dart';
import '../../domain/repositories/content_repository.dart';
import '../datasources/remote/supabase_datasource.dart';
import '../../core/errors/exceptions.dart';

class ContentRepositoryImpl implements ContentRepository {
  final SupabaseDataSource? _remote;

  ContentRepositoryImpl(this._remote);

  List<Topic> _getMockTopics() {
    return [
      const Topic(
        id: '1',
        title: 'Hücre Yapısı',
        description: 'Hücrenin temel yapı taşları',
        grade: '10',
        svgPath: 'assets/diagrams/cell.svg',
        regions: [
          Region(
              id: '1',
              label: 'Çekirdek',
              description: 'Kalıtım materyali',
              svgElementId: 'nucleus',
              x: 50,
              y: 50)
        ],
        totalQuestions: 15,
      ),
      const Topic(
        id: '2',
        title: 'Mitosis',
        description: 'Hücre bölünme süreci',
        grade: '11',
        svgPath: 'assets/diagrams/mitosis.svg',
        regions: [
          Region(
              id: '2',
              label: 'Metafaz',
              description: 'Kromozom hizalaması',
              svgElementId: 'metaphase',
              x: 60,
              y: 40)
        ],
        totalQuestions: 20,
      ),
    ];
  }

  @override
  Future<List<Topic>> getTopics({String? grade}) async {
    if (_remote == null) {
      var topics = _getMockTopics();
      if (grade != null) {
        topics = topics.where((t) => t.grade == grade).toList();
      }
      return topics;
    }
    return _remote.getTopics(grade: grade);
  }

  @override
  Future<Topic> getTopicById(String id) async {
    if (_remote == null) {
      final topics = _getMockTopics();
      final topic = topics.where((t) => t.id == id).firstOrNull;
      if (topic == null) throw const ServerException('Konu bulunamadı');
      return topic;
    }
    final topics = await _remote.getTopics();
    final topic = topics.where((t) => t.id == id).firstOrNull;
    if (topic == null) throw const ServerException('Konu bulunamadı');
    return topic;
  }
}
