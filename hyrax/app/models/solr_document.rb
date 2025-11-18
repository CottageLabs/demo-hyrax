# frozen_string_literal: true

# Represents a single document returned from Solr
class SolrDocument
  include Blacklight::Solr::Document
  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds Hyrax behaviors to the SolrDocument.
  include Hyrax::SolrDocumentBehavior


  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  # Do content negotiation for AF models.

  use_extension( Hydra::ContentNegotiation )

  def record_info
    self['record_info_tesim']
  end

  def place_of_publication
    self['place_of_publication_tesim']
  end

  def genre
    self['genre_tesim']
  end

  def series_title
    self['series_title_tesim']
  end

  def target_audience
    self['target_audience_tesim']
  end

  def table_of_contents
    self['table_of_contents_tesim']
  end

  def date_of_issuance
    self['date_of_issuance_tesim']
  end

  def complex_person
    self['complex_person_ssm']
  end

  def tombstone_status
    self["tombstone_status_ssim"]
  end

  def is_tombstoned
    self["is_tombstoned_ssim"]
  end

  def tombstone_date
    self["tombstone_date_ssim"]
  end

  def proxy_depositor
    self["proxy_depositor_ssim"]
  end

  def complex_date
    self["complex_date_ssm"]
  end

  def complex_funding_reference
    self["complex_funding_reference_ssm"]
  end

  def complex_identifier
    self["complex_identifier_ssm"]
  end

  def complex_relation
    self["complex_relation_ssm"]
  end

  def for_complex_identifier
    self["for_complex_identifier_tesim"]
  end

  def dataset_method
    self["dataset_method_tesim"]
  end

  def series_information
    self["series_information_tesim"]
  end

  def technical_information
    self["technical_information_tesim"]
  end

  def software_version
    self["software_version_tesim"]
  end

  def doi
    self["doi_ssim"]
  end

  def sipity_entity
    @sipity_entity ||= Sipity::Entity(self)
  end

  def workflow_state
    sipity_entity.workflow_state.name
  end
end
