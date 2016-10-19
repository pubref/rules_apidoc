load("//java:rules.bzl", "javadoc")

java_library(
    name = "doclets",
    srcs = glob([
        "**/*.java",
    ]),
    deps = [
        "//java:tools_jar",
    ],
)

javadoc(
    name = "api",
    doclet = "com.sun.tools.doclets.standard.Standard",
    doclet_deps = [
        "doclets",
    ],
    packages = [
        "com.sun.tools.doclets",
        "com.sun.tools.doclets.formats.html",
        "com.sun.tools.doclets.formats.html.markup",
        "com.sun.tools.doclets.internal.toolkit",
        "com.sun.tools.doclets.internal.toolkit.builders",
        "com.sun.tools.doclets.internal.toolkit.taglets",
        "com.sun.tools.doclets.internal.toolkit.util",
    ],
    quiet = False,
    sourcepaths = [
        "java/",
    ],
    deps = [
        "doclets",
    ],
)
