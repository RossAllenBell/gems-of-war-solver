require 'spec_helper'

describe Screen do

  let(:rmagick_image){Magick::ImageList.new(screenshot_filename)}
  let(:screen){Screen.new(rmagick_image: rmagick_image)}

  context 'using screenshot 001' do

    let(:screenshot_filename){'screenshots/001.png'}

    it 'can detect top edge of gem grid' do
      expect(screen.gem_grid_top_y).to be_within(3).of(80)
    end

    it 'can detect bottom edge of gem grid' do
      expect(screen.gem_grid_bottom_y).to be_within(3).of(1031)
    end

    it 'can detect left edge of gem grid' do
      expect(screen.gem_grid_left_x).to be_within(3).of(634)
    end

    it 'can detect right edge of gem grid' do
      expect(screen.gem_grid_right_x).to be_within(3).of(1585)
    end

    it 'can identify the gem offset' do
      expect(screen.gem_offset_x).to be_within(3).of(118)
    end

    context 'cached gem grid boundaries' do

      let(:gem_grid_top_y){80}
      let(:gem_grid_bottom_y){1031}
      let(:gem_grid_left_x){634}
      let(:gem_grid_right_x){1585}

      before(:each) do
        screen.cached_gem_grid_top_y = gem_grid_top_y
        screen.cached_gem_grid_bottom_y = gem_grid_bottom_y
        screen.cached_gem_grid_left_x = gem_grid_left_x
        screen.cached_gem_grid_right_x = gem_grid_right_x
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

  end

  context 'using screenshot 002' do

    let(:screenshot_filename){'screenshots/002.png'}

    it 'can identify a gem as an unmatchable space' do
      expect(screen.gem_at(x: 0, y: 3).color).to eql(ScreenGem::Colors::Unmatchable)
    end

  end

  context 'using screenshot 004' do

    let(:screenshot_filename){'screenshots/004_reflector_fill_screen_quality.png'}

    let(:gem_grid_top_y){209}
    let(:gem_grid_right_x){2926}
    let(:gem_grid_bottom_y){1966}
    let(:gem_grid_left_x){1172}

    before(:each) do
      screen.cached_gem_grid_top_y = gem_grid_top_y
      screen.cached_gem_grid_bottom_y = gem_grid_bottom_y
      screen.cached_gem_grid_left_x = gem_grid_left_x
      screen.cached_gem_grid_right_x = gem_grid_right_x
    end

    it 'can identify a gem as blue' do
      expect(screen.gem_at(x: 5, y: 0).color).to eql(ScreenGem::Colors::Blue)
    end

    it 'can identify a gem as brown' do
      expect(screen.gem_at(x: 1, y: 0).color).to eql(ScreenGem::Colors::Brown)
    end

    it 'can identify a gem as green' do
      expect(screen.gem_at(x: 7, y: 0).color).to eql(ScreenGem::Colors::Green)
    end

    it 'can identify a gem as purple' do
      expect(screen.gem_at(x: 1, y: 1).color).to eql(ScreenGem::Colors::Purple)
    end

    it 'can identify a gem as red' do
      expect(screen.gem_at(x: 3, y: 0).color).to eql(ScreenGem::Colors::Red)
    end

    it 'can identify a gem as yellow' do
      expect(screen.gem_at(x: 2, y: 0).color).to eql(ScreenGem::Colors::Yellow)
    end

    it 'can identify a gem as skull' do
      expect(screen.gem_at(x: 0, y: 0).color).to eql(ScreenGem::Colors::Skull)
    end

    it 'can identify a gem as exploding skull' do
      expect(screen.gem_at(x: 0, y: 3).color).to eql(ScreenGem::Colors::ExplodingSkull)
    end

  end

  context 'using screenshot 005' do

    let(:screenshot_filename){'screenshots/005_reflector_default_quality.png'}

    let(:gem_grid_top_y){112}
    let(:gem_grid_right_x){1029}
    let(:gem_grid_bottom_y){729}
    let(:gem_grid_left_x){411}

    before(:each) do
      screen.cached_gem_grid_top_y = gem_grid_top_y
      screen.cached_gem_grid_bottom_y = gem_grid_bottom_y
      screen.cached_gem_grid_left_x = gem_grid_left_x
      screen.cached_gem_grid_right_x = gem_grid_right_x
    end

    it 'can identify a gem as blue' do
      expect(screen.gem_at(x: 2, y: 1).color).to eql(ScreenGem::Colors::Blue)
    end

    it 'can identify a gem as brown' do
      expect(screen.gem_at(x: 0, y: 0).color).to eql(ScreenGem::Colors::Brown)
    end

    it 'can identify a gem as green' do
      expect(screen.gem_at(x: 1, y: 1).color).to eql(ScreenGem::Colors::Green)
    end

    it 'can identify a gem as purple' do
      expect(screen.gem_at(x: 1, y: 0).color).to eql(ScreenGem::Colors::Purple)
    end

    it 'can identify a gem as red' do
      expect(screen.gem_at(x: 0, y: 1).color).to eql(ScreenGem::Colors::Red)
    end

    it 'can identify a gem as yellow' do
      expect(screen.gem_at(x: 0, y: 2).color).to eql(ScreenGem::Colors::Yellow)
    end

    it 'can identify a gem as skull' do
      expect(screen.gem_at(x: 0, y: 6).color).to eql(ScreenGem::Colors::Skull)
    end

  end

  context 'using screenshot 006' do

    let(:screenshot_filename){'screenshots/006_reflector_best_for_retina_quality.png'}

    let(:gem_grid_top_y){87}
    let(:gem_grid_right_x){515}
    let(:gem_grid_bottom_y){388}
    let(:gem_grid_left_x){206}

    before(:each) do
      screen.cached_gem_grid_top_y = gem_grid_top_y
      screen.cached_gem_grid_bottom_y = gem_grid_bottom_y
      screen.cached_gem_grid_left_x = gem_grid_left_x
      screen.cached_gem_grid_right_x = gem_grid_right_x
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 0, y: 0).color).to eql(ScreenGem::Colors::Brown)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 1, y: 0).color).to eql(ScreenGem::Colors::Purple)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 2, y: 0).color).to eql(ScreenGem::Colors::Purple)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 3, y: 0).color).to eql(ScreenGem::Colors::Red)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 4, y: 0).color).to eql(ScreenGem::Colors::Brown)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 5, y: 0).color).to eql(ScreenGem::Colors::Purple)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 6, y: 0).color).to eql(ScreenGem::Colors::Skull)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 7, y: 0).color).to eql(ScreenGem::Colors::Brown)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 0, y: 1).color).to eql(ScreenGem::Colors::Red)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 0, y: 2).color).to eql(ScreenGem::Colors::Yellow)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 0, y: 3).color).to eql(ScreenGem::Colors::Yellow)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 0, y: 4).color).to eql(ScreenGem::Colors::Blue)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 0, y: 5).color).to eql(ScreenGem::Colors::Brown)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 0, y: 6).color).to eql(ScreenGem::Colors::Skull)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 0, y: 7).color).to eql(ScreenGem::Colors::Yellow)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 1, y: 1).color).to eql(ScreenGem::Colors::Green)
    end

  end

  context 'using screenshot 007' do

    let(:screenshot_filename){'screenshots/007_reflector_best_for_retina_quality.png'}

    let(:gem_grid_top_y){107}
    let(:gem_grid_right_x){914}
    let(:gem_grid_bottom_y){655}
    let(:gem_grid_left_x){367}

    before(:each) do
      screen.cached_gem_grid_top_y = gem_grid_top_y
      screen.cached_gem_grid_bottom_y = gem_grid_bottom_y
      screen.cached_gem_grid_left_x = gem_grid_left_x
      screen.cached_gem_grid_right_x = gem_grid_right_x
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 0, y: 0).color).to eql(ScreenGem::Colors::Brown)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 1, y: 0).color).to eql(ScreenGem::Colors::Yellow)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 2, y: 0).color).to eql(ScreenGem::Colors::Red)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 3, y: 0).color).to eql(ScreenGem::Colors::Skull)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 4, y: 0).color).to eql(ScreenGem::Colors::Skull)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 5, y: 0).color).to eql(ScreenGem::Colors::Red)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 6, y: 0).color).to eql(ScreenGem::Colors::Blue)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 7, y: 0).color).to eql(ScreenGem::Colors::Purple)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 0, y: 1).color).to eql(ScreenGem::Colors::Yellow)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 0, y: 2).color).to eql(ScreenGem::Colors::Yellow)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 0, y: 3).color).to eql(ScreenGem::Colors::Red)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 0, y: 4).color).to eql(ScreenGem::Colors::Green)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 0, y: 5).color).to eql(ScreenGem::Colors::Purple)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 0, y: 6).color).to eql(ScreenGem::Colors::Green)
    end

    it 'can identify a gem' do
      expect(screen.gem_at(x: 0, y: 7).color).to eql(ScreenGem::Colors::Yellow)
    end

  end

end
