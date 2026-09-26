class Brew2port < Formula
  include Language::Python::Virtualenv
  desc "Safe Homebrew to MacPorts migration planner"
  homepage "https://github.com/tomck/brew2port"
  url "https://github.com/tomck/brew2port/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "ae2f51a40a28d0d9790ae8656bf459f1bd3a0972a5e01f649a0f727a45cda4e6"
  license "MIT"
  depends_on "python@3.14"
  depends_on "tomck/escapefrombrewyork/macpkgmap"

  resource "macpkg-migrate-core" do
    url "https://files.pythonhosted.org/packages/37/b7/867d8cbb7cb9403ac45b6dfd113cbc691d41feed39d22262da00b11638ad/macpkg_migrate_core-0.6.0.tar.gz"
    sha256 "123a2bbb8a5df3d7febd4fe170ae6023f10f283e80cb595b9df1d0d9bb8a63ed"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec / "bin/brew2port"
  end

  test do
    system bin/"brew2port", "--help"
  end
end
