mruby-rack
========

`Rack` classes for mruby

## Installation
Add the line below to your `build_config.rb`:

```
  conf.gem :github => 'i110/mruby-rack'
```

## Implemented classes

| class                            | mruby-rack | memo |
| -------------------------------  | -------- | ---- |
| Rack::Auth::Abstract::Handler    |    o     |      |
| Rack::Auth::Abstract::Request    |    o     |      |
| Rack::Auth::Basic                |    o     |      |
| Rack::Auth::Digest::MD5          |    o     |      |
| Rack::Auth::Digest::Nonce        |    o     |      |
| Rack::Auth::Digest::Params       |    o     |      |
| Rack::Auth::Digest::Request      |    o     |      |
| Rack::BodyProxy                  |    o     |      |
| Rack::Builder                    |    o     |      |
| Rack::Cascade                    |    o     |      |
| Rack::Chunked                    |    o     |      |
| Rack::CommonLogger               |    o     |      |
| Rack::ConditionalGet             |    o     |      |
| Rack::Config                     |    o     |      |
| Rack::ContentLength              |    o     |      |
| Rack::ContentType                |    o     |      |
| Rack::Directory                  |    o     |      |
| Rack::Etag                       |    o     |      |
| Rack::File                       |    o     |      |
| Rack::Head                       |    o     |      |
| Rack::Lint                       |    o     |      |
| Rack::Logger                     |    o     |      |
| Rack::MediaType                  |    o     |      |
| Rack::MethodOverride             |    o     |      |
| Rack::Mime                       |    o     |      |
| Rack::Mock                       |    o     |      |
| Rack::Multipart                  |    o     |      |
| Rack::Multipart::Generator       |    o     |      |
| Rack::Multipart::Parser          |    o     |      |
| Rack::Multipart::UploadedFile    |    o     |      |
| Rack::NullLogger                 |    o     |      |
| Rack::QueryParser                |    o     |      |
| Rack::Rack                       |    o     |      |
| Rack::Recursive                  |    o     |      |
| Rack::Reloader                   |    o     |      |
| Rack::Request                    |    o     |      |
| Rack::Response                   |    o     |      |
| Rack::RewindableInput            |    o     |      |
| Rack::Runtime                    |    o     |      |
| Rack::Sendfile                   |    o     |      |
| Rack::Session::Abstract::Id      |    o     |      |
| Rack::ShowExceptions             |    o     |      |
| Rack::ShowStatus                 |    o     |      |
| Rack::Static                     |    o     |      |
| Rack::TempfileReaper             |    o     |      |
| Rack::URLMap                     |    o     |      |
| Rack::Utils                      |    o     |      |

## License

Copyright (c) 2018 Ichito Nagata

Permission is hereby granted, free of charge, to any person obtaining a 
copy of this software and associated documentation files (the "Software"), 
to deal in the Software without restriction, including without limitation 
the rights to use, copy, modify, merge, publish, distribute, sublicense, 
and/or sell copies of the Software, and to permit persons to whom the 
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in 
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
DEALINGS IN THE SOFTWARE.
