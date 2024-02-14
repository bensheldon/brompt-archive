# https://stackoverflow.com/a/31289295/241735
class Rails::MailersController
  alias_method :preview_orig, :preview

  def preview
    ActiveRecord::Base.transaction do
      preview_orig
      raise ActiveRecord::Rollback
    end
  end
end
