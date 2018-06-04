MRuby::Gem::Specification.new('mruby-rack') do |spec|
  spec.license = 'MIT'
  spec.authors = 'Ichito Nagata'
  spec.summary = 'Rack'
  spec.version = '0.0.1'

  # order is important
  spec.rbfiles = [
    "#{dir}/mrblib/time.rb",
    "#{dir}/mrblib/rack/auth/abstract/handler.rb",
    "#{dir}/mrblib/rack/media_type.rb",
    "#{dir}/mrblib/rack/query_parser.rb",
    "#{dir}/mrblib/rack/utils.rb",
    "#{dir}/mrblib/rack/request.rb",
    "#{dir}/mrblib/rack/auth/abstract/request.rb",
    "#{dir}/mrblib/rack/auth/basic.rb",
    "#{dir}/mrblib/rack/auth/digest/nonce.rb",
    "#{dir}/mrblib/rack/auth/digest/params.rb",
    "#{dir}/mrblib/rack/auth/digest/request.rb",
    "#{dir}/mrblib/rack/auth/digest/md5.rb",
    "#{dir}/mrblib/rack/body_proxy.rb",
    "#{dir}/mrblib/rack.rb",
    "#{dir}/mrblib/rack/response.rb",
    "#{dir}/mrblib/rack/show_exceptions.rb",
    "#{dir}/mrblib/rack/builder.rb",
    "#{dir}/mrblib/rack/cascade.rb",
    "#{dir}/mrblib/rack/chunked.rb",
    "#{dir}/mrblib/rack/common_logger.rb",
    "#{dir}/mrblib/rack/conditional_get.rb",
    "#{dir}/mrblib/rack/config.rb",
    "#{dir}/mrblib/rack/content_length.rb",
    "#{dir}/mrblib/rack/content_type.rb",
    "#{dir}/mrblib/rack/mime.rb",
    "#{dir}/mrblib/rack/directory.rb",
    "#{dir}/mrblib/rack/etag.rb",
    "#{dir}/mrblib/rack/head.rb",
    "#{dir}/mrblib/rack/file.rb",
    "#{dir}/mrblib/rack/rewindable_input.rb",
    "#{dir}/mrblib/rack/lint.rb",
    "#{dir}/mrblib/rack/logger.rb",
    "#{dir}/mrblib/rack/method_override.rb",
    "#{dir}/mrblib/rack/mock.rb",
    "#{dir}/mrblib/rack/multipart/generator.rb",
    "#{dir}/mrblib/rack/multipart/parser.rb",
    "#{dir}/mrblib/rack/multipart/uploaded_file.rb",
    "#{dir}/mrblib/rack/multipart.rb",
    "#{dir}/mrblib/rack/null_logger.rb",
    "#{dir}/mrblib/rack/recursive.rb",
    "#{dir}/mrblib/rack/runtime.rb",
    "#{dir}/mrblib/rack/sendfile.rb",
    "#{dir}/mrblib/rack/session/abstract/id.rb",
    "#{dir}/mrblib/rack/show_status.rb",
    "#{dir}/mrblib/rack/static.rb",
    "#{dir}/mrblib/rack/tempfile_reaper.rb",
    "#{dir}/mrblib/rack/urlmap.rb",
  ]

  spec.add_dependency 'mruby-class-ext'
  spec.add_dependency 'mruby-enum-ext'
  spec.add_dependency 'mruby-eval'
  spec.add_dependency 'mruby-io'
  spec.add_dependency 'mruby-kernel-ext'
  spec.add_dependency 'mruby-method'
  spec.add_dependency 'mruby-numeric-ext'
  spec.add_dependency 'mruby-object-ext'
  spec.add_dependency 'mruby-string-ext'
  spec.add_dependency 'mruby-symbol-ext'
  spec.add_dependency 'mruby-time'

  spec.add_dependency 'mruby-onig-regexp'
  spec.add_dependency 'mruby-env'
  spec.add_dependency 'mruby-errno'
  spec.add_dependency 'mruby-set'
  spec.add_dependency 'mruby-secure-random'
  spec.add_dependency 'mruby-stringio'
  spec.add_dependency 'mruby-file-stat'
  spec.add_dependency 'mruby-digest'
  spec.add_dependency 'mruby-dir'
  spec.add_dependency 'mruby-struct'
  spec.add_dependency 'mruby-tempfile'
  spec.add_dependency 'mruby-time-strftime'
  spec.add_dependency 'mruby-uri', :github => 'zzak/mruby-uri'
  spec.add_dependency 'mruby-logger', :github => 'katzer/mruby-logger'

  spec.add_test_dependency 'mruby-catch-throw'
  spec.add_test_dependency 'mruby-sleep'

  spec.test_rbfiles = [
    "#{dir}/test/spec_auth_basic.rb",
    "#{dir}/test/spec_auth_digest.rb",
    "#{dir}/test/spec_body_proxy.rb",
    "#{dir}/test/spec_builder.rb",
    "#{dir}/test/spec_cascade.rb",
    "#{dir}/test/spec_chunked.rb",
    "#{dir}/test/spec_common_logger.rb",
    "#{dir}/test/spec_conditional_get.rb",
    "#{dir}/test/spec_config.rb",
    "#{dir}/test/spec_content_length.rb",
    "#{dir}/test/spec_content_type.rb",
    "#{dir}/test/spec_directory.rb",
    "#{dir}/test/spec_etag.rb",
    "#{dir}/test/spec_file.rb",
    "#{dir}/test/spec_head.rb",
    "#{dir}/test/spec_lint.rb",
    "#{dir}/test/spec_logger.rb",
    "#{dir}/test/spec_media_type.rb",
    "#{dir}/test/spec_method_override.rb",
    "#{dir}/test/spec_mime.rb",
    "#{dir}/test/spec_mock.rb",
    "#{dir}/test/spec_multipart.rb",
    "#{dir}/test/spec_null_logger.rb",
    "#{dir}/test/spec_recursive.rb",
    "#{dir}/test/spec_request.rb",
    "#{dir}/test/spec_response.rb",
    "#{dir}/test/spec_rewindable_input.rb",
    "#{dir}/test/spec_runtime.rb",
    "#{dir}/test/spec_sendfile.rb",
    "#{dir}/test/spec_session_abstract_id.rb",
    "#{dir}/test/spec_session_abstract_session_hash.rb",
    "#{dir}/test/spec_show_exceptions.rb",
    "#{dir}/test/spec_show_status.rb",
    "#{dir}/test/spec_static.rb",
    "#{dir}/test/spec_tempfile_reaper.rb",
    "#{dir}/test/spec_urlmap.rb",
    "#{dir}/test/spec_utils.rb",
    "#{dir}/test/spec_version.rb",
  ]
  spec.test_preload = "#{dir}/test/preload.rb"

end
