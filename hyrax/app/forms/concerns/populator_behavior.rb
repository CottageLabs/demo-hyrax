# frozen_string_literal: true

module PopulatorBehavior

  private
  def complex_person_populator(fragment:, **_options)
    adds = []
    fragment.each do |_, h|
      person_hash = h.slice("role", "orcid", "last_name", "first_name", "affiliation")
      person_hash = person_hash.permit!.to_h.to_hash if person_hash.is_a?(ActionController::Parameters)

      person_hash = person_hash.transform_keys(&:to_sym)
      if h["_destroy"] != "1" && !all_values_empty?(person_hash) && validate_complex_person?(person_hash)
        adds << person_hash
      end
    end
    self.complex_person = adds.uniq
  end

  def complex_funding_reference_populator(fragment:, **_options)
    adds = []
  
    fragment.each do |_, h|
      reference_hash = h.slice("funder_identifier", "funder_name", "award_number", "award_uri", "award_title")
      reference_hash = reference_hash.permit!.to_h.to_hash if reference_hash.is_a?(ActionController::Parameters)
      reference_hash = reference_hash.transform_keys(&:to_sym) 
      if h["_destroy"] != "1" && !all_values_empty?(reference_hash)
        adds << reference_hash
      end
    end
    self.complex_funding_reference = adds.uniq
  end

  def complex_relation_populator(fragment:, **_options)
    adds = []
  
    fragment.each do |_, h|
      relation_hash = h.slice("title", "url", "relationship")
      relation_hash = relation_hash.permit!.to_h.to_hash if relation_hash.is_a?(ActionController::Parameters)
      relation_hash = relation_hash.transform_keys(&:to_sym)
      if h["_destroy"] != "1" && !all_values_empty?(relation_hash)
        adds << relation_hash
      end
    end
    self.complex_relation = adds.uniq
  end

  def complex_date_populator(fragment:, **_options)
    adds = []

    fragment.each do |_, h|
      date_hash = h.slice("date", "description")
      date_hash = date_hash.permit!.to_h.to_hash if date_hash.is_a?(ActionController::Parameters)
      date_hash = date_hash.transform_keys(&:to_sym)
      if h["_destroy"] != "1" && !all_values_empty?(date_hash)
        adds << date_hash
      end
    end
    self.complex_date = adds.uniq
  end

  def complex_identifier_populator(fragment:, **_options)
    adds = []
  
    fragment.each do |_, h|
      identifier_hash = h.slice("identifier", "scheme","label")
      identifier_hash = identifier_hash.permit!.to_h.to_hash if identifier_hash.is_a?(ActionController::Parameters)
      identifier_hash = identifier_hash.transform_keys(&:to_sym)
      if h["_destroy"] != "1" && !all_values_empty?(identifier_hash)
        adds << identifier_hash
      end
    end
    self.complex_identifier = adds.uniq
  end

  def validate_complex_person?(person_hash)
    person_hash[:first_name].present? && person_hash[:last_name].present? && person_hash[:role].present?
  end

  def all_values_empty?(data_hash)
    data_hash.values.flatten.all?(&:empty?)
  end
end