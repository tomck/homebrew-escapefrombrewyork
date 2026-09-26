class Macpkgmap < Formula
  desc "Neutral catalog of macOS packages and cross-manager relationships"
  homepage "https://github.com/tomck/macpkg-catalog"
  url "https://github.com/tomck/macpkg-catalog/archive/refs/tags/macpkgmap-v0.6.0.tar.gz"
  sha256 "1bff5bc5bfd8caae80b659031f36f89d7a90f3641df9b5c9dc37456734893ccc"
  license "MIT"
  depends_on "python@3.14"

  resource "catalog" do
    url "https://tomck.github.io/macpkg-catalog/catalog.json"
    sha256 "40a8300d77d06273efb53b3b6b2b614bde110c6c5d5942d44b6737b8cc4dae8b"
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
