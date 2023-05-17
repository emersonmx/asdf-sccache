#!/usr/bin/env bash

set -euo pipefail

case "$(uname -m)" in
  "arm64" | "aarch64")
    cpu_arch="aarch64"
    ;;
  *)
    cpu_arch="x86_64"
    ;;
esac

case "$(uname -s)" in
  "Linux")
    platform="${cpu_arch}-unknown-linux-musl"
    ;;
  "Darwin")
    platform="${cpu_arch}-apple-darwin"
    ;;
esac

GH_REPO="https://github.com/mozilla/sccache"

fail() {
  echo -e "asdf-sccache: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if sccache is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

get_github_tag_version() {
  version="$1"
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- | grep -E "^v?$version$"
}

list_all_versions() {
  list_github_tags
}

download_release() {
  local version filename url
  version="$(get_github_tag_version $1)"
  filename="$2"

  url="$GH_REPO/releases/download/${version}/sccache-${version}-${platform}.tar.gz"

  echo "* Downloading sccache release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-sccache supports release installs only"
  fi

  local release_file="$install_path/sccache-$version.tar.gz"
  (
    mkdir -p "$install_path/bin"
    download_release "$version" "$release_file"
    tar -xzf "$release_file" -C "$install_path" --strip-components=1 || fail "Could not extract $release_file"
    rm "$release_file"

    local tool_cmd
    tool_cmd="$(echo "sccache --help" | cut -d' ' -f1)"
    tool_path="$install_path/bin/$tool_cmd"
    mv -f "$install_path/$tool_cmd" "$tool_path"
    chmod +x "$tool_path"
    test -x "$tool_path" || fail "Expected $install_path/$tool_cmd to be executable."

    echo "sccache $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing sccache $version."
  )
}
