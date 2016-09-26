load("//java:rules.bzl", "java_apidoc")

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

java_apidoc(
    name = "api",
    srcs = [
        "srcs",
    ],
    overview = "overview.html",
    quiet = True,
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
