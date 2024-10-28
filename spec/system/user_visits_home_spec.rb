require 'rails_helper'

describe 'User visits homepage' do
  it "and sees the registered warehouses" do
    warehouses = []
    warehouses << Warehouse.new(id: 1, name: 'Galeão', code: 'GIG', city: 'Rio de Janeiro', area: '7_000_000',
                                address: 'Estrada do Galeão, 1000 - Ilha', cep: '12345-000', description: 'Cargas internacionais')

    warehouses << Warehouse.new(id: 2, name: 'Santos Dumont', code: 'SDU', city: 'Rio de Janeiro', area: '3_000_000',
                                address: 'Av da Praia, 500 - Centro', cep: '98345-000', description: 'Cargas nacionais')

    allow(Warehouse).to receive(:all).and_return(warehouses)


    visit(root_path)


    expect(page).to have_content('Ecommerce-App')
    expect(page).not_to have_content('No warehouses found')
    expect(page).to have_content('Galeão')
    expect(page).to have_content('Santos Dumont')
  end

  it 'and there are no warehouses' do
    fake_response = double("faraday_response", status: 200, body: "[]")

    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/warehouses').and_return(fake_response)


    visit(root_path)


    expect(page).to have_content('No warehouses found')
  end

  it 'and sees the details of a warehouse' do
    json_data = File.read(Rails.root.join('spec/support/json/warehouses.json'))

    fake_response = double("faraday_response", status: 200, body: json_data)

    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/warehouses').and_return(fake_response)

    json_data = File.read(Rails.root.join('spec/support/json/warehouse.json'))

    fake_response = double("faraday_response", status: 200, body: json_data)

    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/warehouses/4').and_return(fake_response)


    visit(root_path)
    click_on('Santos Dumont')


    expect(page).to have_content('Santos Dumont SDU')
    expect(page).to have_content('Rio de Janeiro')
    expect(page).to have_content('3000000')
    expect(page).to have_content('Av Santos Dumont, 500 - CEP: 12345-600')
    expect(page).to have_content('Cargas nacionais')
  end

  it 'and unable to load the warehouse' do
    json_data = File.read(Rails.root.join('spec/support/json/warehouses.json'))

    fake_response = double("faraday_response", status: 200, body: json_data)

    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/warehouses').and_return(fake_response)

    error_response = double("faraday_response", status: 500, body: "{}")

    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/warehouses/4').and_return(error_response)


    visit(root_path)
    click_on('Santos Dumont')


    expect(page).to have_content('Unable to load the warehouse')
    expect(current_path).to eq(root_path)
  end
end
