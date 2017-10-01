require "spec"
require "uri"
require "../util/readme"

readme = Readme.new

describe "List All Programming Telegram Group" do
  it "has references to awesomeness" do
    readme.refs(/t/).empty?.should be_false
  end

  it "has telegram references t" do
    readme.refs(/t/).each do |ref|
      uri = URI.parse(ref)
      uri.scheme.should eq "https"
      uri.host.should eq "t.me"
      uri.path.should_not be nil
    end
  end

  it "does not have duplicates" do
    prev = nil
    readme.refs(/t/).map do |ref|
      uri = URI.parse(ref)
      host = uri.host.as String
      path = uri.path.as String?
      "#{host.downcase}#{path.try &.downcase}"
    end.sort.each do |ref|
      ref.should_not eq prev
      prev = ref
    end
  end

  it "has alphabetical case insensitive order" do
    readme.groups.each do |group|
      sorted = group.sort { |x, y| x.downcase <=> y.downcase }
      group.each_with_index do |awesome, i|
        awesome.should eq sorted[i]
      end
    end
  end

  context "Document" do
    it "does not have trailing spaces" do
      File.read_lines(readme.path).each_with_index do |line, line_number|
        (line =~ /[ \t]+$/ && line_number + 1).should eq nil
      end
    end
  end
end
