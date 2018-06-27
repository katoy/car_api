# coding: utf-8
require 'acceptance_helper'      # We require acceptance specs configuration from spec/acceptance_helper.rb.

resource 'Cars' do               # Documentation refers to the Car model
  # Headers that will be sent in every request.
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  # Describe URL and parameters for a cars list request.
  # As a second parameter we pass request description.
  # REST APIs requests may have the same paths, but differ by HTTP method,
  # we extract a path to a parent block, so descendant blocks can describe each method
  route '/api/v1/cars?{page,per_page}', 'Cars Collection' do
    # List of optional parameters with description for request
    parameter :page, 'Current page of cars'
    parameter :per_page, 'Number of cars on a single page'

    # Testing GET /api/v1/cars request.
    get 'Returns all cars' do
      # Creation of some test data.
      let!(:volkswagen) { Car.create(:brand => 'Vokswagen', :name => 'Polo', :year => 2011) }
      let!(:subaru) { Car.create(:brand => 'Subaru', :name => 'Impeza', :year => 2015) }

      # Let’s test two cases
      context 'without page params' do
        # This block plays role of ‘it’ block from RSpec - the test scenario starts her
        # example_request makes request defined by ancestor blocks (GET /api/v1/cars) implicitly, so we don’t have to call do_request method
        example_request 'Get a list of all cars ordered DESC by year' do
          expect(status).to eq(200)
          # response_body returns a response body in string format
          expect(response_body).to eq(json_collection([subaru, volkswagen]))
        end
      end

      context 'with page params' do
        let(:page) { 1 }
        let(:per_page) { 1 }
        # Here we calling do_request method explicitly.
        # :document => false will match this example as a test only spec and not include it in the output doc.
        example 'Getting a paged list of cars ordered DESC by year', :document => false do
           # We are passing extra pagination parameters to the request.
          do_request(page: page, per_page: per_page)
          expect(status).to eq(200)
          expect(response_body).to eq(json_collection([subaru]))
        end
      end
    end
  end

  route '/api/v1/cars', 'Creation of car' do
    # Attribute defines what attributes you can send in the request body.
    # Option :required makes the parameter mandatory.
    attribute :name, "Car’s name"
    attribute :brand, "Car’s band", :required => true
    attribute :year, 'Year of production'

    post 'Add a car' do
      let(:name)  { 'Passat' }
      let(:year)  { 2010 }
      let(:request) { { car: { name: name, brand: brand, year: year } } }

      context 'with an invalid brand' do
        let(:brand) { nil }
        example 'Fails when missing params' do
          do_request(request)
          expect(Car.any?).to eq false
          expect(status).to eq(400)
        end
      end

      context 'with a valid brand' do
        let(:brand) { 'Vokswagen' }

        example 'Creating a car' do
          do_request(request)
          expect(response_body).to eq(json_item(Car.last))
          expect(status).to eq(201)
        end
      end
    end
  end

  # Requests on a single car.
  route '/api/v1/cars/:id', "Single Car" do
    # Options :type and :example are self-explanatory.
    parameter :id, 'Car id', required: true, type: 'string', :example => '1'

    delete 'Deletes a specific car' do
      let(:id) { Car.create(:brand => 'Renault', :name => 'Megane', :year => 2016).id }

      # Here again, we calling request in an implicit manner.
      # The :id parameter is fetched from the let statement.
      example_request 'Deleting a car' do
        expect(status).to eq(204)
        expect(response_body).to eq('')
        expect(Car.any?).to eq false
      end
    end
  end

  protected

  def json_collection(collection)
    ActiveModel::Serializer::CollectionSerializer.new(collection, serializer: Api::V1::CarSerializer).to_json
  end

  def json_item(item)
    Api::V1::CarSerializer.new(item).to_json
  end
end
