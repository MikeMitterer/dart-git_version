import 'package:barback/barback.dart';

import 'dart:async';
import 'package:git_version/git_version.dart';

/// Replaces the String %version% with the latest GIT-Version (Extended Version)
class InsertGitVersion extends Transformer {
    String _version;

    // A constructor named "asPlugin" is required. It can be empty, but
    // it must be present. It is how pub determines that you want this
    // class to be publicly available as a loadable transformer plugin.
    InsertGitVersion.asPlugin();

    Future<bool> isPrimary(AssetId id) async
        => (id.extension == '.html' || id.extension == ".dart");

    Future apply(Transform transform) async {
        final content = await transform.primaryInput.readAsString();

        if(_version == null) {
            final tags = getVersionTags(await getSortedGitTags());
            if(tags.isEmpty) {
                throw new ArgumentError(ERROR_NO_VERSION_TAG);
            }

            final String tag = await describeTag(tags.last);
            _version = extendedFormatToVersion(tag);
        }
        
        final id = transform.primaryInput.id;
        final newContent = content.replaceAll("%version%",_version);

        transform.addOutput(new Asset.fromString(id, newContent));
    }
}


