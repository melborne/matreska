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
  end

  def call(env)
    res = @core.call(env)
    res + @arg
  end
end

describe Matryoshka do
  it 'should have a version number' do
    Matryoshka::VERSION.should_not be_nil
  end

  describe Matryoshka::Builder do
    before do
      @core = ->env{ env }
      @ma = Matryoshka::Builder.new(@core)
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

      it 'set doll objects with its args and a block' do
        expect{ @ma.set Plus, 2 }.not_to raise_error
      end
    end
  end
end
