// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commit_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$commitProviderHash() => r'c3bd064177e65302c60c2ff6f73bf7582ccab1da';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [commitProvider].
@ProviderFor(commitProvider)
const commitProviderProvider = CommitProviderFamily();

/// See also [commitProvider].
class CommitProviderFamily
    extends Family<AsyncValue<Map<String, List<Map<String, dynamic>>>>> {
  /// See also [commitProvider].
  const CommitProviderFamily();

  /// See also [commitProvider].
  CommitProviderProvider call({
    required List<Map<String, String>> selectedRepos,
    required List<String> selectedCollaborators,
    required DateTime since,
    required DateTime until,
  }) {
    return CommitProviderProvider(
      selectedRepos: selectedRepos,
      selectedCollaborators: selectedCollaborators,
      since: since,
      until: until,
    );
  }

  @override
  CommitProviderProvider getProviderOverride(
    covariant CommitProviderProvider provider,
  ) {
    return call(
      selectedRepos: provider.selectedRepos,
      selectedCollaborators: provider.selectedCollaborators,
      since: provider.since,
      until: provider.until,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'commitProviderProvider';
}

/// See also [commitProvider].
class CommitProviderProvider
    extends AutoDisposeFutureProvider<Map<String, List<Map<String, dynamic>>>> {
  /// See also [commitProvider].
  CommitProviderProvider({
    required List<Map<String, String>> selectedRepos,
    required List<String> selectedCollaborators,
    required DateTime since,
    required DateTime until,
  }) : this._internal(
          (ref) => commitProvider(
            ref as CommitProviderRef,
            selectedRepos: selectedRepos,
            selectedCollaborators: selectedCollaborators,
            since: since,
            until: until,
          ),
          from: commitProviderProvider,
          name: r'commitProviderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$commitProviderHash,
          dependencies: CommitProviderFamily._dependencies,
          allTransitiveDependencies:
              CommitProviderFamily._allTransitiveDependencies,
          selectedRepos: selectedRepos,
          selectedCollaborators: selectedCollaborators,
          since: since,
          until: until,
        );

  CommitProviderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.selectedRepos,
    required this.selectedCollaborators,
    required this.since,
    required this.until,
  }) : super.internal();

  final List<Map<String, String>> selectedRepos;
  final List<String> selectedCollaborators;
  final DateTime since;
  final DateTime until;

  @override
  Override overrideWith(
    FutureOr<Map<String, List<Map<String, dynamic>>>> Function(
            CommitProviderRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CommitProviderProvider._internal(
        (ref) => create(ref as CommitProviderRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        selectedRepos: selectedRepos,
        selectedCollaborators: selectedCollaborators,
        since: since,
        until: until,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, List<Map<String, dynamic>>>>
      createElement() {
    return _CommitProviderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CommitProviderProvider &&
        other.selectedRepos == selectedRepos &&
        other.selectedCollaborators == selectedCollaborators &&
        other.since == since &&
        other.until == until;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, selectedRepos.hashCode);
    hash = _SystemHash.combine(hash, selectedCollaborators.hashCode);
    hash = _SystemHash.combine(hash, since.hashCode);
    hash = _SystemHash.combine(hash, until.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CommitProviderRef
    on AutoDisposeFutureProviderRef<Map<String, List<Map<String, dynamic>>>> {
  /// The parameter `selectedRepos` of this provider.
  List<Map<String, String>> get selectedRepos;

  /// The parameter `selectedCollaborators` of this provider.
  List<String> get selectedCollaborators;

  /// The parameter `since` of this provider.
  DateTime get since;

  /// The parameter `until` of this provider.
  DateTime get until;
}

class _CommitProviderProviderElement extends AutoDisposeFutureProviderElement<
    Map<String, List<Map<String, dynamic>>>> with CommitProviderRef {
  _CommitProviderProviderElement(super.provider);

  @override
  List<Map<String, String>> get selectedRepos =>
      (origin as CommitProviderProvider).selectedRepos;
  @override
  List<String> get selectedCollaborators =>
      (origin as CommitProviderProvider).selectedCollaborators;
  @override
  DateTime get since => (origin as CommitProviderProvider).since;
  @override
  DateTime get until => (origin as CommitProviderProvider).until;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
