class AddSettingsToUser < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    add_column :users, :settings, :hstore
  end
end
