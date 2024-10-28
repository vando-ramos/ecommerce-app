require 'rails_helper'

describe Warehouse, type: :model do
  context '.all' do
    it 'returns all warehouses' do
      json_data = File.read(Rails.root.join('spec/support/json/warehouses.json'))

      fake_response = double("faraday_response", status: 200, body: json_data)

      allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/warehouses').and_return(fake_response)


      warehouses = Warehouse.all


      expect(warehouses.length).to eq(3)
      expect(warehouses[0].name).to eq('Santos Dumont')
      expect(warehouses[0].code).to eq('SDU')
      expect(warehouses[1].name).to eq('Galeão')
      expect(warehouses[1].code).to eq('GIG')
      expect(warehouses[2].name).to eq('CDD Novo Rio')
      expect(warehouses[2].code).to eq('RIO')
    end

    it 'returns empty if the API is unavailable' do
      fake_response = double("faraday_resp", status: 500, body: "{ 'error': 'Unable to get data' }")

      allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/warehouses').and_return(fake_response)


      warehouses = Warehouse.all


      expect(warehouses).to eq []
    end
  end

  context '.find' do
    it 'returns a warehouse by id' do
      json_data = File.read(Rails.root.join('spec/support/json/warehouse.json'))

      fake_response = double("faraday_response", status: 200, body: json_data)

      allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/warehouses/4').and_return(fake_response)


      warehouse = Warehouse.find(4)


      expect(warehouse.name).to eq('Santos Dumont')
      expect(warehouse.code).to eq('SDU')
      expect(warehouse.city).to eq('Rio de Janeiro')
      expect(warehouse.area).to eq(3000000)
      expect(warehouse.address).to eq('Av Santos Dumont, 500')
      expect(warehouse.cep).to eq('12345-600')
      expect(warehouse.description).to eq('Cargas nacionais')
    end
  end
end
