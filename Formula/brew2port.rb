class Brew2port < Formula
  include Language::Python::Virtualenv
  desc "Safe Homebrew to MacPorts migration planner"
  homepage "https://github.com/tomck/brew2port"
  url "https://github.com/tomck/brew2port/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "c4fbd03688dcf63171f442d4061a7a9d96a00f79ec1c0ddd47ec63c806a8cd01"
  license "MIT"
  depends_on "python@3.14"
  depends_on "tomck/escapefrombrewyork/macpkgmap"

  resource "macpkg-migrate-core" do
    url "https://files.pythonhosted.org/packages/source/m/macpkg-migrate-core/macpkg_migrate_core-0.3.0.tar.gz"
    sha256 "ecadeea8c550f302381b7bc8c625c2138558b9afab17e63ef3ac8e7ab8c2a530"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec / "bin/brew2port"
  end

  test do
    system bin/"brew2port", "--help"
  end
end
