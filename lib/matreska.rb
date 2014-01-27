require "matreska/version"

module Matreska
  class Builder
    attr_reader :dolls
    def initialize(core)
      @dolls = []
      @core = core.respond_to?(:call) ? core : ->env{ core }
    end

    def set(doll, *args, &blk)
      @dolls << ->core{ doll.new(core, *args, &blk) }
      self
    end

    def call(env=nil)
      build.call(env)
    end
    alias :[] :call

    def build
      @dolls.inject(@core) { |core, doll| doll.call(core) }
    end
    private :build

    def clear
      @dolls.clear
    end
  end

  class << self
    def build(core)
      Builder.new(core)
    end

    def doll(name, *meth, &blk)
      if blk
        build_doll(name, &blk)
      else
        build_doll(name) do |core|
          core.send(*meth)
        end
      end
    end
    alias :figure :doll

    private
    def build_doll(name, &blk)
      klass = Class.new do
        def initialize(core, *args, &blk)
          @core = core
          @args = args
          @blk = blk
        end

        define_method(:call) do |env|
          core = @core.call(env)
          blk.call(core, *@args, &@blk)
        end
        alias :[] :call
      end
      Object.const_set(name.to_s, klass)
    end
  end
end

M6a = Matreska
