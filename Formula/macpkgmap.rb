class Macpkgmap < Formula
  desc "Neutral catalog of macOS packages and cross-manager relationships"
  homepage "https://github.com/tomck/macpkg-catalog"
  url "https://github.com/tomck/macpkg-catalog/archive/refs/tags/macpkgmap-v0.1.0.tar.gz"
  sha256 "665dbb3b97d1e87f430f009c0d48610ccc8aa43c7c1bf051c0057f019be7a4a1"
  license "MIT"
  depends_on "python@3.14"

  resource "catalog" do
    url "https://tomck.github.io/macpkg-catalog/catalog.json"
    sha256 "c442b67c6c2752fcfb0aff1fb8abcc7cfd16448f0d438739c1906462948475f2"
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
