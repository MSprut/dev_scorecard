class CreatePullStatistics < ActiveRecord::Migration[5.2]
  def change
    create_table :pull_statistics do |t|
      t.integer :contributor_id
      t.integer :pulls_count
      t.integer :reviews_count
      t.string :comments_count
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
