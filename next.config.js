const nextConfig = {
  reactStrictMode: true,
  webpack: (config) => {
    config.resolve.alias["@"] = require("path").resolve(__dirname)
    return config
  },
}

module.exports = nextConfig

