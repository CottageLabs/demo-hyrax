# Generated via
#  `rails generate hyrax:work Dataset`
module Hyrax
  class DatasetPresenter < Hyrax::WorkShowPresenter
    delegate :complex_person, :complex_date, :complex_relation, :software_version, :dataset_method, :series_information,
             :table_of_contents, :technical_information, :based_near_label, :complex_funding_reference, :complex_identifier,
             :doi, :tombstone_status, :tombstone_date, :is_tombstoned, :proxy_depositor, :files_size, to: :solr_document
  end
end
