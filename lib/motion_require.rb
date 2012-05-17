require "motion_require/version"
require "motion_require/dependency_builder"

begin
  require "motion/project"
rescue LoadError => e
end

if defined?(Motion::Project::App)
  Motion::Project::App.singleton_class.class_eval do

    alias_method :setup_without_require, :setup

    def setup(&block)
      configs.each_value { |x| MotionRequire::DependencyBuilder.build(x) }
      setup_without_require(&block)
    end

  end
else
  puts " ================= WARNING ================= "
  puts "  motion_require only works with RubyMotion  "
end
