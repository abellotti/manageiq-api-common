module TenancyConcern
  extend ActiveSupport::Concern

  included do
    belongs_to :tenant
    # acts_as_tenant :tenant
  end

  def as_json(*)
    super.except("tenant_id").tap do |hash|
      hash["tenant"] = tenant.external_tenant
    end
  end
end
