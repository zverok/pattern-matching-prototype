RSpec.describe PatternMatchingPrototype::M do
  include PatternMatchingPrototype

  subject { ->(*els) { pattern === els } }

  context 'simple' do
    let(:pattern) { M(String, Numeric) }

    its_call('foo', 1) { is_expected.to ret true }
    its_call('foo') { is_expected.to ret false }
    its_call('foo', 1, 2) { is_expected.to ret false }
    its_call('foo', 'bar') { is_expected.to ret false }
  end

  context 'omission' do
    let(:pattern) { M(String, _, Numeric) }

    its_call('foo', 'bar', 1) { is_expected.to ret true }
    its_call('foo', 1, 2) { is_expected.to ret true }
    its_call('foo') { is_expected.to ret false }
    its_call('foo', 'bar', 'baz') { is_expected.to ret false }
  end

  context 'splat' do
    let(:pattern) { M(String, *Numeric) }

    its_call('foo', 1) { is_expected.to ret true }
    its_call('foo') { is_expected.to ret true }
    its_call('foo', 1, 2) { is_expected.to ret true }
    its_call('foo', 'bar') { is_expected.to ret false }
  end

  context 'nested' do
    let(:pattern) { M(String, M(Numeric, *Numeric), String) }

    its_call('foo', [1, 2], 'bar') { is_expected.to ret true }
    its_call('foo', 1, 2, 'bar') { is_expected.to ret false }
  end

  context 'binding' do
    it 'fails on undefined local vars' do
      expect {
        M(String => :a)
      }.to raise_error(ArgumentError, /requires variable to be defined/)
    end

    it 'binds local variable on match' do
      expect {
        a = nil
        M(String => :a) === ['test']
        a
      }.to ret 'test'
    end

    it 'does not bind on no match' do
      expect {
        a = nil
        M(String => :a) === [10]
        a
      }.to ret nil
    end
  end
end