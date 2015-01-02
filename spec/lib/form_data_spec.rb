# coding: utf-8

RSpec.describe FormData do
  describe ".create" do
    subject { FormData.create params }

    context "when form has no files" do
      let(:params) { { :foo => :bar } }
      it { is_expected.to be_a FormData::Urlencoded }
    end

    context "when form has at least one file param" do
      let(:gemspec) { FormData::File.new "gemspec" }
      let(:params)  { { :foo => :bar, :baz => gemspec } }
      it { is_expected.to be_a FormData::Multipart }
    end

    context "when form has file in an array param" do
      let(:gemspec) { FormData::File.new "gemspec" }
      let(:params)  { { :foo => :bar, :baz => [gemspec] } }
      it { is_expected.to be_a FormData::Multipart }
    end
  end

  describe ".ensure_hash" do
    subject(:ensure_hash) { FormData.ensure_hash data }

    context "when Hash given" do
      let(:data) { { :foo => :bar } }
      it { is_expected.to eq :foo => :bar }
    end

    context "when #to_h given" do
      let(:data) { double(:to_h => { :foo => :bar }) }
      it { is_expected.to eq :foo => :bar }
    end

    context "when nil given" do
      let(:data) { nil }
      it { is_expected.to eq({}) }
    end

    context "when neither Hash nor #to_h given" do
      let(:data) { double }
      it "fails with FormData::Error" do
        expect { ensure_hash }.to raise_error FormData::Error
      end
    end
  end
end
