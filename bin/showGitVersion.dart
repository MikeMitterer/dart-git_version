import 'dart:async';
import 'package:git_version/git_version.dart';
import 'package:console_log_handler/print_log_handler.dart';

Future main(List<String> arguments) async {
    final Logger _logger = new Logger('git_version.main');

    configLogging(show: Level.WARNING);

    String patchDelimiter = ".";
    arguments.forEach((final String argument) {
        if(argument == "--patch-dash") {
            patchDelimiter = "-";
        }
    });

    if(arguments.length >= 1 && arguments.first == "--all") {
        final tags = getVersionTags(await getSortedGitTags());

        if(tags.isEmpty) {
            print(ERROR_NO_VERSION_TAG);
        }
        else {
            Future.forEach(tags, (final String tag) async {
                final String extendedFormat = await describeTag(tag);
                print("${extendedFormatToVersion(extendedFormat,patchDelimiter: patchDelimiter)
                    .padRight(8)} (Tag: ${tag} / ${extendedFormat})");
            });
        }
    } else if(arguments.isEmpty || (arguments.length == 1 && arguments[0] == "--patch-dash")) {
        final tags = getVersionTags(await getSortedGitTags());

        if(tags.isEmpty) {
            print(ERROR_NO_VERSION_TAG);
        }
        else {
            final String tag = await describeTag(tags.last);

            _logger.fine("Tag: ${tags.last} with commit: $tag");
            print("${extendedFormatToVersion(tag,patchDelimiter: patchDelimiter)}");
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
            \t--patch-dash     Dash is used as patch (e.g. 0.1-33 instead of 0.1.33)
        """.replaceAll(new RegExp(r'^[ ]*',multiLine: true), ''));
}

