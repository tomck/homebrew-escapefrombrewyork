class MacpkgMigrate < Formula
  desc "Safe multi-manager Homebrew, MacPorts, and Fink migration planner"
  homepage "https://github.com/tomck/macpkg-migrate"
  url "https://github.com/tomck/macpkg-migrate/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "dc6ce72b650e58b1f010c1a3089a9237abb0170e10bfac7893b223f89ac549d9"
  license "MIT"
  depends_on "python@3.14"
  depends_on "tomck/escapefrombrewyork/macpkgmap"

  # v0.5.0 imports macpkg_migrate_core (no longer vendored); stage it next
  # to the app. GitHub tarball, not PyPI: no 0.5.0 sdist published yet.
  resource "macpkg-migrate-core" do
    url "https://github.com/tomck/macpkg-migrate-core/archive/refs/tags/v0.5.0.tar.gz"
    sha256 "52f7d39bf7e89d8b9337fe8e4dd76d3c0722a74e6218f726be22039a5f20da61"
  end

  def install
    libexec.install "macpkg_migrate", "pyproject.toml", "README.md"
    resource("macpkg-migrate-core").stage do
      (libexec/"macpkg_migrate_core").install "__init__.py", "core.py"
    end
    (bin/"macpkg-migrate").write <<~EOS
      #!/bin/sh
      export PYTHONPATH="#{libexec}${PYTHONPATH:+:$PYTHONPATH}"
      exec "#{Formula["python@3.14"].opt_bin}/python3.14" -m macpkg_migrate "$@"
    EOS
    chmod 0755, bin/"macpkg-migrate"
  end

  test do
    system bin/"macpkg-migrate", "--help"
  end
end
