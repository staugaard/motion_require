require 'pathname'

module MotionRequire
  class DependencyBuilder
    def self.build(app, load_paths = ['app', 'vendor'])
      builder = new(app, load_paths)
      app.files = [File.join(File.dirname(__FILE__), 'require.rb')] + builder.file_list
      # app.files_dependencies(builder.dependencies)
    end

    def initialize(app, load_paths)
      @app = app
      @load_paths = load_paths.map { |path| File.join(@app.project_dir, path) }
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
      app_delegate = find_file('app_delegate')

      add_dependencies_for_file(app_delegate)

      @file_list = load_order_for(app_delegate)

      @resolved = true
    end

    def load_order_for(file_name)
      deps = @dependencies[file_name]

      if deps && !deps.empty?
        deps.inject([file_name]) do |memo, dep_file_name|
          if memo.include?(dep_file_name)
            memo
          else
            load_order_for(dep_file_name) + memo
          end
        end
      else
        [file_name]
      end
    end

    def add_dependencies_for_file(file_name)
      deps = dependencies_for_file(file_name)

      @dependencies[file_name] = deps unless deps.empty?

      deps.each do |file|
        add_dependencies_for_file(file)
      end
    end

    def find_file(file)
      (@load_paths + $:).each do |path|
        file_name = File.join(path, file + '.rb')
        return file_name if File.exist?(file_name)
      end

      raise LoadError.new("cannot load such file -- #{file}")
    end

    def dependencies_for_file(file_name)
      deps = []

      file = File.new(file_name, 'r')

      file.each_line do |line|
        if match = line.match(/^\s*require ([\"'])([^']+)\1\s*$/)
          deps << match[2]
        end
      end

      deps.map! {|file| find_file(file)}

      deps
    end
  end
end
