# frozen_string_literal: true

describe TestCentricity::Video, required: true do
  subject(:css_video) { described_class.new(:test_video, self, 'video#css_video', :page) }

  it 'returns class' do
    expect(css_video.class).to eql TestCentricity::Video
  end

  it 'registers with type video' do
    expect(css_video.get_object_type).to eql :video
  end

  it 'returns autoplay' do
    allow(css_video).to receive(:autoplay?).and_return(false)
    expect(css_video.autoplay?).to eql false
  end

  it 'returns controls' do
    allow(css_video).to receive(:controls?).and_return(true)
    expect(css_video.controls?).to eql true
  end

  it 'returns ended' do
    allow(css_video).to receive(:ended?).and_return(true)
    expect(css_video.ended?).to eql true
  end

  it 'returns loop' do
    allow(css_video).to receive(:loop?).and_return(false)
    expect(css_video.loop?).to eql false
  end

  it 'returns muted' do
    allow(css_video).to receive(:muted?).and_return(false)
    expect(css_video.muted?).to eql false
  end

  it 'returns paused' do
    allow(css_video).to receive(:paused?).and_return(true)
    expect(css_video.paused?).to eql true
  end

  it 'returns seeking' do
    allow(css_video).to receive(:seeking?).and_return(false)
    expect(css_video.seeking?).to eql false
  end

  it 'should play the video' do
    expect(css_video).to receive(:play)
    css_video.play
  end

  it 'should pause the video' do
    expect(css_video).to receive(:pause)
    css_video.pause
  end

  it 'should mute the video' do
    expect(css_video).to receive(:mute)
    css_video.mute
  end

  it 'should unmute the video' do
    expect(css_video).to receive(:unmute)
    css_video.unmute
  end
end
