module Hyrax
  module Workflow
    ##
    # This is not needed as we do it as a part of registering the DOI
    # Register date work is published and publisher
    module RegisterPublishMetadata
      def self.call(target:, **)
        model = target.try(:model) || target
        complex_date = [{date: Date.today.strftime('%d/%m/%Y'), description: "Published"}]

        target.complex_date = model.complex_date + [complex_date]
        target.publisher = [ENV.fetch('DATASET_PUBLISHER', 'RUB')]
      end
    end
  end
end
