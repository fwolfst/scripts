load './access_log_date'

require 'rspec'

describe '#target_file' do
  it 'appends part if not file ext. or number' do
    expect(target_file("a","1_2")).to eql "a.1_2"
  end
  it 'replaces number with part' do
    expect(target_file("apache.log.7","1_2")).to eql "apache.log.1_2"
  end
  it 'replaces number with part (and extension)' do
    expect(target_file("apache.log.7.gz","1_2")).to eql "apache.log.1_2.gz"
  end
  it 'replaces number with part (and extension), keeps the path' do
    expect(target_file("../../dir/apache.log.7.gz","1_2")).to eql "../../dir/apache.log.1_2.gz"
  end
  it 'places number before file extension' do
    expect(target_file("apache.log","1_2")).to eql "apache.1_2.log"
  end
  it 'can correct previous behaviour ;) ' do
    expect(target_file("../../dir/apache.log._123-412-4_27.gz","1_2")).to eql "../../dir/apache.log.1_2.gz"
  end
end
