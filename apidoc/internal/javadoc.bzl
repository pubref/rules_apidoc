BOOL_ATTRS = [
    "public",
    "protected",
    "private",
    "nohelp",
    "nonavbar",
    "use",
    "warn",
    "quiet",
    "breakiterator",
    "version",
    "author",
    "docfilessubdirs",
    "splitindex",
    "nocomment",
    "nodeprecated",
    "nosince",
    "notimestamp",
    "nodeprecatedlist",
    "notree",
    "noindex",
    "serialwarn",
    "linksource",
    "keywords",
]

#default = "com.inxar.doclet1.standard.Standard",

STRING_ATTRS = [
    "doclet",
    "tagletpath",
    "source",
    "charset",
    "locale",
    "encoding",
    "link",
    "windowtitle",
    "doctitle",
    "header",
    "footer",
    "top",
    "bottom",
    "sourcetab",
]

STRING_LIST_ATTRS = [
    "J_opts",
    "X_opts",
    "taglet",
    "tag",
]

DICT_STRING_STRING_ATTRS = [
    "linkoffline",
]

PATH_LIST_ATTRS = [
    "exclude",
    "subpackages",
    "extdirs",
    "excludedocfilessubdir",
    "noqualifier",
]

SINGLE_FILE_PATH_ATTRS = [
    "overview",
    "helpfile",
    "stylesheetfile",
]

def _mk_attrs():
    #
    # Non-biolerplate attrs; either more complex definitions or have
    # special handling in the rule implementation.
    #
    attrs = {
        "sourcepaths": attr.string_list(mandatory = False),
        "groups": attr.string_dict(),
        "java_tool": attr.label(
            default = Label("@local_jdk//:java"),
            single_file = True,
            executable = True,
        ),
        "tools_jar": attr.label(
            default = Label("//java:tools_jar"),
            single_file = True,
        ),
        "doclet_deps": attr.label_list(
            providers = ["java"],
        ),
        "taglet_deps": attr.label_list(
            providers = ["java"],
        ),
        "deps": attr.label_list(
            mandatory = True,
            providers = ["java"],
        ),
        "srcs": attr.label_list(
            allow_files = FileType([".java"]),
        ),
        "packages": attr.string_list(),
        "outdir": attr.string(),
    }

    #
    # Biolerplate attrs
    #
    for name in BOOL_ATTRS:
        attrs[name] = attr.bool()
    for name in STRING_ATTRS:
        attrs[name] = attr.string()
    for name in STRING_LIST_ATTRS:
        attrs[name] = attr.string_list()
    for name in PATH_LIST_ATTRS:
        attrs[name] = attr.string_list()
    for name in SINGLE_FILE_PATH_ATTRS:
        attrs[name] = attr.label(single_file = True, allow_files = True)

    # Boilerplate overrides
    attrs["quiet"] = attr.bool(default = True)

    return attrs


def _get_java_dep_jars(deps):
    jars = []
    for dep in deps:
        for jar in dep.files:
            jars.append(jar)
        for jar in dep.java.transitive_deps:
            if not jar.basename.endswith("-ijar.jar"):
                jars.append(jar)
    return jars


def _get_javadoc_tool(java_tool):
    javadoc = java_tool.dirname + "/javadoc"
    if java_tool.basename.endswith(".exe"):
        javadoc += ".exe"
    return javadoc


def _get_output_index_html(ctx, outdir):
    filename = "index.html"
    if outdir:
        filename = outdir + "/" + filename
    return ctx.new_file(filename)


def _pathlist(files):
    return ":".join([file.path for file in files])


def _javadoc_impl(ctx):

    #
    # Preparation of inputs and dependencies.
    #
    java = ctx.executable.java_tool
    javadoc = _get_javadoc_tool(java)
    jars = _get_java_dep_jars(ctx.attr.deps)
    jars.append(ctx.file.tools_jar)
    doclet_jars = _get_java_dep_jars(ctx.attr.doclet_deps)
    taglet_jars = _get_java_dep_jars(ctx.attr.taglet_deps)
    srcfiles = ctx.files.srcs
    index_html = _get_output_index_html(ctx, ctx.attr.outdir)
    all_jars = jars + doclet_jars + taglet_jars
    inputs = [java] + all_jars + srcfiles

    #
    # Command generation.
    #
    cmds = []
    if ctx.attr.outdir:
        cmds += ["mkdir -p %s" % index_html.dirname]

    args = [javadoc]
    args += ["-d", index_html.dirname]
    args += ["-classpath", _pathlist(jars)]
    if doclet_jars: args += ["-docletpath", _pathlist(doclet_jars)]
    if taglet_jars: args += ["-tagletpath", _pathlist(taglet_jars)]
    if ctx.attr.sourcepaths: args += ["-sourcepath", ":".join(ctx.attr.sourcepaths)]

    if not ctx.attr.warn:
        args += ["-Xdoclint:none"]
    for k, v in ctx.attr.groups.items():
        args += ["-group", k, v]

    #
    # Boilerplate args
    #
    for key in BOOL_ATTRS:
        if getattr(ctx.attr, key):
            args += ["-" + key]
    for key in STRING_ATTRS:
        val = getattr(ctx.attr, key)
        if val: args += ["-" + key, "'%s'" % val]
    for key in PATH_LIST_ATTRS:
        vals = getattr(ctx.attr, key)
        if vals: args += ["-" + key, ":".join(vals)]
    for key in STRING_LIST_ATTRS:
        for val in getattr(ctx.attr, key):
            args += ["-" + key, val]
    for key in SINGLE_FILE_PATH_ATTRS:
        if hasattr(ctx.file, key):
            file = getattr(ctx.file, key)
            if file:
                args += ["-" + key, file.path]
                inputs.append(file)

    args += ctx.attr.packages
    args += [file.path for file in srcfiles]

    javadoc_cmd = " ".join(args)
    if not ctx.attr.quiet:
        print("javadoc: %s" % "\n".join(args))
    cmds.append(javadoc_cmd)

    #print("cmd: %s" % " && ".join(cmds))

    ctx.action(
        progress_message = "JavaDoc",
        command = " && ".join(cmds),
        inputs = inputs,
        outputs = [index_html],
    )

    return struct(
        files = set([index_html]),
    )

javadoc = rule(
    implementation = _javadoc_impl,
    attrs = _mk_attrs(),
    output_to_genfiles = True,
)
