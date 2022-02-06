import 'package:yaml/yaml.dart';
import '../utils.dart';

class GitHubRepository {
  const GitHubRepository({
    required this.username,
    required this.repo,
    required this.sha,
  });

  factory GitHubRepository.fromJson(final Map<dynamic, dynamic> json) =>
      GitHubRepository(
        username: json['username'] as String,
        repo: json['repo'] as String,
        sha: json['sha'] as String,
      );

  final String username;
  final String repo;
  final String sha;
}

class Config {
  const Config({
    required this.repo,
    required this.paths,
  });

  factory Config.parse(final String content) {
    final Map<dynamic, dynamic> parsed =
        loadYaml(content) as Map<dynamic, dynamic>;

    return Config(
      repo: GitHubRepository.fromJson(parsed['repo'] as Map<dynamic, dynamic>),
      paths: (parsed['paths'] as List<dynamic>).cast<String>(),
    );
  }

  final GitHubRepository repo;
  final List<String> paths;

  List<String> toURLPaths() => paths
      .map(
        (final String x) => Utils.constructGitHubRawURL(
          username: repo.username,
          repo: repo.repo,
          ref: repo.sha,
          path: x,
        ),
      )
      .toList();
}
