MRUBY_CONFIG=File.expand_path(ENV["MRUBY_CONFIG"] || "./build_config.rb")
RAKE="ruby ./minirake"
MRUBY_REVISION="1.4.1"

file :mruby do
  sh "git clone git://github.com/mruby/mruby.git"
end

task :default => :test

desc "test this mrbgem"
task :test => :mruby do
  sh "cd mruby && git checkout #{MRUBY_REVISION} && MRUBY_CONFIG=#{MRUBY_CONFIG} #{RAKE} test"
end

desc "build mruby with this mrbgem"
task :build => :mruby do
  sh "cd mruby && git checkout #{MRUBY_REVISION} && MRUBY_CONFIG=#{MRUBY_CONFIG} #{RAKE} all"
end

desc "cleanup"
task :clean do
  sh "cd mruby && rake deep_clean" if File.exist?("mruby")
end

desc "cleanup including temporary files"
task :realclean do
  sh "rm -rf mruby"
end
