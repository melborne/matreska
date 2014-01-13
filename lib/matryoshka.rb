class Matryoshka
  attr_reader :figures
  def initialize(core)
    @figures = []
    @core = core
  end

  def set(*figures)
    figures.each { |fig| @figures << fig }
    self
  end

  def call(env=nil)
    build.call(env)
  end
  alias :[] :call

  def build
    @figures.inject(@core) { |core, fig| fig.new(core) }
  end
  private :build

  def clear
    @figures.clear
  end

  class << self
    def figure(name, *meth, &blk)
      if blk
        _figure(name, &blk)
      else
        _figure(name) do |res, env|
          res.send(*meth).tap { |r| p r }
        end
      end
    end
    alias :doll :figure

    private
    def _figure(name, &blk)
      klass = Class.new do
        def initialize(core)
          @core = core
        end
  
        define_method(:call) do |env|
          res = @core[env]
          blk[res, env]
        end
        alias :[] :call
      end
      Object.const_set(name.to_s, klass)
    end
  end
end

M8a = Matryoshka
