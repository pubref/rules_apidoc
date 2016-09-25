load("//apidoc:rules.bzl", "java_apidoc")

filegroup(
    name = "srcs",
    srcs = [
        "BazelTaglet.java",
    ]
)

filegroup(
    name = "overview",
    srcs = [
        "overview.html",
    ]
)

java_library(
    name = "bazel",
    srcs = [
        "srcs",
    ],
    deps = [
        "//java:tools_jar",
    ],
)

java_apidoc(
    name = "api",
    deps = [
        "bazel",
        "//java:tools_jar",
    ],
    srcs = [
        "srcs",
    ],
    taglet_deps = [
        "bazel",
    ],
    taglet = [
        "org.pubref.rules_apidoc.taglets.BazelTaglet",
    ],
    overview = "overview.html",
    quiet = True,
)
