class MacpkgMigrate < Formula
  desc "Safe multi-manager Homebrew, MacPorts, and Fink migration planner"
  homepage "https://github.com/tomck/macpkg-migrate"
  url "https://github.com/tomck/macpkg-migrate/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "81b1bafa306497c63c79953ab11cb30d5af1ab16900ba78faab762c868c87e36"
  license "MIT"
  depends_on "python@3.14"
  depends_on "tomck/escapefrombrewyork/macpkgmap"

  # v0.6.0 imports macpkg_migrate_core (no longer vendored); stage it next
  # to the app.
  resource "macpkg-migrate-core" do
    url "https://files.pythonhosted.org/packages/37/b7/867d8cbb7cb9403ac45b6dfd113cbc691d41feed39d22262da00b11638ad/macpkg_migrate_core-0.6.0.tar.gz"
    sha256 "123a2bbb8a5df3d7febd4fe170ae6023f10f283e80cb595b9df1d0d9bb8a63ed"
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
