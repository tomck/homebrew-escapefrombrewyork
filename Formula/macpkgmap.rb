class Macpkgmap < Formula
  desc "Neutral catalog of macOS packages and cross-manager relationships"
  homepage "https://github.com/tomck/macpkg-catalog"
  url "https://github.com/tomck/macpkg-catalog/archive/refs/tags/macpkgmap-v0.7.0.tar.gz"
  sha256 "659a38c112392fc10e02c45afa74e07479fa2ac982d6df62cdc84a02c26811d7"
  license "MIT"
  depends_on "python@3.14"

  resource "catalog" do
    url "https://tomck.github.io/macpkg-catalog/catalog.json"
    sha256 "5c64774e2733c3b0fb10c02bf8c9e2a47624ab0ad65c73bbad3696925afc8cd0"
  end

  def install
    libexec.install "macpkg_catalog"
    (share/"macpkgmap").mkpath
    resource("catalog").stage do
      (share/"macpkgmap"/"catalog.json").install "catalog.json"
    end
    (bin/"macpkgmap").write <<~EOS
      #!/bin/sh
      export PYTHONPATH="#{libexec}${PYTHONPATH:+:$PYTHONPATH}"
      snapshot="#{share}/macpkgmap/catalog.json"
      case "$1" in
        lookup|relations|search|popularity|export)
          exec "#{Formula["python@3.14"].opt_bin}/python3.14" -m macpkg_catalog "$@" --snapshot "$snapshot"
          ;;
        *)
          exec "#{Formula["python@3.14"].opt_bin}/python3.14" -m macpkg_catalog "$@"
          ;;
      esac
    EOS
    chmod 0755, bin/"macpkgmap"
  end

  test do
    system bin/"macpkgmap", "--help"
  end
end
