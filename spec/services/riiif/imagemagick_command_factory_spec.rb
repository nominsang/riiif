require 'spec_helper'

RSpec.describe Riiif::ImagemagickCommandFactory do
  let(:tiff) { 'foo.tiff' }
  let(:pdf) { 'faa.pdf' }
  let(:info) { double(height: 100, width: 100, format: source) }

  describe '.command' do
    let(:transformation) do
      IIIF::Image::Transformation.new(region: IIIF::Image::Region::Full.new,
                                      size: IIIF::Image::Size::Full.new,
                                      quality: 'quality',
                                      rotation: 15.2,
                                      format: target)
    end

    context "when the target format is jpeg" do
      subject { described_class.new(tiff, info, transformation).command }

      let(:source) { 'tif' }
      let(:target) { 'jpg' }

      it { is_expected.to match(/-quality 85/) }
    end

    context "when the target format is tiff" do
      subject { described_class.new(tiff, info, transformation).command }

      let(:source) { 'tif' }
      let(:target) { 'tif' }

      it { is_expected.not_to match(/-quality/) }
    end

    context "when when the source format is pdf" do
      subject { described_class.new(pdf, info, transformation).command }
      let(:source) { 'pdf' }
      let(:target) { 'jpg' }

      it { is_expected.to match(/-alpha\ remove/) }
    end

    describe '#external_command' do
      subject { described_class.new(tiff, info, transformation).command }
      let(:source) { 'tif' }
      let(:target) { 'jpg' }

      around do |example|
        orig = described_class.external_command
        described_class.external_command = 'gm convert'

        example.run

        described_class.external_command = orig
      end

      it { is_expected.to match(/\Agm convert/) }
    end
  end
end
