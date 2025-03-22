namespace :airtable do
  desc "Fetch and print Airtable schema for Approved Projects"
  task fetch_schema: :environment do
    schema = AirtableService.instance.get_table_schema("Approved Projects")
    puts JSON.pretty_generate(schema)
  end
end 