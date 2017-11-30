import 'package:grinder/grinder.dart';

main(final List<String> args) {
    args.forEach((final String arg) => print(arg));
    grind(args);
}

@Task()
@Depends(test)
build() {
}

@Task()
clean() => defaultClean();

@Task()
@Depends(analyze)
test() {
    //new TestRunner().testAsync(files: "test/unit");
    new PubApp.local('test').run([]);
    // new TestRunner().testAsync(files: "test/integration");

    // Alle test mit @TestOn("content-shell") im header
    // new TestRunner().test(files: "test/unit",platformSelector: "content-shell");
    // new TestRunner().test(files: "test/integration",platformSelector: "content-shell");
}

@Task()
analyze() {
    final List<String> libs = [
        "lib/git_version.dart",
        "bin/showGitVersion.dart"
    ];

    libs.forEach((final String lib) => Analyzer.analyze(lib));
    // Analyzer.analyze("test");
}

@Task('Deploy built app.')
//@Depends(build, test)
deploy() {
    run(sdkBin('pub'),arguments: [ "global", "activate", "--source", "path", "."]);
}
