# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work_resource Monograph`
class MonographIndexer < Hyrax::Indexers::PcdmObjectIndexer(Monograph)
  include Hyrax::Indexer(:basic_metadata)
  include Hyrax::Indexer(:monograph)

  # Uncomment this block if you want to add custom indexing behavior:
   def to_solr
     super.tap do |index_document|
       index_document.compact_blank
     end
   end
end
