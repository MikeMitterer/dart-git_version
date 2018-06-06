import 'dart:async';

import 'package:git_version/git_version.dart';

import 'package:build/build.dart';
import 'package:logging/logging.dart';
import "package:console_log_handler/print_log_handler.dart";

Future<String> _readGitVersion() async {
    final tags = getVersionTags(await getSortedGitTags());
    if(tags.isEmpty) {
        throw new ArgumentError(ERROR_NO_VERSION_TAG);
    }

    final String tag = await describeTag(tags.last);
    return extendedFormatToVersion(tag);
}

/// Adds `git.version.dart` to the `web` directory.
class GitVersionBuilder implements Builder {
    static const String _OUTPUT_FILE = "git.version.dart";

    final _logger = new Logger('git_version.builder');

    final Map<String,dynamic> _config;

    GitVersionBuilder(final BuilderOptions options)
        : _config = new Map.from(options.config ?? new Map<String,dynamic>());

    @override
    Future build(final BuildStep buildStep) async {
        _logger.info(_config);

        _config['version'] ??= await _readGitVersion();
        //_config.putIfAbsent("version", () async => await _readGitVersion());

        buildStep.writeAsString(
            new AssetId(buildStep.inputId.package, 'web/$_OUTPUT_FILE'),
                _versionFileContent(buildStep.inputId, _config['version'] ?? '0.1')
        );
    }

    @override
    final buildExtensions = const {
        r'$web$': const [ _OUTPUT_FILE ]
    };

    static String _versionFileContent(final AssetId inputId, final String version)
        => '''
            /// Do not changed this file manually.
            /// Generated at: ${new DateTime.now()}
            ///     AssetId: $inputId
            ///     Version: $version
            
            final String gitVersion = "$version";
            '''.replaceAll(new RegExp(r"^[ \t]+",multiLine: true), "");
}

/// Replaces %version% in xxx.tmpl.json and xxx.tmpl.html files and
/// renames these files to xxx.json and xxx.html
class FromTemplateBuilder implements Builder {
    final _logger = new Logger('git_version.builder');

    final Map<String,dynamic> _config;

    FromTemplateBuilder(final BuilderOptions options)
        : _config = new Map.from(options.config ?? new Map<String,dynamic>());

    /// Similar to `Transformer.apply`. This is where you build and output files.
    @override
    Future build(final BuildStep buildStep) async {
        _logger.info(_config);

        //_config.putIfAbsent("version", () async => await _readGitVersion());
        _config['version'] ??= await _readGitVersion();

        // Each [buildStep] has a single input.
        final inputId = buildStep.inputId;

        // Converts .tmpl.html or .tmpl.json to .html or .json
        final extension = inputId.extension.replaceFirst(".templ", "");

        // Removes the extension and
        // creates a new target [AssetId] based on the old one. (with .html extension)
        var copy = inputId.changeExtension("").changeExtension(extension);
        var contents = await buildStep.readAsString(inputId);

        buildStep.writeAsString(copy,contents.replaceAll("%version%",
            _config['version'] ?? '0.1'));
    }

    @override
    final buildExtensions = const {
        '.tmpl.html': const ['.html'],
        '.tmpl.json': const ['.json']
    };
}

PostProcessBuilder templateSourceCleanup(final BuilderOptions options) =>
    new FileDeletingBuilder(['.tmpl.html', '.tmpl.json' ],
        isEnabled: (options.config['enabled'] as bool) ?? true);

Builder gitVersionBuilder(final BuilderOptions options) => new GitVersionBuilder(options);
Builder fromTemplateBuilder(final BuilderOptions options) => new FromTemplateBuilder(options);
