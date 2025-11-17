module CommonQuery
  extend ActiveSupport::Concern

  def parent_collections
    return [] unless self.persisted?
    Hyrax.query_service.custom_queries.find_parent_collections(resource: self)
  end

  def parent_work
    Hyrax.custom_queries.find_parent_work(resource: self)
  end 

  def child_file_sets
    file_sets.select { |fs| fs.for_complex_type == 'Crc1280Experiment' }
  end

  def file_sets
    Hyrax.custom_queries.find_child_file_sets(resource: self)
  end 

  # save resource
  def save
    Hyrax.persister.save(resource: self)
  end

  def save_acl
    permission_manager&.acl.save
  end

  def save_index
    Hyrax.index_adapter.save(resource: self)
  end 
  

  # delete resource
  def delete
    Hyrax.persister.delete(resource: self)
  end 

  def delete_index
    Hyrax.index_adapter.delete(resource: self)
  end 


  # clss methods 
  class_methods do
    def find_by(**args)
      conditions = ["metadata @> ?"]
      id = args.delete(:id)
      jsonb_query = args.to_json

      if id.present?
        if valid_uuid?(id)
          conditions << "id = '#{id}'"
        else
          raise Valkyrie::Persistence::ObjectNotFoundError, "Invalid or missing UUID for id=#{id}"
        end
      end

      conditions << "internal_resource = '#{name}'"

      query = <<-SQL
        SELECT * FROM orm_resources
        WHERE #{conditions.join(' AND ')};
      SQL

      Hyrax.query_service.run_query(query, jsonb_query).first
    end

    def where(**args)
      query = <<-SQL
        SELECT * FROM orm_resources
        WHERE metadata @> ?
        AND internal_resource = '#{name}';
      SQL

      jsonb_query = args.to_json
      Hyrax.query_service.run_query(query, jsonb_query).to_a
    end

    def find(id)
      unless id.present? && valid_uuid?(id)
        raise Valkyrie::Persistence::ObjectNotFoundError, "Invalid or missing UUID for id=#{id}"
      end
    
      result = find_by(id: id)
    
      if result.nil?
        raise Valkyrie::Persistence::ObjectNotFoundError, "Couldn't find resource with id=#{id}"
      end
    
      result
    end

    def valid_uuid?(string)
      uuid_regex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i
      uuid_regex.match?(string)
    end
  end
end
