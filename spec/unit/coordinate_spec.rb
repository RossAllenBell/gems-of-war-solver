require 'spec_helper'

describe Coordinate do

  let(:coordinate_0_0){Coordinate.new(x: 0, y: 0)}
  let(:coordinate_1_0){Coordinate.new(x: 1, y: 0)}
  let(:coordinate_0_1){Coordinate.new(x: 0, y: 1)}

  describe :distance_from do

    it 'can determine distance' do
      expect(coordinate_0_0.distance_from(coordinate:coordinate_0_0)).to eq(0)
    end

    it 'can determine distance' do
      expect(coordinate_0_0.distance_from(coordinate:coordinate_1_0)).to eq(1)
    end

    it 'can determine distance' do
      expect(coordinate_0_0.distance_from(coordinate:coordinate_0_1)).to eq(1)
    end

    it 'can determine distance' do
      expect(coordinate_1_0.distance_from(coordinate:coordinate_0_1)).to be > 1
    end

  end

  describe :cardinal_steps do

    it 'can produce cardinal steps' do
      expect(coordinate_0_0.cardinal_steps.sort).to eql([
        Coordinate.new(x: 0, y: -1),
        Coordinate.new(x: 1, y: 0),
        Coordinate.new(x: 0, y: 1),
        Coordinate.new(x: -1, y: 0),
      ].sort)
    end

  end

  describe :== do

    it 'can ==' do
      expect(coordinate_0_0 == coordinate_0_0).to eql(true)
    end

    it 'can ==' do
      expect(coordinate_0_0 == Coordinate.new(x: 0, y: 0)).to eql(true)
    end

    it 'can ==' do
      expect(coordinate_0_0 == coordinate_0_1).to eql(false)
    end

  end

  describe '<=>' do

    it 'can <=>' do
      expect(coordinate_0_0 <=> coordinate_0_0).to eql(0)
    end

    it 'can <=>' do
      expect(coordinate_0_0 <=> coordinate_0_1).to be < 0
    end

  end

  describe :+ do

    it 'can +' do
      expect(coordinate_0_0 + coordinate_0_0).to eql(coordinate_0_0)
    end

    it 'can +' do
      expect(coordinate_0_0 + coordinate_0_1).to eql(coordinate_0_1)
    end

  end

  describe :- do

    it 'can -' do
      expect(coordinate_0_0 - coordinate_0_0).to eql(coordinate_0_0)
    end

    it 'can -' do
      expect(coordinate_0_0 - coordinate_0_1).to eql(Coordinate.new(x: 0, y: -1))
    end

  end

end
