<div align="center">

# asdf-sccache ![Build](https://github.com/emersonmx/asdf-sccache/workflows/Build/badge.svg) ![Lint](https://github.com/emersonmx/asdf-sccache/workflows/Lint/badge.svg)

[sccache](https://github.com/mozilla/sccache) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Why?](#why)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add sccache
# or
asdf plugin add https://github.com/emersonmx/asdf-sccache.git
```

sccache:

```shell
# Show all installable versions
asdf list-all sccache

# Install specific version
asdf install sccache latest

# Set a version globally (on your ~/.tool-versions file)
asdf global sccache latest

# Now sccache commands are available
sccache --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/emersonmx/asdf-sccache/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Emerson MX](https://github.com/emersonmx/)
