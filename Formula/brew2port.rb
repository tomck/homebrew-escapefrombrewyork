class Brew2port < Formula
  include Language::Python::Virtualenv
  desc "Safe Homebrew to MacPorts migration planner"
  homepage "https://github.com/tomck/brew2port"
  url "https://github.com/tomck/brew2port/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "863da76c57d19315fdba6582494a2f4205a56fa11683b9ea3d2e692cf9ae587a"
  license "MIT"
  depends_on "python@3.14"
  depends_on "tomck/escapefrombrewyork/macpkgmap"

  resource "macpkg-migrate-core" do
    url "https://files.pythonhosted.org/packages/58/b3/ce374d033d08ed34a3cb5c41c883d904c57199dfbfbc3f49b314baa3e6ce/macpkg_migrate_core-0.7.0.tar.gz"
    sha256 "272c3f4dd2cdda3f60a21b748c977ef67d7faab6f49e4fd3c85ebb5d0de4405b"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec / "bin/brew2port"
  end

  test do
    system bin/"brew2port", "--help"
  end
end
