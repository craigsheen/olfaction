class CreatePullRequests < ActiveRecord::Migration
  def change
    create_table :pull_requests do |t|
      t.string :reek_smells, default: 0
      t.string :url

      t.timestamps null: false
    end
  end
end
