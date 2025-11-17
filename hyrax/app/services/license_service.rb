# Provide select options for analysis fields
class LicenseService < QaSelectServiceExtended
  def initialize(_authority_name = nil)
    super('licenses')
  end
end
