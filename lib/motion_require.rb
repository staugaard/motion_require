require "motion_require/version"
require "motion_require/dependency_builder"

Motion::Project::App.singleton_class.class_eval do

  alias_method :setup_without_require, :setup

  def setup(&block)
    configs.each_value { |x| MotionRequire::DependencyBuilder.build(x) }
    setup_without_require(&block)
  end

end
