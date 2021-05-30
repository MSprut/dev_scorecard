class CreateRepos < ActiveRecord::Migration[5.2]
  def change
    create_table :repos do |t|
      t.string :owner
      t.string :repo

      t.timestamps
    end
  end
end
