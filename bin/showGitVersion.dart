import 'dart:async';
import 'package:git_version/git_version.dart';
import 'package:console_log_handler/print_log_handler.dart';

Future main(List<String> arguments) async {
    final Logger _logger = new Logger('git_version.main');

    configLogging(show: Level.WARNING);

    final removeDash = arguments.isNotEmpty && (arguments[0] == "--no-dash" ||
        (arguments.length > 1 && arguments[1] == "--no-dash"));

    if(arguments.isEmpty || (arguments.length == 1 && arguments[0] == "--no-dash")) {
        final tags = getVersionTags(await getSortedGitTags());

        if(tags.isEmpty) {
            print(ERROR_NO_VERSION_TAG);
        }
        else {
            final String tag = await describeTag(tags.last);

            _logger.fine("Tag: ${tags.last} with commit: $tag");
            print("${extendedFormatToVersion(tag,removeDash: removeDash)}");
        }
    }
    else if(arguments.first == "--all") {
        final tags = getVersionTags(await getSortedGitTags());

        if(tags.isEmpty) {
            print(ERROR_NO_VERSION_TAG);
        }
        else {
            Future.forEach(tags, (final String tag) async {
                final String extendedFormat = await describeTag(tag);
                print("${extendedFormatToVersion(extendedFormat,removeDash: removeDash)
                    .padRight(8)} (Tag: ${tag} / ${extendedFormat})");
            });
        }
    }
    else {
        _usage();
    }

}

void _usage() {
    print("""
        showGitVersion [--all] [--no-dash] - prints the current Git-Version
        
            \t--help           This help message
            \t--all            Prints all version tags
            \t--no-dash        Replace dash with . (e.g. 0.1-33 -> 0.1.33)
        """.replaceAll(new RegExp(r'^[ ]*',multiLine: true), ''));
}

