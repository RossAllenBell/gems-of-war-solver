require 'spec_helper'

describe Screen do

  let(:rmagick_image){Magick::ImageList.new(screenshot_filename)}
  let(:screen){Screen.new(rmagick_image: rmagick_image)}

  it 'can take a cached set of grid boundaries'

  context 'using screenshot 001' do

    let(:screenshot_filename){'screenshots/001.png'}

    it 'can detect top edge of gem grid' do
      expect(screen.gem_grid_top_y).to eql(80)
    end

    it 'can detect bottom edge of gem grid' do
      expect(screen.gem_grid_bottom_y).to eql(1031)
    end

    it 'can detect left edge of gem grid' do
      expect(screen.gem_grid_left_x).to eql(634)
    end

    it 'can detect right edge of gem grid' do
      expect(screen.gem_grid_right_x).to eql(1585)
    end

    it 'can identify the gem offset' do
      expect(screen.gem_offset_x).to eql(118)
    end

    it 'can identify a gem as blue' do
      expect(screen.gem_at(x: 0, y: 0).color).to eql(ScreenGem::Colors::Blue)
    end

    it 'can identify a gem as brown' do
      expect(screen.gem_at(x: 1, y: 1).color).to eql(ScreenGem::Colors::Brown)
    end

    it 'can identify a gem as green' do
      expect(screen.gem_at(x: 0, y: 2).color).to eql(ScreenGem::Colors::Green)
    end

    it 'can identify a gem as purple' do
      expect(screen.gem_at(x: 2, y: 0).color).to eql(ScreenGem::Colors::Purple)
    end

    it 'can identify a gem as red' do
      expect(screen.gem_at(x: 3, y: 0).color).to eql(ScreenGem::Colors::Red)
    end

    it 'can identify a gem as yellow' do
      expect(screen.gem_at(x: 1, y: 2).color).to eql(ScreenGem::Colors::Yellow)
    end

    it 'can identify a gem as skull' do
      expect(screen.gem_at(x: 0, y: 1).color).to eql(ScreenGem::Colors::Skull)
    end

    it 'can identify a gem as exploding skull' do
      expect(screen.gem_at(x: 4, y: 2).color).to eql(ScreenGem::Colors::ExplodingSkull)
    end

  end

  context 'using screenshot 002' do

    let(:screenshot_filename){'screenshots/002.png'}

    it 'can identify a gem as an unmatchable space' do
      expect(screen.gem_at(x: 0, y: 3).color).to eql(ScreenGem::Colors::Unmatchable)
    end

  end

end
