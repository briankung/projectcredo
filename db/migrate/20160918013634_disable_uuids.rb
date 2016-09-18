class DisableUuids < ActiveRecord::Migration[5.0]
  def change
    disable_extension 'uuid-ossp'
  end
end
