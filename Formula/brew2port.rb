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
    # No 0.5.0 sdist on PyPI yet (publish runs on GitHub Release); use the tag
    # tarball until the release is published.
    url "https://github.com/tomck/macpkg-migrate-core/archive/refs/tags/v0.5.0.tar.gz"
    sha256 "52f7d39bf7e89d8b9337fe8e4dd76d3c0722a74e6218f726be22039a5f20da61"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec / "bin/brew2port"
  end

  test do
    system bin/"brew2port", "--help"
  end
end
