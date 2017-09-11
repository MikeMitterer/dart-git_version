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

import 'package:logging/logging.dart';
import 'package:test/test.dart';
import 'package:git_version/git_version.dart';

import 'config.dart';

void main() {
    configLogging(level: Level.WARNING);

    group('Git', () {
        setUp(() {});

        test('> isGitAvailable', () async {
            final result = await runGit(<String>["--version"]);
            final version = result.stdout.toString().trim();
            
            expect(version, startsWith("git version"));
        }); // end of 'isGitAvailable' test
    }); // End of '' group

    group('Version', () {
        setUp(() {});

        test('> All versions', () async {
            final List<String> tags = await getSortedGitTags();
            expect(tags, isNotNull);
        }); // end of 'All versions' test

        test('> Version Strings', () {
            expect(getVersionTags(<String>[ "abc", "v0.1.1", "xyz"]).length, equals(1));
            expect(getVersionTags(<String>[ "V0.1.1"]).length, equals(1));
            expect(getVersionTags(<String>[ "abc", "xyz"]).length, equals(0));
            expect(getVersionTags(<String>[ ]).length, equals(0));
            expect(getVersionTags(<String>[ "abc","v0.1.0", "1.2.3", "v0.1.1", "xyz"]).last, "v0.1.1");
            expect(getVersionTags(<String>[ "abc","v0.1.0", "1.2.3", "v0.1.1", "xyz"]).first, "v0.1.0");
        }); // end of 'Version Strings' test

        test('> Extended format', () async {
            expect(extendedFormatToVersion("v1.0.0"), "1.0.0");
            expect(extendedFormatToVersion("v0.3-1-g179fe76"), "0.3-1");
            expect(extendedFormatToVersion("v0.3-1-g179fe76",removeDash: true), "0.3.1");
            expect(extendedFormatToVersion("v0.3-g179fe76"), "0.3");
            expect(extendedFormatToVersion("v0.3"), "0.3");
            expect(extendedFormatToVersion("v0.2-204-g507e9bc)"), "0.2-204");
            expect(extendedFormatToVersion("v0.2-204-g507e9bc)",removeDash: true), "0.2.204");
        }); // end of 'Convert version' test

    }); // End of '' group
}
