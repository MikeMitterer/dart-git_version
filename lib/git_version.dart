/*
 * Copyright (c) 2017, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 *
 * All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/// Reads GIT version information
library git_version;

import 'dart:async';
import 'dart:io';
import 'package:where/where.dart';
import 'package:logging/logging.dart';

final Logger _logger = new Logger('git_version');

const String ERROR_NO_VERSION_TAG = "No version-Tag found! (Tagname must start with 'v|V[0-9]')";

// GIT Parts wurden von
//      https://github.com/kevmoo/git.dart/blob/master/lib/src/top_level.dart
// übernommen
final _gitBinName = "git";

/// Caches GIT application path
String _gitCache;

/// Runs the 'git' command
Future<ProcessResult> runGit(final List<String> args,
    { bool throwOnError: true, String processWorkingDir }) async {
    final git = await _getGit();

    final result = await Process.run(git, args,
        workingDirectory: processWorkingDir, runInShell: true);

    if (throwOnError) {
        _throwIfProcessFailed(result, git, args);
    }
    return result;
}

/// Returns a list of all the available git tags
///
/// The tags are sorted by 'version:refname'
/// More: https://git-scm.com/docs/git-tag
Future<List<String>> getSortedGitTags() async {
    final ProcessResult result = await runGit(<String>[ "tag", "--sort", "version:refname"]);
    return result.stdout.toString().split("\n");
}

/// Returns all tags starting with [v|V][0-9]
List<String> getVersionTags(final List<String> tags) {
    if(tags.isEmpty) {
        return new List<String>();
    }
    return tags.where((tag) => tag.startsWith(new RegExp(r'^[v|V][0-9]'))).toList();
}

/// The command finds the most recent tag that is reachable from a commit.
///
/// If the tag points to the commit, then only the tag is shown.
/// Otherwise, it suffixes the tag name with the number of additional commits
/// on top of the tagged object and the abbreviated object name of the
/// most recent commit.
///
/// More: https://git-scm.com/docs/git-describe
Future<String> describeTag(final String tag) async {
    final ProcessResult result = await runGit(<String>[ "describe", "--tags", "--match", tag]);
    return result.stdout.toString().trim();
}

/// Converts GIT extended Format (v0.2-204-g507e9bc) to version
///
/// If [removeDash] is set to true the dash will be replace by a dot. e.g. 0.1-33 -> 0.1.33
String extendedFormatToVersion(final String versionFromGit,{final bool removeDash = false}) {
    final RegExp patchVersion = new RegExp(r"([^.]*)\.([^-]*)-([^-]*)-(.*)");

    String version = versionFromGit.replaceFirst(new RegExp(r"^[v|V]"), "");
    _logger.fine("Git-Version: $version");

    // So was: v0.3-1-g179fe76
    if(patchVersion.hasMatch(version)) {
        version = version.replaceAllMapped(patchVersion, (final Match m) {
            return "${m[1]}.${m[2]}-${m[3]}";
        });
    }
    // oder so v0.3-g179fe76
    else {
        version = version.replaceAllMapped(new RegExp(r"([^.]*)\.([^-]*)-(.*)"), (final Match m) {
            return "${m[1]}.${m[2]}";
        });
    }

    if(removeDash) {
        version = version.replaceAll("-", ".");
    }

    return version;
}

/// Returns the full path to GIT
FutureOr<String> _getGit() async {
    if (_gitCache == null) {
        _gitCache = await where(_gitBinName,all: false);
    }
    return _gitCache;
}

void _throwIfProcessFailed(
    ProcessResult pr, String process, List<String> args) {
    assert(pr != null);
    if (pr.exitCode != 0) {
        var message = '''
            stdout:
                ${pr.stdout}
            stderr:
                ${pr.stderr}'''.replaceAll(new RegExp(r'^\s*',multiLine: true), "");

        throw new ProcessException(process, args, "\n${message}", pr.exitCode);
    }
}
