class CreateCheckInTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :check_in_tokens do |t|

      t.timestamps
    end
  end
end
