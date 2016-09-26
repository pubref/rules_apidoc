load("//java:rules.bzl", "javadoc")

filegroup(
    name = "srcs",
    srcs = [
        "BazelTaglet.java",
    ],
)

filegroup(
    name = "overview",
    srcs = [
        "overview.html",
    ],
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

javadoc(
    name = "api",
    srcs = [
        "srcs",
    ],
    overview = "overview.html",
    taglet = [
        "org.pubref.rules_apidoc.taglets.BazelTaglet",
    ],
    taglet_deps = [
        "bazel",
    ],
    deps = [
        "bazel",
    ],
)
