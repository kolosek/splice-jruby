require 'benchmark'

RUN_CIRCLE = 100

describe 'Performance', performance: true do

  it 'create' do
    Benchmark.bm do |x|
      x.report("create:")   { RUN_CIRCLE.times { Company.create(name: 'Company Name') } }
    end
  end

  describe 'Update action' do
    let!(:company) { create :company }

    it 'update' do
      Benchmark.bm do |x|
        x.report("update:")   { RUN_CIRCLE.times { company.update(name: 'Company Name') } }
      end
    end
  end
end