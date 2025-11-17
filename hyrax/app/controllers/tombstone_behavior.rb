module TombstoneBehavior
  extend ActiveSupport::Concern
  included do
    before_action :check_tombstone, only: [:show, :edit]
  end

  private

  def check_tombstone
    #@dataset =  Dataset.find(params[:id])

    if current_user.nil?
      if curation_concern.is_tombstoned == true
        flash[:notice] = t(:'hyrax.works.tombstone')
        render 'shared/tombstone', locals: {work: curation_concern}, status: :unauthorized
      end
    elsif current_user.admin? || current_user.is_depositor_for?(curation_concern)
      if curation_concern.is_tombstoned == true && params[:action] == 'edit'
        flash[:notice] = t(:'hyrax.works.tombstone_edit')
        redirect_to main_app.polymorphic_path(curation_concern)
      end
    else
      if curation_concern.is_tombstoned == true
        flash[:notice] = t(:'hyrax.works.tombstone')
        render 'shared/tombstone', locals: {work: curation_concern}, status: :unauthorized
      end
    end
  end
end