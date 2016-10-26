RSpec.shared_examples 'model create' do
  it 'is created' do
    expect{ create(model) }.to change(model, :count).by(1)
  end
end

RSpec.shared_examples 'model update' do |field, value|
  before { item.update field => value }

  it 'is updated' do
    expect(item.reload.send(field)).to eq value
  end
end

RSpec.shared_examples 'model readonly update' do |field, value|
  before { item.update field => value }

  it 'is not updated' do
    expect(item.reload.send(field)).not_to eq value
  end
end

RSpec.shared_examples 'model destroy' do
  before { item.save }

  it 'is destroyed' do
    expect{ item.destroy }.to change(model, :count).by(-1)
  end
end



RSpec.shared_examples 'model validation' do |*fields|
  let(:new_item) { model.new }

  it 'is not created if it is not valid' do
    expect(new_item).to_not be_valid
    fields.each do |field|
      expect(new_item.errors[field].any?).to be_truthy
    end
  end
end


RSpec.shared_examples 'belongs_to association' do |model_associated, required = false|
  let (:item) { create model }
  let (:item_associated) { create model_associated }
  let (:model_association) { model_associated.to_s.downcase }

  it "adds #{model_associated}" do
    item.send("#{model_association}=", item_associated)
    item.save
    expect(item.reload.send(model_association)).to eq item_associated
  end

  if required
    it "does not remove #{model_associated}" do
      item.send("#{model_association}=", item_associated)
      item.save
      item.send("#{model_association}=", nil)
      expect(item).to_not be_valid
    end
  end
end

RSpec.shared_examples 'has_one association' do |model_associated, required = false|
  let (:item) { create model }
  let (:item_associated) { create model_associated }
  let (:model_association) { model_associated.to_s.downcase }

  before do
    item.send("#{model_association}=", item_associated)
    item.save
  end

  it "adds #{model_associated}" do
    expect(item.reload.send(model_association)).to eq item_associated
  end

  if required
    it "does not remove #{model_associated}" do
      item.send("#{model_association}=", nil)
      expect(item).to_not be_valid
    end
  end
end

RSpec.shared_examples 'has_many association' do |model_associated, required = false|
  let (:item) { create model }
  let (:item_associated) { create model_associated }
  let (:model_association) { model_associated.model_name.plural }

  before do
    item.send(model_association) << item_associated
  end

  it "adds #{model_associated}" do
    if required
      expect(item.send(model_association).count).to eq 2
    else
      expect(item.send(model_association).count).to eq 1
    end
    expect(item.send(model_association).last).to eq item_associated
  end

  it "removes #{model_associated}" do
    item.send(model_association).delete(item_associated)
    if required
      expect(item.send(model_association).count).to eq 1
      expect(item.send(model_association).first).to_not be_nil
    else
      expect(item.send(model_association).count).to eq 0
      expect(item.send(model_association).first).to be_nil
    end
  end

  it "destroys dependent #{model_associated}" do
    item.destroy
    expect(item.send(model_association).count).to eq 0
    expect(item.send(model_association).first).to be_nil
  end
end

RSpec.shared_examples 'habtm association' do |model_associated, required = false|
  let (:item) { create model }
  let (:item_associated) { create model_associated }
  let (:model_association) { model_associated.model_name.plural }

  it "adds #{model_associated}" do
    item.send(model_association) << item_associated
    if required
      expect(item.send(model_association).count).to eq 2
    else
      expect(item.send(model_association).count).to eq 1
    end
    expect(item.send(model_association).last).to eq item_associated
  end

  it "creates #{model_associated}" do
    item.send(model_association).send(:create, item_associated.attributes.except('id', 'created_at', 'updated_at'))
    expect(item.send(model_association).count).to eq 1
  end

  it "removes #{model_associated}" do
    item.send(model_association) << item_associated
    item.send(model_association).delete(item_associated)
    if required
      expect(item.send(model_association).count).to eq 1
      expect(item.send(model_association).first).to_not be_nil
    else
      expect(item.send(model_association).count).to eq 0
      expect(item.send(model_association).first).to be_nil
    end
  end
