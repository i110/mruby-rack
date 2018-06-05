mruby-rack
========
[![Build Status](https://travis-ci.org/i110/mruby-rack.svg?branch=master)](https://travis-ci.org/i110/mruby-rack)

`Rack` classes for mruby.

Current ported revision is: https://github.com/rack/rack/commit/f8415b8e1a6d64432e2ee6bb3ae3d951773bd0e6

## Installation
Add the line below to your `build_config.rb`:

```
  conf.gem :github => 'i110/mruby-rack'
```

## Implemented classes

| class                           | mruby-rack | memo |
| ------------------------------- | -------- | ---- |
| Rack                            |    o     |      |
| Rack::Auth::Abstract::Handler   |    o     |      |
| Rack::Auth::Abstract::Request   |    o     |      |
| Rack::Auth::Basic               |    o     |      |
| Rack::Auth::Digest::MD5         |    o     |      |
| Rack::Auth::Digest::Nonce       |    o     |      |
| Rack::Auth::Digest::Params      |    o     |      |
| Rack::Auth::Digest::Request     |    o     |      |
| Rack::BodyProxy                 |    o     |      |
| Rack::Builder                   |    o     |      |
| Rack::Cascade                   |    o     |      |
| Rack::Chunked                   |    o     |      |
| Rack::CommonLogger              |    o     |      |
| Rack::ConditionalGet            |    o     |      |
| Rack::Config                    |    o     |      |
| Rack::ContentLength             |    o     |      |
| Rack::ContentType               |    o     |      |
| Rack::Deflater                  |          |      |
| Rack::Directory                 |    o     |      |
| Rack::Etag                      |    o     |      |
| Rack::Events                    |          |      |
| Rack::File                      |    o     |      |
| Rack::Handler                   |          |      |
| Rack::Handler::CGI              |          |      |
| Rack::Handler::FastCGI          |          |      |
| Rack::Handler::LSWS             |          |      |
| Rack::Handler::SCGI             |          |      |
| Rack::Handler::Thin             |          |      |
| Rack::Handler::WEBrick          |          |      |
| Rack::Head                      |    o     |      |
| Rack::Lint                      |    o     |      |
| Rack::Lobster                   |          |      |
| Rack::Lock                      |          |      |
| Rack::Logger                    |    o     |      |
| Rack::MediaType                 |    o     |      |
| Rack::MethodOverride            |    o     |      |
| Rack::Mime                      |    o     |      |
| Rack::Mock                      |    o     |      |
| Rack::Multipart                 |    o     |      |
| Rack::Multipart::Generator      |    o     |      |
| Rack::Multipart::Parser         |    o     |      |
| Rack::Multipart::UploadedFile   |    o     |      |
| Rack::NullLogger                |    o     |      |
| Rack::QueryParser               |    o     |      |
| Rack::Recursive                 |    o     |      |
| Rack::Reloader                  |          |      |
| Rack::Request                   |    o     |      |
| Rack::Response                  |    o     |      |
| Rack::RewindableInput           |    o     |      |
| Rack::Runtime                   |    o     |      |
| Rack::Sendfile                  |    o     |      |
| Rack::Server                    |          |      |
| Rack::Session::Abstract::ID     |    o     |      |
| Rack::Session::Cookie           |          |      |
| Rack::Session::Memcache         |          |      |
| Rack::Session::Pool             |          |      |
| Rack::ShowExceptions            |    o     |      |
| Rack::ShowStatus                |    o     |      |
| Rack::Static                    |    o     |      |
| Rack::TempfileReaper            |    o     |      |
| Rack::URLMap                    |    o     |      |
| Rack::Utils                     |    o     |      |

## License

mruby-rack is released under the [MIT License](https://opensource.org/licenses/MIT).
