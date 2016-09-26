# `rules_apidoc` [![Build Status](https://travis-ci.org/pubref/rules_apidoc.svg?branch=master)](https://travis-ci.org/pubref/rules_apidoc)

First, load `rules_apidoc` in your `WORKSPACE`:

```python
git_repository(
    name = "org_pubref_rules_apidoc",
    tag = "v0.1.1",
    remote = "https://github.com/pubref/rules_apidoc.git",
)
```

Then, use a `BUILD` file rule to generate documentation for the
language of your choice.

| Language | Rule | Description |
| :---     | ---: | :---------- |
| [Java](java)     | [javadoc](java#javadoc) | Generate `javadoc` api documentation. |
