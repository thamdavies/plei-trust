# frozen_string_literal: true

# Migration responsible for creating a table with activities
class CreateActivities < ActiveRecord::Migration[6.1]
  def self.up
    create_table :activities, id: :uuid, default: 'uuidv7()' do |t|
      t.belongs_to :trackable, polymorphic: true, type: :uuid
      t.belongs_to :owner, polymorphic: true, type: :uuid
      t.string :key
      t.jsonb :parameters, default: {}
      t.belongs_to :recipient, polymorphic: true, type: :uuid
      t.belongs_to :branch, type: :uuid

      t.timestamps
    end

    add_index :activities, %i[branch_id trackable_id trackable_type], name: 'index_activities_on_branch_and_trackable'
    add_index :activities, %i[trackable_id trackable_type]
    add_index :activities, %i[owner_id owner_type]
    add_index :activities, %i[recipient_id recipient_type]
  end

  # Drop table
  def self.down
    drop_table :activities
  end
end
