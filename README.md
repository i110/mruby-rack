mruby-rack
========

`Rack` classes for mruby

## Installation
Add the line below to your `build_config.rb`:

```
  conf.gem :github => 'i110/mruby-rack'
```

## Implemented classes

| class                      | mruby-rack | memo |
| -------------------------  | -------- | ---- |
| Auth::Abstract::Handler    |    o     |      |
| Auth::Abstract::Request    |    o     |      |
| Auth::Basic                |    o     |      |
| Auth::Digest::MD5          |    o     |      |
| Auth::Digest::Nonce        |    o     |      |
| Auth::Digest::Params       |    o     |      |
| Auth::Digest::Request      |    o     |      |
| BodyProxy                  |    o     |      |
| Builder                    |    o     |      |
| Cascade                    |    o     |      |
| Chunked                    |    o     |      |
| CommonLogger               |    o     |      |
| ConditionalGet             |    o     |      |
| Config                     |    o     |      |
| ContentLength              |    o     |      |
| ContentType                |    o     |      |
| Directory                  |    o     |      |
| Etag                       |    o     |      |
| File                       |    o     |      |
| Head                       |    o     |      |
| Lint                       |    o     |      |
| Logger                     |    o     |      |
| MediaType                  |    o     |      |
| MethodOverride             |    o     |      |
| Mime                       |    o     |      |
| Mock                       |    o     |      |
| Multipart                  |    o     |      |
| Multipart::Generator       |    o     |      |
| Multipart::Parser          |    o     |      |
| Multipart::UploadedFile    |    o     |      |
| NullLogger                 |    o     |      |
| QueryParser                |    o     |      |
| Rack                       |    o     |      |
| Recursive                  |    o     |      |
| Reloader                   |    o     |      |
| Request                    |    o     |      |
| Response                   |    o     |      |
| RewindableInput            |    o     |      |
| Runtime                    |    o     |      |
| Sendfile                   |    o     |      |
| Session::Abstract::Id      |    o     |      |
| ShowExceptions             |    o     |      |
| ShowStatus                 |    o     |      |
| Static                     |    o     |      |
| TempfileReaper             |    o     |      |
| URLMap                     |    o     |      |
| Utils                      |    o     |      |

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
