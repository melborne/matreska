require 'spec_helper'

class PlusOne
  def initialize(core)
    @core = core
  end

  def call(env)
    res = @core.call(env)
    res + 1
  end
end

class Plus
  def initialize(core, arg, &blk)
    @core = core
    @arg = arg
    @blk = blk
  end

  def call(env)
    res = @core.call(env)
    if @blk
      @blk.call(res, @arg)
    else
      res + @arg
    end
  end
end

describe Matreska do
  it 'should have a version number' do
    Matreska::VERSION.should_not be_nil
  end
end

describe Matreska::Builder do
  before do
    @core = ->env{ env }
    @ma = Matreska::Builder.new(@core)
  end

  describe "#new" do
    it 'takes a core object which has call method' do
      expect(@ma.instance_variable_get "@core").to eq @core
    end
  end

  describe "#call" do
    it 'execute call method of core object' do
      expect(@ma.call(1)).to eq 1
    end

    it 'execute call of core and dolls' do
      @ma.set PlusOne
      expect(@ma.call(1)).to eq 2
    end

    it 'execute call of core and dolls with its arguments' do
      @ma.set Plus, 2
      expect(@ma.call(1)).to eq 3
    end
  end

  describe "#set" do
    it 'sets doll objects which takes a core or doll and has call method' do
      @ma.set PlusOne
      dolls = @ma.dolls
      expect(dolls.size).to eq 1
      expect(dolls.first).to respond_to(:call)
    end

    it 'can receive an argument' do
      expect{ @ma.set Plus, 2 }.not_to raise_error
      expect(@ma.call(1)).to eq 3
    end

    it 'can receive a block' do
      expect{
        @ma.set Plus, 3 do |core, arg|
          core - arg
        end
      }.not_to raise_error
      expect(@ma.call(5)).to eq 2
    end
  end

  describe ".doll" do
    context 'with a method' do
      it 'creates doll class which execute the method' do
        Matreska.doll(:Rev, :reverse)
        @ma.set Rev
        expect(@ma.call("olleh")).to eq "hello"
      end

      it 'creates doll class which execute the method with an argument' do
        Matreska.doll(:MulByTwo, :*, 2)
        @ma.set MulByTwo
        expect(@ma.call(3)).to eq 6
      end
    end

    context 'with a block' do
      it 'creates doll class which execute the block' do
        Matreska.doll(:RevUp) { |core| core.reverse.upcase }
        @ma.set RevUp
        expect(@ma.call("olleh")).to eq "HELLO"
      end
    end
  end

  describe ".build" do
    it 'calls Builder.new' do
      expect(Matreska.build(->env{ env })).to be_instance_of Matreska::Builder
    end
  end
end
