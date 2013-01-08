class CreateNikonikoHistories < ActiveRecord::Migration
  def up
    create_table :nikoniko_histories do |t|
      t.references("user")
      t.column "date", :date, :null => false
      t.column "niko", :"CHAR(1)", :null => false
      t.column "comment", :string, :limit => 140
    end
    
    # add unique index
    add_index :nikoniko_histories, [:user_id, :date], :unique => true
    
    # add foreign key
    execute "ALTER TABLE nikoniko_histories ADD CONSTRAINT `fk_:nikoniko_histories_on_user_id` FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE"
  end
  
  def down
    drop_table :nikoniko_histories
  end
end
