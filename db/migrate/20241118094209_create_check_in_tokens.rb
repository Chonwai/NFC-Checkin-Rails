# frozen_string_literal: true

class CreateCheckInTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :check_in_tokens, &:timestamps
  end
end
