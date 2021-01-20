class RemoveOldWorkSamples < ActiveRecord::Migration[6.0]
  def up
    ActiveStorage::Attachment.where(name: 'work_sample').map(&:purge)
  end
end
