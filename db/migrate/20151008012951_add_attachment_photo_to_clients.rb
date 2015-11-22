class AddAttachmentPhotoToClients < ActiveRecord::Migration
  def self.up
    change_table :clients do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :clients, :photo
  end
end
