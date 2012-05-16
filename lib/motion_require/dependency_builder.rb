require 'pathname'

module MotionRequire
  class DependencyBuilder
    def self.build(app, load_paths = ['app', 'vendor'])
      builder = new(app, load_paths)
      app.files_dependencies(builder.dependencies)
      app.files = [File.join(File.dirname(__FILE__), 'require.rb')] + builder.file_list
    end

    def initialize(app, load_paths)
      @app = app
      @load_paths = load_paths
      @dependencies = {}
      @file_list = []
      @resolved = false
    end

    def dependencies
      resolve
      @dependencies
    end

    def file_list
      resolve
      @file_list
    end

    private

    def resolve
      return if @resolved
      add_dependencies_for_file(find_file('app_delegate'))
      @resolved = true
    end

    def add_dependencies_for_file(file_name)
      return if @file_list.member?(file_name)

      deps = dependencies_for_file(file_name)

      @dependencies[file_name] = deps unless deps.empty?

      @file_list.unshift(file_name)

      deps.each do |file|
        add_dependencies_for_file(file)
      end
    end

    def find_file(file)
      @load_paths.each do |path|
        file_name = File.join(@app.project_dir, path, file + '.rb')
        return file_name if File.exist?(file_name)
      end
      raise LoadError.new("cannot load such file -- #{file}")
    end

    def dependencies_for_file(file_name)
      deps = []

      file = File.new(file_name, 'r')

      file.each_line do |line|
        if match = line.match(/^\s*require '([^']+)'\s*$/)
          deps << match[1]
        end
      end

      deps.map! {|file| find_file(file)}

      deps
    end
  end
end
