load("//apidoc:rules.bzl", "java_apidoc")

java_library(
    name = "doclets",
    srcs = glob([
        "**/*.java",
    ]),
    deps = [
        "//java:tools_jar",
    ]
)

java_apidoc(
    name = "api",
    deps = [
        "doclets",
        "//java:tools_jar",
    ],
    sourcepaths = [
        "java/",
    ],
    doclet_deps = [
        "doclets",
        "//java:tools_jar",
    ],
    doclet = "com.sun.tools.doclets.standard.Standard",
    packages = [
        "com.sun.tools.doclets",
        "com.sun.tools.doclets.formats.html",
        "com.sun.tools.doclets.formats.html.markup",
        "com.sun.tools.doclets.internal.toolkit",
        "com.sun.tools.doclets.internal.toolkit.builders",
        "com.sun.tools.doclets.internal.toolkit.taglets",
        "com.sun.tools.doclets.internal.toolkit.util",
    ],
    quiet = True,
)
