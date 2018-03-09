#!/bin/sh
set -e
git checkout upstream/master
git submodule foreach git pull origin master

cat << EOF | xargs -I{} cp upstream/lib/{} mrblib/{}
rack/auth/abstract/handler.rb
rack/auth/abstract/request.rb
rack/auth/basic.rb
rack/auth/digest/md5.rb
rack/auth/digest/nonce.rb
rack/auth/digest/params.rb
rack/auth/digest/request.rb
rack/body_proxy.rb
rack/builder.rb
rack/cascade.rb
rack/chunked.rb
rack/common_logger.rb
rack/conditional_get.rb
rack/config.rb
rack/content_length.rb
rack/content_type.rb
rack/deflater.rb
rack/directory.rb
rack/etag.rb
rack/events.rb
rack/file.rb
rack/handler/cgi.rb
rack/handler/fastcgi.rb
rack/handler/lsws.rb
rack/handler/scgi.rb
rack/handler/thin.rb
rack/handler/webrick.rb
rack/handler.rb
rack/head.rb
rack/lint.rb
rack/lobster.rb
rack/lock.rb
rack/logger.rb
rack/media_type.rb
rack/method_override.rb
rack/mime.rb
rack/mock.rb
rack/multipart/generator.rb
rack/multipart/parser.rb
rack/multipart/uploaded_file.rb
rack/multipart.rb
rack/null_logger.rb
rack/query_parser.rb
rack/recursive.rb
rack/reloader.rb
rack/request.rb
rack/response.rb
rack/rewindable_input.rb
rack/runtime.rb
rack/sendfile.rb
rack/server.rb
rack/session/abstract/id.rb
rack/session/cookie.rb
rack/session/memcache.rb
rack/session/pool.rb
rack/show_exceptions.rb
rack/show_status.rb
rack/static.rb
rack/tempfile_reaper.rb
rack/urlmap.rb
rack/utils.rb
rack.rb
EOF

if [ -z "$(git diff mrblib)" ]; then
  git submodule update
  git checkout master
  exit 0
fi

git add upstream
git add mrblib
REV=$(cd upstream && git rev-parse --short HEAD)
if [ -z "$REV" ]; then
  echo "failed to get upstream revision"
  exit 1
fi
git commit -m "import upstream at ${REV}"

git checkout master
git merge upstream
