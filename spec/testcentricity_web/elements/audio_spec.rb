# frozen_string_literal: true

describe TestCentricity::Audio, required: true do
  subject(:css_audio) { described_class.new(:test_audio, self, 'audio#css_audio', :page) }

  it 'returns class' do
    expect(css_audio.class).to eql TestCentricity::Audio
  end

  it 'registers with type audio' do
    expect(css_audio.get_object_type).to eql :audio
  end

  it 'returns autoplay' do
    allow(css_audio).to receive(:autoplay?).and_return(false)
    expect(css_audio.autoplay?).to eql false
  end

  it 'returns controls' do
    allow(css_audio).to receive(:controls?).and_return(true)
    expect(css_audio.controls?).to eql true
  end

  it 'returns ended' do
    allow(css_audio).to receive(:ended?).and_return(true)
    expect(css_audio.ended?).to eql true
  end

  it 'returns loop' do
    allow(css_audio).to receive(:loop?).and_return(false)
    expect(css_audio.loop?).to eql false
  end

  it 'returns muted' do
    allow(css_audio).to receive(:muted?).and_return(false)
    expect(css_audio.muted?).to eql false
  end

  it 'returns paused' do
    allow(css_audio).to receive(:paused?).and_return(true)
    expect(css_audio.paused?).to eql true
  end

  it 'returns seeking' do
    allow(css_audio).to receive(:seeking?).and_return(false)
    expect(css_audio.seeking?).to eql false
  end

  it 'should play the audio' do
    expect(css_audio).to receive(:play)
    css_audio.play
  end

  it 'should pause the audio' do
    expect(css_audio).to receive(:pause)
    css_audio.pause
  end

  it 'should mute the audio' do
    expect(css_audio).to receive(:mute)
    css_audio.mute
  end

  it 'should unmute the audio' do
    expect(css_audio).to receive(:unmute)
    css_audio.unmute
  end
end
