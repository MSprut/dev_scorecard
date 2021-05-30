class CreateContributors < ActiveRecord::Migration[5.2]
  def change
    create_table :contributors do |t|
      t.integer :repo_id
      t.integer :github_id
      t.string :login
      t.integer :contributions

      t.timestamps
    end
  end
end
