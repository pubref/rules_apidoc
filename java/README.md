# Java Rules

| Rule | Description |
| ---: | :--- |
| [javadoc](#javadoc) | Generate `javadoc` HTML documentation. |

## java\_apidoc

Runs the `javadoc` command installed in the `@local_jdk//`.  To run
this command, you'll want to generally provide either `deps + srcs` (pattern 1) or
`deps + sourcepaths + packages` (pattern 2):

1. `deps`: java_library dependencies that provide compiled jar outputs
that will be uses to populate the `--classpath` argument.

1. `srcs`: filegroup dependencies that provide the `*.java`
sourcefiles.

1. `packages`: a list of package names that the javadoc command should
   generated output for.  Unless your java source package naming
   starts in the root of the workspace, you'll need to provide it in
   the 'sourcepaths` attribute.

1. `sourcepaths`: a list of strings that name directories where your
   java is stored.

The list of attributes for this rule is extensive but mirrors the
`javadoc` command closely.  Please refer to the
[source code](https://github.com/pubref/rules_apidoc/blob/master/apidoc/internal/javadoc.bzl)
for definitive reference.

### Pattern 1: Using a set of source files via the `srcs` attribute

Here's an [example command](org/pubref/rules_apidoc/taglets) that
generates API documentation for a Taglet that links to the bazel
documentation (as well as using *itself* as a custom taglet):

```python
load("@org_pubref_rules_apidoc//java:rules.bzl", "javadoc")

filegroup(
    name = "srcs",
    srcs = ["BazelTaglet.java"],
)

filegroup(
    name = "overview",
    srcs = ["overview.html"],
)

java_library(
    name = "bazel",
    srcs = ["srcs"],
    deps = ["@org_pubref_rules_apidoc//java:tools_jar"],
)

javadoc(
    name = "api",
    deps = [":bazel"],
    srcs = ["srcs"],

    taglet = ["org.pubref.rules_apidoc.taglets.BazelTaglet"],
    taglet_deps = [":bazel"],

    overview = "overview.html",
    quiet = True,
)
```

```sh
~/github/rules_apidoc*master$ bazel build java/org/pubref/rules_apidoc/taglets:api
Target //java/org/pubref/rules_apidoc/taglets:api up-to-date:
  bazel-genfiles/java/org/pubref/rules_apidoc/taglets/index.html
```

### Pattern 2: Using a sourcepath and package names.

Here's an [example command](com/sun/tools/doclets) that generates API
documentation for the Docklet API (as well as using *itself* as the
custom doclet):

```python
load("@org_pubref_rules_apidoc//java:rules.bzl", "javadoc")

java_library(
    name = "doclets",
    srcs = glob(["**/*.java"]),
    deps = ["@org_pubref_rules_apidoc//java:tools_jar"],
)

javadoc(
    name = "api",

    deps = [":doclets"],
    sourcepaths = ["java/"],
    packages = [
        "com.sun.tools.doclets",
        "com.sun.tools.doclets.formats.html",
        "com.sun.tools.doclets.formats.html.markup",
        "com.sun.tools.doclets.internal.toolkit",
        "com.sun.tools.doclets.internal.toolkit.builders",
        "com.sun.tools.doclets.internal.toolkit.taglets",
        "com.sun.tools.doclets.internal.toolkit.util",
    ],

    doclet = "com.sun.tools.doclets.standard.Standard",
    doclet_deps = [":doclets"],
    quiet = True,
)
```

Building this target will generate HTML documentation in the
`bazel-genfiles` package subdirectory:

```sh
~/github/rules_apidoc*master$ bazel build java/com/sun/tools/doclets:api
Target //java/com/sun/tools/doclets:api up-to-date:
  bazel-genfiles/java/com/sun/tools/doclets/index.html ```
```
