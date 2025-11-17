module AdminSetHelper
  def self.find_by(**args)
    query = <<-SQL
      SELECT * FROM orm_resources
      WHERE metadata @> ?
      AND internal_resource = 'Hyrax::AdministrativeSet';
    SQL
  
    jsonb_query = args.to_json

    Hyrax.query_service.run_query(query, jsonb_query).first
  end
end