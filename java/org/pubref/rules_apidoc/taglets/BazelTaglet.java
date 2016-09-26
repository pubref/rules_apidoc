package org.pubref.rules_apidoc.taglets;

import com.sun.tools.doclets.Taglet;
import com.sun.javadoc.Tag;
import java.util.Map;

/**
 * A sample Inline Taglet used to link to the bazel
 * documentation. This tag can be used in any kind of {@link
 * com.sun.javadoc.Doc}.  The text creates a hyperlink ot the bazel
 * documentation for that type.  For example, read the documentation
 * about {@bazel.doc attr}.
 * @author Paul Johnston
 */
public class BazelTaglet implements Taglet {

  private static final String NAME = "bazel.doc";

  private static final Map<String, String> PATHS = new java.util.HashMap();

  static {
    // Skylark objects
    PATHS.put("File", "skylark/lib/File.html");
    PATHS.put("Label", "skylark/lib/File.html");
    PATHS.put("Target", "skylark/lib/Target.html");
    PATHS.put("attr", "skylark/lib/attr.html");
    PATHS.put("cmd_helper", "skylark/lib/cmd_helper.html");
    PATHS.put("configuration", "skylark/lib/configuration.html");
    PATHS.put("ctx", "skylark/lib/ctx.html");
    PATHS.put("dict", "skylark/lib/dict.html");
    PATHS.put("list", "skylark/lib/list.html");
    PATHS.put("repository_ctx", "skylark/lib/repository_ctx.html");
    PATHS.put("root", "skylark/lib/root.html");
    PATHS.put("set", "skylark/lib/set.html");
    PATHS.put("string", "skylark/lib/string.html");
    PATHS.put("struct", "skylark/lib/struct.html");
    PATHS.put("tuple", "skylark/lib/tuple.html");

    // Attr types
    PATHS.put("attr_bool", "skylark/lib/attr.html#bool");
    PATHS.put("attr_int", "skylark/lib/attr.html#int");
    PATHS.put("attr_int_list", "skylark/lib/attr.html#int_list");
    PATHS.put("attr_label", "skylark/lib/attr.html#label");
    PATHS.put("attr_label_list", "skylark/lib/attr.html#label_list");
    PATHS.put("attr_output", "skylark/lib/attr.html#output");
    PATHS.put("attr_output_list", "skylark/lib/attr.html#output_list");
    PATHS.put("attr_string", "skylark/lib/attr.html#string");
    PATHS.put("attr_string_list", "skylark/lib/attr.html#string_list");
    PATHS.put("attr_string_list_dict", "skylark/lib/attr.html#string_list_dict");

    // functions
    PATHS.put("load", "be/functions.html#load");
    PATHS.put("package", "be/functions.html#load");
    PATHS.put("package_group", "be/functions.html#package_group");
    PATHS.put("licenses", "be/functions.html#licenses");
    PATHS.put("exports_files", "be/functions.html#exports_files");
    PATHS.put("glob", "be/functions.html#glob");
    PATHS.put("select", "be/functions.html#select");
    PATHS.put("workspace", "be/functions.html#workspace");

    // android rules
    PATHS.put("android_binary", "be/android.html#android_binary");
    PATHS.put("android_library", "be/android.html#android_library");

    // cc rules
    PATHS.put("cc_binary", "be/c-cpp.html#cc_binary");
    PATHS.put("cc_library", "be/c-cpp.html#cc_library");
    PATHS.put("cc_inc_library", "be/c-cpp.html#cc_inc_library");
    PATHS.put("cc_test", "be/c-cpp.html#cc_test");

    // java rules
    PATHS.put("java_binary", "be/java.html#java_binary");
    PATHS.put("java_import", "be/java.html#java_import");
    PATHS.put("java_library", "be/java.html#java_library");
    PATHS.put("java_test", "be/java.html#java_test");
    PATHS.put("java_plugin", "be/java.html#java_plugin");
    PATHS.put("java_toolchain", "be/java.html#java_toolchain");

    // more here...
  }

  /**
   * Return the name of this custom tag.
   */
  public String getName() {
    return NAME;
  }

  /**
   * @return true since this tag can be used in a field
   *         doc comment
   */
  public boolean inField() {
    return true;
  }

  /**
   * @return true since this tag can be used in a constructor
   *         doc comment
   */
  public boolean inConstructor() {
    return true;
  }

  /**
   * @return true since this tag can be used in a method
   *         doc comment
   */
  public boolean inMethod() {
    return true;
  }

  /**
   * @return true since this tag can be used in an overview
   *         doc comment
   */
  public boolean inOverview() {
    return true;
  }

  /**
   * @return true since this tag can be used in a package
   *         doc comment
   */
  public boolean inPackage() {
    return true;
  }

  /**
   * @return true since this
   */
  public boolean inType() {
    return true;
  }

  /**
   * Will return true since this is an inline tag.
   * @return true since this is an inline tag.
   */
  public boolean isInlineTag() {
    return true;
  }

  /**
   * Register this Taglet.
   * @param tagletMap  the map to register this tag to.
   */
  public static void register(Map tagletMap) {
    BazelTaglet tag = new BazelTaglet();
    Taglet t = (Taglet) tagletMap.get(tag.getName());
    if (t != null) {
      tagletMap.remove(tag.getName());
    }
    tagletMap.put(tag.getName(), tag);
  }

  /**
   * Given the <code>Tag</code> representation of this custom tag,
   * return its string representation.
   * @param tag he <code>Tag</code> representation of this custom tag.
   */
  public String toString(Tag tag) {
    String key = tag.text();
    String path = PATHS.get(key);
    if (path == null) {
      throw new IllegalArgumentException(
          "No known mapping to bazel library documentation for " + key);
    }
    return "<code><a target='_blank' style='color: #4caf50;' "
        + "href='https://www.bazel.io/versions/master/docs/"
        + path
        + "'>"
        + key
        + "</a></code>";
  }

  /**
   * This method should not be called since arrays of inline tags do
   * not exist.  Method {@link #toString(Tag)} should be used to
   * convert this inline tag to a string.
   * @param tags the array of <code>Tag</code>s representing of this custom tag.
   */
  public String toString(Tag[] tags) {
    return null;
  }
}
