class RevertUuids < ActiveRecord::Migration[5.0]
  def change
    %w{authors comments homepages lists papers references users}.each do |table|
      remove_column table, :id
      add_column table, :id, :integer

      execute("ALTER TABLE \"#{table}\" ADD PRIMARY KEY (id);")

      execute("CREATE sequence #{table}_id_seq START WITH 1;")

      execute("ALTER TABLE \"#{table}\" ALTER id SET DEFAULT nextval('#{table}_id_seq');")
    end
  end
end