end

RSpec.shared_examples 'has_many through association' do |model_associated, model_through|
  let (:item) { create model }
  let (:base_model_association) { model.to_s.downcase }
  let (:model_association) { model_associated.to_s.downcase }
  let (:model_association_pl) { model_associated.model_name.plural  }
  let (:model_through_association) { model_through.to_s.downcase }
  let (:model_through_association_pl) { model_through.model_name.plural }

  let! (:item_through) { create model_through, base_model_association => item }
  let! (:item_associated) { create model_associated, model_through_association => item_through}

  it "creates #{model_associated}" do
    expect(item.send(model_association_pl).count).to eq 1
  end

  it "deletes #{model_associated}" do
    item.send(model_through_association_pl).send(:destroy_all)
    expect(item.send(model_association_pl).count).to eq 0
  end

end


RSpec.shared_examples 'polymorphic association' do |model_association, *models_associated|
  let (:item) { create model }

  models_associated.each do |model_associated|
    it "has an association with #{model_associated}" do
      item_associated = create model_associated
      item.send "#{model_association}=", item_associated
      expect(item.send(model_association)).to be_an(model_associated)
    end
  end
end

RSpec.shared_examples 'join and include query' do |model_associated|
  let (:item) { create model }
  let (:item_associated) { create model_associated }
  let (:model_association) { model_associated.model_name.plural }

  before do
    item.send(model_association) << item_associated
  end

  it ".joins #{model_associated}" do
    item_relation = model.send(:where, {id: item.id})
    item_relation.joins(model_association.downcase.to_sym).each do |item_object|
      expect(item_object.send(model_association).count).to eq 1
    end
  end

  it ".includes #{model_associated}" do
    model.send(:where, {id: item.id}).includes(model_association.downcase.to_sym).each do |item_object|
     expect(item_object.send(model_association).count).to eq 1
    end
  end
end

RSpec.shared_examples 'pessimistic locking' do
  let (:item) { create model }

  it 'locks table row' do
    ActiveRecord::Base.transaction do
      locked_item = model.find(item.id).lock!
      expect(locked_item.update_attributes({})).to eq true
    end
  end
end



RSpec.shared_examples 'selector' do |scope_action, options = {}|
  describe ".#{scope_action}" do
    let!(:item_1) { create model, options }
    let!(:item_2) { create model, options }

    it 'returns items' do
      return_array = case scope_action
      when :all_records
        [item_1, item_2]
      when :ordered
        [item_2, item_1]
      when :reverse_ordered
        [item_1, item_2]
      when :limited
        [item_1]
      when :selected
        [item_1, item_2]
      when :grouped
        item_1.update(name: item_2.name)
        [item_1]
      when :having_grouped
        [item_1, item_2]
      when :offsetted
        [item_2]
      end

      expect(model.send(scope_action)).to eq return_array
    end
  end
end

RSpec.shared_examples 'find selector' do
  let!(:item_1) { create model }
  let!(:item_2) { create model }

  describe ".find" do
    it 'returns item' do
      expect(model.send(:find, item_2.id)).to eq item_2
    end
  end

  describe ".find array" do
    it 'returns items' do
      expect(model.send(:find, [item_1.id, item_2.id])).to eq [item_1, item_2]
    end
  end

  describe ".find_in_batches" do
    it 'returns all items' do
      model.send(:find_in_batches) do |batch|
        expect(batch).to eq [item_1, item_2]
      end
    end
  end
end


RSpec.shared_examples 'having selector' do
  let!(:item_1) { create model }
  let!(:item_2) { create model }

  describe ".find" do
    it 'returns item' do
      expect(model.send(:find, item_2.id)).to eq item_2
    end
  end

  describe ".find array" do
    it 'returns items' do
      expect(model.send(:find, [item_1.id, item_2.id])).to eq [item_1, item_2]
    end
  end

  describe ".find_in_batches" do
    it 'returns all items' do
      model.send(:find_in_batches) do |batch|
        expect(batch).to eq [item_1, item_2]
      end
    end
  end
end

