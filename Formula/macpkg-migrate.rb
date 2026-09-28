class MacpkgMigrate < Formula
  desc "Safe multi-manager Homebrew, MacPorts, and Fink migration planner"
  homepage "https://github.com/tomck/macpkg-migrate"
  url "https://github.com/tomck/macpkg-migrate/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "4c5255925b69cb67b42fdb123ed8568990b85e25ba2fd8c02188b740c9db2938"
  license "MIT"
  depends_on "python@3.14"
  depends_on "tomck/escapefrombrewyork/macpkgmap"

  # v0.7.0 imports macpkg_migrate_core (no longer vendored); stage it next
  # to the app.
  resource "macpkg-migrate-core" do
    url "https://files.pythonhosted.org/packages/58/b3/ce374d033d08ed34a3cb5c41c883d904c57199dfbfbc3f49b314baa3e6ce/macpkg_migrate_core-0.7.0.tar.gz"
    sha256 "272c3f4dd2cdda3f60a21b748c977ef67d7faab6f49e4fd3c85ebb5d0de4405b"
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
