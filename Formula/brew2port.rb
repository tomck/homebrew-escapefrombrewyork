class Brew2port < Formula
  include Language::Python::Virtualenv
  desc "Safe Homebrew to MacPorts migration planner"
  homepage "https://github.com/tomck/brew2port"
  url "https://github.com/tomck/brew2port/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "d674bf44677b76cd97bff2bbb6eaba355575afcd906c1347ea0dcb5a9a91baff"
  license "MIT"
  depends_on "python@3.14"
  depends_on "tomck/escapefrombrewyork/macpkgmap"

  resource "macpkg-migrate-core" do
    url "https://files.pythonhosted.org/packages/16/57/395326459de3ecc8c56777647031ae17a4f4a388a3ab23593512f8a4cf40/macpkg_migrate_core-0.5.0.tar.gz"
    sha256 "3d4152d7972147cf2c37720b0a682351947cda1990bdf837c49ebd8d7f1baebe"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec / "bin/brew2port"
  end

  test do
    system bin/"brew2port", "--help"
  end
end
