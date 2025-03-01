cask "dotnet-preview" do
  arch = Hardware::CPU.intel? ? "x64" : "arm64"

  if Hardware::CPU.intel?
    version "7.0.0-preview.4.22229.4,1876aa0e-9484-41fd-b6e5-8a9a40efff6a,edacb1069d1d3cc1ee33a5bb6e4d585d"
    sha256 "c52e082a44c87b83452461f66f13227d3eff84d7c157a1c7f92abce0991529e6"
  else
    version "7.0.0-preview.1.22076.8,17b7ed90-2cac-4a18-9d04-787fb76a0175,52773df7c2c4982728cc153111c8a0aa"
    sha256 "1910170a8f4c1223a3b7a5cbcbdfb4763e7897e57570d4dd74ece98f08203814"
  end

  url "https://download.visualstudio.microsoft.com/download/pr/#{version.csv[1]}/#{version.csv[2]}/dotnet-runtime-#{version.csv[0]}-osx-#{arch}.pkg"
  name ".Net Runtime"
  desc "Developer platform"
  homepage "https://www.microsoft.com/net/core#macos"

  livecheck do
    url "https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/#{version.major_minor}/releases.json"
    regex(%r{/download/pr/([^/]+)/([^/]+)/dotnet-runtime-v?(.+)-osx-#{arch}\.pkg}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map do |match|
        "#{match[2]},#{match[0]},#{match[1]}"
      end
    end
  end

  conflicts_with cask: [
    "dotnet",
    "dotnet-sdk",
    "dotnet-sdk-preview",
  ], formula: "dotnet"
  depends_on macos: ">= :mojave"

  pkg "dotnet-runtime-#{version.csv[0]}-osx-#{arch}.pkg"
  binary "/usr/local/share/dotnet/dotnet"

  uninstall pkgutil: "com.microsoft.dotnet.*",
            delete:  "/etc/paths.d/dotnet"

  zap trash: "~/.nuget"
end
