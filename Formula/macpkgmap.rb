class Macpkgmap < Formula
  desc "Neutral catalog of macOS packages and cross-manager relationships"
  homepage "https://github.com/tomck/macpkg-catalog"
  url "https://github.com/tomck/macpkg-catalog/archive/refs/tags/macpkgmap-v0.5.0.tar.gz"
  sha256 "9b43cf2e9d1b52c86c82ff1689f6056ddf97bee253e55be0e2435269590b5767"
  license "MIT"
  depends_on "python@3.14"

  resource "catalog" do
    url "https://tomck.github.io/macpkg-catalog/catalog.json"
    sha256 "739d272d0b51a75c9153cb2fad54588573e757c436b44e5b38633d9476eea3c2"
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
