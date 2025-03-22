require 'singleton'

class AirtableService
  include Singleton

  BASE_URL = "https://api.airtable.com/v0"

  def initialize
    @pat = Rails.application.credentials.airtable.pat
    @base_id = Rails.application.credentials.airtable.ysws.base_id
    @client = HTTPX.plugin(:persistent)
                   .with_headers(
                     Authorization: "Bearer #{@pat}",
                     "Content-Type": "application/json"
                   )
  end

  def get_table_schema(table_name)
    response = @client.get("#{BASE_URL}/meta/bases/#{@base_id}/tables")
    JSON.parse(response.body)["tables"].find { |t| t["name"] == table_name }
  end

  def list_records(table_id, params = {})
    response = @client.get("#{BASE_URL}/#{@base_id}/#{table_id}", params: params)
    JSON.parse(response.body)
  end
end 