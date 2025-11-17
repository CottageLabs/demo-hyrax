module Hyrax
  module Workflow
    ##
    # This is a built in function for workflow, so that a workflow action can be created that
    # Register date work is archived
    module RegisterArchiveDate
      def self.call(target:, **)
        model = target.try(:model) || target
        complex_date = [{date: Date.today.strftime('%d/%m/%Y'), description: "Archived"}]
        
        target.complex_date = model.complex_date + [complex_date]
      end
    end
  end
end
