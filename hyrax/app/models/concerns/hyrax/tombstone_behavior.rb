# frozen_string_literal: true
module Hyrax
  module TombstoneBehavior
    def intialize_tombstone!(user)
      self.is_tombstoned = true 
      self.tombstone_status = "initiated"
      self.tombstone_date = DateTime.now
      work = self.save
      Hyrax.publisher.publish('object.metadata.updated', object: work, user: user)
    end
  
    def confirm_tombstone!(user)
      return false unless self.is_tombstoned || self.tombstone_status == "initiated"
  
      self.tombstone_status = "deleted"
      work = self.save
      Hyrax.publisher.publish('object.metadata.updated', object: work, user: user)

      Hyrax::RemoveAssociatedObjectsJob.perform_later(work.id.to_s, user.id)
      
    end
  
    def restore_tombstone!(user)
      return false if self.tombstone_status == "deleted"
  
      self.is_tombstoned = false
      self.tombstone_status = "restored"
      work = self.save
      Hyrax.publisher.publish('object.metadata.updated', object: work, user: user)
    end
  end
end